local addon, ns = ...

-- TransmogTip integrado: tooltips "New Appearance" + lista de desbloqueados
-- Basado en transmogTip by ZhengPeiRu21 - https://github.com/ZhengPeiRu21/transmog-addons
-- (coleccion por equipo + TRANSMOG_SYNC)

TransmogTipList = TransmogTipList or {}

local function tContainsId(list, id)
    if type(list) ~= "table" or not id then return false end
    for i = 1, #list do
        if list[i] == id then return true end
    end
    return list[id] == true
end

local function addToTipList(itemID)
    itemID = tonumber(itemID)
    if not itemID then return end
    if not tContainsId(TransmogTipList, itemID) then
        table.insert(TransmogTipList, itemID)
    end
    if ns and ns.UnlockAppearance then
        ns.UnlockAppearance(itemID)
    elseif ns and ns.UnlockedAppearances then
        ns.UnlockedAppearances[itemID] = true
    end
end

local function isEquippableTracked(itemId)
    if not itemId or not IsEquippableItem(itemId) then return false end
    local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemId)
    if not equipLoc then return true end -- info not cached yet; allow
    if equipLoc == "INVTYPE_AMMO" or equipLoc == "INVTYPE_NECK"
        or equipLoc == "INVTYPE_FINGER" or equipLoc == "INVTYPE_TRINKET"
        or equipLoc == "INVTYPE_BAG" or equipLoc == "INVTYPE_QUIVER" then
        return false
    end
    return true
end

local function addNewAppearanceLine(self)
    local text = (ns.L and ns.L.NEW_APPEARANCE) or "|cfff194f7New Appearance|r"
    self:AddLine(text)
    self:Show()
end

local function attachItemTooltip(self)
    local name, link = self:GetItem()
    if not link then return end
    local id = tonumber(link:match("item:(%-?%d+)"))
    if not id then return end
    if not isEquippableTracked(id) then return end
    if tContainsId(TransmogTipList, id) then return end
    if ns.IsAppearanceUnlocked and ns.IsAppearanceUnlocked(id) then return end
    addNewAppearanceLine(self)
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
if ItemRefShoppingTooltip1 then ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip) end
if ItemRefShoppingTooltip2 then ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip) end
if ShoppingTooltip1 then ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip) end
if ShoppingTooltip2 then ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip) end

local tipFrame = CreateFrame("Frame")
tipFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
tipFrame:RegisterEvent("ADDON_LOADED")
tipFrame:RegisterEvent("PLAYER_LOGIN")
tipFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == addon then
            TransmogTipList = TransmogTipList or {}
        end
    elseif event == "PLAYER_LOGIN" then
        -- Fusionar lista tip -> desbloqueados del vestidor
        if ns.MergeUnlockTable then
            ns.MergeUnlockTable(TransmogTipList)
        end
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        local itemID = GetInventoryItemID("player", arg1)
        if itemID then
            addToTipList(itemID)
        end
    end
end)

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(_, _, msg)
    if type(msg) ~= "string" then return end
    local idStr = msg:match("TRANSMOG_SYNC:(%d+)")
    if idStr then
        addToTipList(tonumber(idStr))
        return true
    end
end)

ns.TransmogTip = true
