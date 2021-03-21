dofile(ModPath .. "../PrintTableDeep/main.lua")

HGI = { }
HGI.ingredients =
{
  "muriatic_acid",
  "acid",
  "hydrogen_chloride",
  "caustic_soda"
}
HGI.custodyOverride = 0

function HGI:IsIngredient(ingred, hostOnly)
  return LuaNetworking:IsHost() and table.contains(self.ingredients, ingred) and (HGI.custodyOverride == 0 or not hostOnly)
end