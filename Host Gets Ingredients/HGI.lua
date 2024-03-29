HGI = { }
HGIHelpers = { }
local MPath = ModPath

local function ShortPath()
  local file = io.open(MPath .. ".gitignore", "r")

  if file then
    file:close()
    return MPath .. "Host Gets Ingredients/"
  else
    return MPath
  end
end

HGI.Path = ShortPath()

HGI.CustodyPeer = { }

HGI.Ingredients =
{
  "muriatic_acid",
  "acid",
  "caustic_soda",
  "hydrogen_chloride"
}

HGI.LabEquipment =
{
  "methlab_bubbling",
  "methlab_caustic_cooler",
  "methlab_gas_to_salt"
}

function HGI:IsIngredient(ingred, checkHost)
  if checkHost == nil then
    checkHost = true
  end

  return table.contains(self.Ingredients, ingred) and (LuaNetworking:IsHost() or not checkHost)
end

function HGI:IsLabEquipment(labEquip)
  if not LuaNetworking:IsHost() or not tweak_data.interaction[labEquip] then
    return nil
  end

  local equip = table.index_of(self.Ingredients, tweak_data.interaction[labEquip].special_equipment)

  if equip ~= -1 then
    equip = self.LabEquipment[equip - 1]
  else
    equip = nil
  end

  return equip
end

dofile(HGI.Path .. "Helpers/HGIHelpersInit.lua")