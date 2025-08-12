local enabled = false
local chatMessagesEnabled = true
AutoDeleteJunkDB = AutoDeleteJunkDB or {junkList = {}}
local junkList = AutoDeleteJunkDB.junkList

-- Slash command handler
SLASH_JUNK1 = "/junk"
SlashCmdList["JUNK"] = function(msg)
    local command, itemName = msg:match("^(%S+)%s*(.*)$")
    command = string.lower(command or "")

    if command == "on" then
        enabled = true
        if chatMessagesEnabled then
            print("|cff00ff00AutoDeleteJunk: Enabled|r")
        end
    elseif command == "off" then
        enabled = false
        if chatMessagesEnabled then
            print("|cffff0000AutoDeleteJunk: Disabled|r")
        end
    elseif command == "chat" then
        if itemName == "on" then
            chatMessagesEnabled = true
            print("|cff00ff00AutoDeleteJunk: Chat Messages Enabled|r")
        elseif itemName == "off" then
            chatMessagesEnabled = false
            print("|cffff0000AutoDeleteJunk: Chat Messages Disabled|r")
        else
            print("|cffffff00Usage:|r /junk chat on | /junk chat off")
        end
    elseif command == "add" then
        local name = GameTooltipTextLeft1 and GameTooltipTextLeft1:GetText()
        if name then
            junkList[name] = true
            AutoDeleteJunkDB.junkList = junkList
            if chatMessagesEnabled then
                print("|cffff0000Added to Junk List:|r " .. name)
            end
        else
            print("|cffff0000Error:|r Hover over an item in your bags first.")
        end
    elseif command == "remove" then
        local name
        if itemName and itemName ~= "" then
            name = itemName
        else
            name = GameTooltipTextLeft1 and GameTooltipTextLeft1:GetText()
        end

        if name and junkList[name] then
            junkList[name] = nil
            AutoDeleteJunkDB.junkList = junkList
            if chatMessagesEnabled then
                print("|cff00ff00Removed from Junk List:|r " .. name)
            end
        else
            if itemName and itemName ~= "" then
                print("|cffff0000Error:|r '" .. itemName .. "' not in junk list.")
            else
                print("|cffff0000Error:|r Item not in junk list or not hovered.")
            end
        end
    elseif command == "list" then
        if chatMessagesEnabled then
            print("|cffffff00Current Junk List:|r")
            local count = 0
            for itemName in pairs(junkList) do
                print(" - " .. itemName)
                count = count + 1
            end
            if count == 0 then print(" (Empty)") end
        end
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
                    if chatMessagesEnabled then
                        print("|cffff0000Deleted:|r " .. link)
                    end
                end
            end
        end
    end
end)