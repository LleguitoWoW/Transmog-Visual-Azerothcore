local addon, ns = ...

-- Registro en memoria de apariencias desbloqueadas de la cuenta/personaje ACTUAL.
-- Se rellena con: .transmog sync (TRANSMOG_SYNC) + items equipados en sesion.
-- NO hardcodear una cuenta aqui (rompe multicuenta).

ns.UnlockedAppearances = ns.UnlockedAppearances or {}
if type(wipe) == "function" then
    wipe(ns.UnlockedAppearances)
else
    ns.UnlockedAppearances = {}
end

-- false si la lista esta vacia (antes devolvia true = "todo desbloqueado")
function ns.IsAppearanceUnlocked(itemId)
    itemId = tonumber(itemId)
    if not itemId then return false end
    return ns.UnlockedAppearances[itemId] == true
end

function ns.IsAnyIdUnlocked(ids)
    if type(ids) ~= "table" then
        return ns.IsAppearanceUnlocked(ids)
    end
    for i = 1, #ids do
        local id = tonumber(ids[i])
        if id and ns.UnlockedAppearances[id] == true then
            return true
        end
    end
    -- mapa { [id]=true }
    if #ids == 0 then
        for k, v in pairs(ids) do
            if v == true and tonumber(k) and ns.UnlockedAppearances[tonumber(k)] then
                return true
            end
            if tonumber(v) and ns.UnlockedAppearances[tonumber(v)] then
                return true
            end
        end
    end
    return false
end

function ns.UnlockAppearance(itemId)
    itemId = tonumber(itemId)
    if not itemId then return end
    ns.UnlockedAppearances[itemId] = true
end

function ns.MergeUnlockTable(list)
    if type(list) ~= "table" then return end
    if #list > 0 then
        for i = 1, #list do
            local id = tonumber(list[i])
            if id then ns.UnlockedAppearances[id] = true end
        end
    else
        for k, v in pairs(list) do
            if v == true then
                local id = tonumber(k)
                if id then ns.UnlockedAppearances[id] = true end
            else
                local id = tonumber(v)
                if id then ns.UnlockedAppearances[id] = true end
            end
        end
    end
end

function ns.ClearUnlockedAppearances()
    if type(wipe) == "function" then
        wipe(ns.UnlockedAppearances)
    else
        ns.UnlockedAppearances = {}
    end
end
