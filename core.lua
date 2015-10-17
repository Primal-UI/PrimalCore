local addonName, addon = ...
addon._G = _G
setfenv(1, addon)

_G[addonName] = addon

debug = true

if debug then
  print = function(...)
    _G.print("|cffff7d0a" .. addonName .. "|r: ", ...)
  end
else
  print = function() end
end

------------------------------------------------------------------------------------------------------------------------
chatFrames = {
  trade = "ChatFrame3",
  chat  = "ChatFrame4",
  sink  = "ChatFrame10",
}
------------------------------------------------------------------------------------------------------------------------

local handlerFrame = _G.CreateFrame("Frame")
handlerFrame:SetScript("OnEvent", function(_, event, ...)
  return addon[event](addon, ...)
end)

function addon:ADDON_LOADED(name)
  if name ~= addonName then return end

  handlerFrame:UnregisterEvent("ADDON_LOADED")

  -- wowprogramming.com/utils/xmlbrowser/test/FrameXML/GameMenuFrame.xml
  -- wowprogramming.com/utils/xmlbrowser/test/FrameXML/GameMenuFrame.lua
  -- GameMenuButtonTemplate: wowprogramming.com/utils/xmlbrowser/test/FrameXML/UIPanelTemplates.xml
  -- UIPanelButtonTemplate: wowprogramming.com/utils/xmlbrowser/test/SharedXML/SharedUIPanelTemplates.xml
  _G.CreateFrame("Button", "GameMenuButtonPrimalUI", _G.GameMenuFrame, "GameMenuButtonTemplate")
  _G.GameMenuButtonPrimalUI:SetPoint("CENTER", _G.GameMenuFrame, "TOP", 0, -42)
  _G.GameMenuButtonPrimalUIText:SetText("|cffff7d0aPrimalUI|r")
  --_G.GameMenuButtonPrimalUIText:SetText("|cff000000PrimalUI|r")
  --_G.GameMenuButtonPrimalUIText:SetText("PrimalUI")
  --_G.GameMenuButtonPrimalUIText:SetShadowColor(1, .49, .04)
  --_G.GameMenuButtonPrimalUIText:SetShadowOffset(1, -1)
  _G.GameMenuButtonHelp:SetPoint("TOP", _G.GameMenuButtonPrimalUI, "BOTTOM", 0, -16)
  _G.hooksecurefunc("GameMenuFrame_UpdateVisibleButtons", function(GameMenuFrame)
    -- 21 is the height of GameMenuButtonTemplate. 16 is the offset to the help button which would normally be the top
    -- button (the same spacing is used in the GameMenuFrame to separate groups of buttons already). I made screenshots
    -- to compare the spacing after the last button of the vanilla and the modified GameMenuFrame (it's fine) and was
    -- suprised to see that the buttons looked very different. Apparently the new size improves their pixel alignment
    -- and they look much more crisp.
    GameMenuFrame:SetHeight(_G.GameMenuFrame:GetHeight() + 21 + 16)
  end)
  _G.GameMenuButtonPrimalUI:SetScript("OnClick", function(self, button, down)
    local loaded, reason = _G.LoadAddOn("PrimalControl")
    if not loaded and reason == "DISABLED" then
      _G.EnableAddOn("PrimalControl")
      loaded, reason = _G.LoadAddOn("PrimalControl")
    end
    if not loaded then
      print(addonName .. ": installing PrimalUI failed: can't load PrimalControl, reason: " .. reason .. " (" ..
        _G["ADDON_" .. reason] .. ")")
    end
    _G.PrimalControl:openPanel()
  end)

  -- wow.gamepedia.com/Creating_a_slash_command
  --[[
  _G.SLASH_PRIMALUI1 = "/primalui"
  _G.SlashCmdList.PRIMALUI = function(message, editBox)
    if message == "install" then
      local loaded, reason = _G.LoadAddOn("PrimalControl")
      if not loaded and reason == "DISABLED" then
        _G.EnableAddOn("PrimalControl")
        loaded, reason = _G.LoadAddOn("PrimalControl")
      end
      if not loaded then
        print(addonName .. ": installing PrimalUI failed: can't load PrimalControl, reason: " .. reason .. " (" ..
          _G["ADDON_" .. reason] .. ")")
        return false
      end
      return true
    end
  end
  ]]

  self.ADDON_LOADED = nil
end

handlerFrame:RegisterEvent("ADDON_LOADED")

-- vim: tw=120 sts=2 sw=2 et
