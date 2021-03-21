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
  return table.contains(self.ingredients, ingred) and LuaNetworking:IsHost() and (self.custodyOverride == 0 or not hostOnly)
end