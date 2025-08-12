local enabled = false
AutoDeleteJunkDB = AutoDeleteJunkDB or {junkList = {}}
local junkList = AutoDeleteJunkDB.junkList

-- Slash command handler
SLASH_JUNK1 = "/junk"
SlashCmdList["JUNK"] = function(msg)
    msg = string.lower(msg or "")
    if msg == "on" then
        enabled = true
        print("|cff00ff00AutoDeleteJunk: Enabled|r")
    elseif msg == "off" then
        enabled = false
        print("|cffff0000AutoDeleteJunk: Disabled|r")
    elseif msg == "add" then
        local name = GameTooltipTextLeft1 and GameTooltipTextLeft1:GetText()
        if name then
            junkList[name] = true
            AutoDeleteJunkDB.junkList = junkList
            print("|cffff0000Added to Junk List:|r " .. name)
        else
            print("|cffff0000Error:|r Hover over an item in your bags first.")
        end
    elseif msg == "remove" then
        local name = GameTooltipTextLeft1 and GameTooltipTextLeft1:GetText()
        if name and junkList[name] then
            junkList[name] = nil
            AutoDeleteJunkDB.junkList = junkList
            print("|cff00ff00Removed from Junk List:|r " .. name)
        else
            print("|cffff0000Error:|r Item not in junk list or not hovered.")
        end
    elseif msg == "list" then
        print("|cffffff00Current Junk List:|r")
        local count = 0
        for itemName in pairs(junkList) do
            print(" - " .. itemName)
            count = count + 1
        end
        if count == 0 then print(" (Empty)") end
    else
        print("|cffffff00Usage:|r /junk on | /junk off | /junk add | /junk remove | /junk list")
    end
end

-- Auto-delete loop
local f = CreateFrame("Frame")
f:RegisterEvent("BAG_UPDATE")
f:SetScript("OnEvent", function()
    if not enabled then return end
    for b = 0, 4 do
        for s = 1, GetContainerNumSlots(b) do
            local link = GetContainerItemLink(b, s)
            if link then
                local name = GetItemInfo(link)
                if name and junkList[name] then
                    PickupContainerItem(b, s)
                    DeleteCursorItem()
                    print("|cffff0000Deleted:|r " .. link)
                end
            end
        end
    end
end)
