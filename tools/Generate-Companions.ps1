#Requires -Version 5.0
# Transmog AC - Generador de Companions.lua
# Si se cierra solo: ejecuta desde PowerShell (no doble-clic) o mira companions_error.log

param(
    [string]$MysqlHost = "127.0.0.1",
    [int]$MysqlPort = 3306,
    [string]$Database = "acore_world",
    [string]$User = "root",
    [string]$Password = "",
    [string]$MysqlPath = "",
    [string]$OutFile = ""
)

$ErrorActionPreference = "Continue"
$logFile = Join-Path $PSScriptRoot "companions_error.log"

function Log($msg) {
    $line = "$(Get-Date -Format 'HH:mm:ss') $msg"
    Write-Host $line
    Add-Content -Path $logFile -Value $line -ErrorAction SilentlyContinue
}

function Pause-End {
    Write-Host ""
    Write-Host "Pulsa ENTER para cerrar..." -ForegroundColor Yellow
    try { [void](Read-Host) } catch { Start-Sleep -Seconds 8 }
}

try {
    Log "=== Companions Generator ==="

    if (-not $Password) {
        Write-Host "Password MySQL (visible al escribir si falla SecureString):"
        $Password = Read-Host
    }

    $mysql = $null
    if ($MysqlPath -and (Test-Path -LiteralPath $MysqlPath)) {
        $mysql = (Resolve-Path -LiteralPath $MysqlPath).Path
    } else {
        $paths = @(
            "mysql",
            "C:\xampp\mysql\bin\mysql.exe",
            "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
            "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe"
        )
        # Repacks: buscar mysql\bin cerca de unidades
        foreach ($drive in @("C:","D:","E:")) {
            if (Test-Path "$drive\") {
                Get-ChildItem -Path "$drive\" -Filter "mysql.exe" -Recurse -ErrorAction SilentlyContinue |
                    Where-Object { $_.FullName -match '\\mysql\\bin\\mysql\.exe$' } |
                    Select-Object -First 5 | ForEach-Object { $paths += $_.FullName }
            }
        }
        foreach ($p in $paths) {
            if ($p -eq "mysql") {
                $c = Get-Command mysql -ErrorAction SilentlyContinue
                if ($c) { $mysql = $c.Source; break }
            } elseif (Test-Path -LiteralPath $p) { $mysql = $p; break }
        }
    }

    if (-not $mysql) {
        Log "ERROR: mysql.exe no encontrado. Usa -MysqlPath 'D:\...\mysql\bin\mysql.exe'"
        Pause-End; exit 1
    }
    Log "mysql = $mysql"

    if (-not $OutFile) {
        $OutFile = Join-Path $PSScriptRoot "Companions.lua"
    }
    Log "Out = $OutFile"

    $sql = "SELECT CASE WHEN subclass=5 THEN 'MOUNT' WHEN subclass=2 THEN 'CRITTER' ELSE 'OTHER' END AS kind, entry, name, IFNULL(spellid_1,0), IFNULL(spellid_2,0), IFNULL(spellid_3,0), IFNULL(spellid_4,0), IFNULL(spellid_5,0) FROM item_template WHERE class=15 AND subclass IN (2,5) ORDER BY kind, name;"

    $arg = @(
        "-h$MysqlHost",
        "-P$MysqlPort",
        "-u$User",
        "-p$Password",
        "-D$Database",
        "--batch",
        "--raw",
        "--default-character-set=utf8",
        "-e", $sql
    )

    Log "Ejecutando consulta..."
    $allOutput = & $mysql @arg 2>&1
    $exitCode = $LASTEXITCODE
    $text = ($allOutput | Out-String)

    if ($exitCode -ne 0) {
        Log "ERROR mysql exit=$exitCode"
        Log $text
        Pause-End; exit 1
    }

    $mounts = @{}
    $pets = @{}
    foreach ($line in ($text -split "`r?`n")) {
        if ($line -match "^kind\t" -or $line.Trim() -eq "") { continue }
        if ($line -match "Warning") { continue }
        $c = $line -split "`t"
        if ($c.Count -lt 8) { continue }
        $kind = $c[0]
        $entry = 0; [void][int]::TryParse($c[1], [ref]$entry)
        $name = $c[2]
        $spells = @(0,0,0,0,0)
        for ($i=0; $i -lt 5; $i++) { [void][int]::TryParse($c[3+$i], [ref]$spells[$i]) }
        # Preferir spellid_2 luego 1,3,4,5
        $spellId = 0
        foreach ($idx in @(1,0,2,3,4)) {
            if ($spells[$idx] -gt 0) { $spellId = $spells[$idx]; break }
        }
        if ($spellId -le 0) { continue }
        $obj = @{ spellId = $spellId; name = $name; itemId = $entry }
        if ($kind -eq "MOUNT") {
            if (-not $mounts.ContainsKey($spellId)) { $mounts[$spellId] = $obj }
        } elseif ($kind -eq "CRITTER") {
            if (-not $pets.ContainsKey($spellId)) { $pets[$spellId] = $obj }
        }
    }

    Log ("Monturas: {0} | Mascotas: {1}" -f $mounts.Count, $pets.Count)
    if ($mounts.Count -eq 0 -and $pets.Count -eq 0) {
        Log "Sin datos. ¿Database correcta (acore_world)?"
        Pause-End; exit 2
    }

    function Esc([string]$s) {
        if (-not $s) { return "" }
        return ($s -replace '\\','\\' -replace '"','\"' -replace "[\r\n]"," ")
    }

    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("local addon, ns = ...")
    [void]$sb.AppendLine("-- Generate-Companions.ps1 | $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
    [void]$sb.AppendLine("-- Monturas: $($mounts.Count) | Mascotas: $($pets.Count)")
    [void]$sb.AppendLine("ns.CompanionCatalog = ns.CompanionCatalog or {}")
    [void]$sb.AppendLine("ns.CompanionCatalog.MOUNT = {")
    foreach ($e in ($mounts.Values | Sort-Object { $_.name })) {
        [void]$sb.AppendLine("    { spellId = $($e.spellId), name = `"$(Esc $e.name)`", itemId = $($e.itemId) },")
    }
    [void]$sb.AppendLine("}")
    [void]$sb.AppendLine("ns.CompanionCatalog.CRITTER = {")
    foreach ($e in ($pets.Values | Sort-Object { $_.name })) {
        [void]$sb.AppendLine("    { spellId = $($e.spellId), name = `"$(Esc $e.name)`", itemId = $($e.itemId) },")
    }
    [void]$sb.AppendLine("}")

    $dir = Split-Path -Parent $OutFile
    if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    [IO.File]::WriteAllText($OutFile, $sb.ToString(), [Text.UTF8Encoding]::new($false))
    Log "OK -> $OutFile"
    Pause-End
}
catch {
    Log "EXCEPTION: $($_.Exception.Message)"
    Log $_.ScriptStackTrace
    Pause-End
    exit 1
}
