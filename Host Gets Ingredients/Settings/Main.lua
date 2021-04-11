HGI = HGI or { }
HGI.Settings = HGI.Settings or { }

HGI.Settings.Path = HGI.Path .. "Settings/"
local savePath = SavePath .. "HGI.txt"

HGI.Settings.SavedData =
{
  Infinite = false
}

function HGI.Settings:Load()
  local file = io.open(savePath, "r")

  if file then
    for k, v in pairs(json.decode(file:read("*all"))) do
      self.SavedData[k] = v
    end

    file:close()
  else
    self:Save()
  end
end

function HGI.Settings:Save()
  local file = io.open(savePath, "w+")

  file:write(json.encode(self.SavedData))
  file:close()
end

Hooks:Add("MenuManagerInitialize", "HGI_Menu", function(MM)
  MenuCallbackHandler.HGI_OnInf = function(self, option)
    HGI.Settings.SavedData.Infinite = option:value() == "on"
    HGI.Settings:Save()
  end

  HGI.Settings:Load()
  MenuHelper:LoadFromJsonFile(HGI.Settings.Path .. "menu.txt", HGI.Settings, HGI.Settings.SavedData)
end)

Hooks:Add("LocalizationManagerPostInit", "HGI_LocalizeInit", function(LM)
  LM:load_localization_file(HGI.Settings.Path .. "en.txt")
end)