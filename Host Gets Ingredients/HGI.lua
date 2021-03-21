HGI = { }
HGIHelpers = { }

HGI.ingredients =
{
  "muriatic_acid",
  "acid",
  "hydrogen_chloride",
  "caustic_soda"
}
HGI.custodyOverride = { }

function HGI:IsIngredient(ingred)
  return table.contains(self.ingredients, ingred) and LuaNetworking:IsHost()
end

dofile(ModPath .. "Helpers/HGIHelpersInit.lua")