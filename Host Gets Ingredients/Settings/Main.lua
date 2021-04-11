HGI = HGI or { }
HGI.Settings = HGI.Settings or { }

local base = ModPath
-- local base = ModPath .. "Host Gets Ingredients/"
HGI.Settings.Paths =
{
  Settings = base .. "Settings/"
}

HGI.Settings.SavedData =
{
  Infinite = false
}

local savePath = SavePath .. "HGI.txt"

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
  MenuHelper:LoadFromJsonFile(HGI.Settings.Paths.Settings .. "menu.txt", HGI.Settings, HGI.Settings.SavedData)
end)

Hooks:Add("LocalizationManagerPostInit", "HGI_LocalizeInit", function(LM)
  LM:load_localization_file(HGI.Settings.Paths.Settings .. "en.txt")
end)