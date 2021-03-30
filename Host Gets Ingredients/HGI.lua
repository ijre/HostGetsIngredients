HGI = { }
HGIHelpers = { }

HGI.Ingredients =
{
  "muriatic_acid",
  "acid",
  "hydrogen_chloride",
  "caustic_soda"
}
HGI.CustodyPeer = { }

function HGI:IsIngredient(ingred)
  return table.contains(self.Ingredients, ingred) and LuaNetworking:IsHost()
end

dofile(ModPath .. "Helpers/HGIHelpersInit.lua")