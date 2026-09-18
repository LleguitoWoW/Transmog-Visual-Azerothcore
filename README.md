# Transmog AzerothCore

**Language / Idioma:** [English](#english) · [Español](#español)

Wardrobe and transmog collection addon for **World of Warcraft 3.3.5** private servers (**AzerothCore** / WotLK).

Based on [DressMe](https://github.com/GetLocalPlayer/DressMe) by **GetLocalPlayer**, with **TransmogTip** ideas from **[ZhengPeiRu21](https://github.com/ZhengPeiRu21/transmog-addons)**, modified and unified by **Lleguito** for private-server unlocked appearances.

---

## English

### Features

| Feature | Description |
|--------|-------------|
| **Full catalog** | Browse appearances from `db/Items.lua` (generated from your realm’s `item_template` if needed) |
| **Unlocked filter** | **All** / **Unlocked** — show everything or only collected looks |
| **Visual states** | ✓ on unlocked · dimmed + lock on locked · click blocked if not unlocked |
| **Live sync** | `TRANSMOG_SYNC:<itemId>` system messages, equip events, and optional TransmogTip list |
| **Progress bar** | Unlocked / total for the current slot & armor type |
| **Saved looks** | Save, load, and try full outfits (Appearances tab) |
| **Minimap button** | Open/close and drag around the minimap |
| **Languages** | English / Español (Settings) |
| **Debug log** | Optional technical chat log (Settings) |

> **Note:** Collection data comes from the server (`TRANSMOG_SYNC` / equip / TransmogTip), **not** from exporting a Lua file every time. A static export remains optional for offline setups.

### Requirements

- Client **3.3.5a** (Interface `30300`)
- Private server with transmog / unlocked appearances (AzerothCore custom tables recommended)
- Optional: server messages in the form `TRANSMOG_SYNC:<itemId>` when an appearance is unlocked

### Installation

1. Download or clone this repository.
2. Copy the folder **`TransmogAzerothCore`** into:

```text
World of Warcraft\Interface\AddOns\TransmogAzerothCore
```

3. Restart the client or `/reload`.
4. Open with **`/transmog`** or the minimap button.

### Commands

| Command | Action |
|---------|--------|
| `/transmog` | Open / close the wardrobe |
| `/transmogminimap` | Show / hide the minimap button |

### Tabs

1. **Items Preview** — slot paperdoll, catalog grid, filters, progress  
2. **Appearances** — saved looks  
3. **Settings** — background color, language (EN/ES), character button, debug log, credits  

### Unlock sources

1. System chat: `TRANSMOG_SYNC:<itemId>` (hidden from chat when processed)  
2. Equipping an item  
3. SavedVariables: `TransmogTipList` (integrated TransmogTip logic)  
4. Optional static entries in `db/UnlockedAppearances.lua`  

### Customizing the item database

`db/Items.lua` holds the appearance catalog. You can:

- Use the file shipped with the addon, or  
- Regenerate it from your realm’s `item_template` (PowerShell / SQL tools used on AzerothCore panels)

Without a valid `Items.lua`, the grid will be empty or incomplete.

### Credits

| Role | Author | Link |
|------|--------|------|
| **Original (DressMe)** | GetLocalPlayer | [github.com/GetLocalPlayer/DressMe](https://github.com/GetLocalPlayer/DressMe) |
| **TransmogTip** (tooltips / collection) | ZhengPeiRu21 | [github.com/ZhengPeiRu21/transmog-addons](https://github.com/ZhengPeiRu21/transmog-addons) |
| **Modification / AzerothCore** | Lleguito | [github.com/LleguitoWoW](https://github.com/LleguitoWoW) |

Includes integrated **TransmogTip** logic (*New Appearance* tooltips, equip tracking, `TRANSMOG_SYNC`) from ZhengPeiRu21’s transmog-addons pack.

### License / disclaimer

This project is a modification of DressMe for private-server use. Respect the original author’s work and your server’s rules. Not affiliated with Blizzard Entertainment.

---

## Español

### Características

| Función | Descripción |
|---------|-------------|
| **Catálogo completo** | Apariencias desde `db/Items.lua` (puede generarse desde `item_template` del reino) |
| **Filtro** | **Todo** / **Desbloqueadas** |
| **Estados visuales** | ✓ desbloqueada · atenuada + candado si no · clic bloqueado si no la tienes |
| **Sync en vivo** | Mensajes `TRANSMOG_SYNC:<itemId>`, equipar, y lista tipo TransmogTip |
| **Barra de progreso** | Desbloqueadas / total del hueco y tipo de armadura |
| **Looks guardados** | Guardar, cargar y probar conjuntos (pestaña Apariencias) |
| **Minimapa** | Abrir/cerrar y arrastrar |
| **Idiomas** | Inglés / Español (Ajustes) |
| **Log de depuración** | Opcional en el chat (Ajustes) |

> **Nota:** La colección sale del servidor (`TRANSMOG_SYNC` / equipo / TransmogTip), **no** hace falta exportar un `.lua` cada vez. El export sigue siendo opcional.

### Requisitos

- Cliente **3.3.5a** (Interface `30300`)
- Servidor privado con transmog / apariencias desbloqueadas (tablas custom de AzerothCore recomendadas)
- Opcional: mensajes `TRANSMOG_SYNC:<itemId>` al desbloquear

### Instalación

1. Descarga o clona el repositorio.
2. Copia la carpeta **`TransmogAzerothCore`** en:

```text
World of Warcraft\Interface\AddOns\TransmogAzerothCore
```

3. Reinicia el cliente o `/reload`.
4. Abre con **`/transmog`** o el botón del minimapa.

### Comandos

| Comando | Acción |
|---------|--------|
| `/transmog` | Abrir / cerrar el vestidor |
| `/transmogminimap` | Mostrar / ocultar el botón del minimapa |

### Pestañas

1. **Vista previa** — paperdoll, rejilla, filtros, progreso  
2. **Apariencias** — looks guardados  
3. **Ajustes** — color de fondo, idioma, botón de personaje, log, créditos  

### Fuentes de desbloqueo

1. Chat de sistema: `TRANSMOG_SYNC:<itemId>`  
2. Equipar un objeto  
3. SavedVariables: `TransmogTipList`  
4. Entradas opcionales en `db/UnlockedAppearances.lua`  

### Base de datos de items

`db/Items.lua` es el catálogo. Puedes usar el incluido o regenerarlo desde `item_template` de tu servidor.

### Créditos

| Rol | Autor | Enlace |
|-----|--------|--------|
| **Original (DressMe)** | GetLocalPlayer | [github.com/GetLocalPlayer/DressMe](https://github.com/GetLocalPlayer/DressMe) |
| **TransmogTip** (tooltips / colección) | ZhengPeiRu21 | [github.com/ZhengPeiRu21/transmog-addons](https://github.com/ZhengPeiRu21/transmog-addons) |
| **Modificación / AzerothCore** | Lleguito | [github.com/LleguitoWoW](https://github.com/LleguitoWoW) |

Incluye lógica integrada de **TransmogTip** (*Nueva apariencia*, seguimiento al equipar, `TRANSMOG_SYNC`) del pack transmog-addons de ZhengPeiRu21.

### Aviso

Modificación de DressMe para uso en servidores privados. Respeta el trabajo del autor original y las normas de tu servidor. No afiliado a Blizzard Entertainment.

---

## Structure

```text
TransmogAzerothCore/
├── TransmogAzerothCore.toc
├── TransmogAzerothCore.lua    # Main UI
├── TransmogTip.lua            # Tooltips + TRANSMOG_SYNC + equip tracking
├── Locale.lua                 # en / es
├── PreviewList.lua
├── DressingRoom.lua
├── ListFrame.lua
├── QueryItem.lua
├── WowheadURL.lua
├── db/
│   ├── Items.lua              # Appearance catalog
│   ├── PreviewSetup.lua
│   └── UnlockedAppearances.lua
└── images/
    └── mirror-border.tga
```

## Version

**1.3.0** — Interface 30300 (WotLK 3.3.5)

## Imagenes

<img width="1366" height="715" alt="WoWScrnShot_091826_171818" src="https://github.com/user-attachments/assets/33dd3193-4a78-4248-95e5-71e209edfa89" />
<img width="1366" height="715" alt="WoWScrnShot_091826_171758" src="https://github.com/user-attachments/assets/d2fa2829-7640-477a-b0e8-57962f10f0e3" />

