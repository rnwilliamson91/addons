local button = CreateFrame("Button", "HoverDeleteMinimapButton", Minimap, "MinimapButtonTemplate")
button:SetSize(32, 32)
button:SetPoint("LEFT", Minimap, "RIGHT", 5, 0) -- Adjust the position as needed

-- Set the button's icon and texture
button:SetNormalTexture("Interface\\AddOns\\HoverDelete\\Textures\\Icon") -- You'll need to create a texture file and reference its path here
button:SetPushedTexture("Interface\\AddOns\\HoverDelete\\Textures\\IconPressed")
button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")

-- Create a function to update the button's tooltip and visual state
local function UpdateButtonState()
    if enabled then
        button:SetPushedTexture("Interface\\AddOns\\HoverDelete\\Textures\\IconPressed")
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Hover Delete: |cff00ff00Enabled|r")
            GameTooltip:Show()
        end)
    else
        button:SetPushedTexture("Interface\\AddOns\\HoverDelete\\Textures\\Icon")
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Hover Delete: |cffff0000Disabled|r")
            GameTooltip:Show()
        end)
    end
end

-- Set the button's click handler
button:SetScript("OnClick", function()
    enabled = not enabled
    if enabled then
        print("|cff00ff00HoverDelete: Enabled|r")
    else
        print("|cffff0000HoverDelete: Disabled|r")
    end
    UpdateButtonState()
end)

-- Initial state setup
UpdateButtonState()