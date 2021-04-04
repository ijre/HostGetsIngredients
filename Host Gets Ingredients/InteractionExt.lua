local originalSelected = BaseInteractionExt.can_select
local originalInteracted = UseInteractionExt.interact

function BaseInteractionExt:can_select(player)
  if HGI:IsIngredient(self._tweak_data.special_equipment_block) then
    self._tweak_data.special_equipment_block = nil
  end

  return originalSelected(self, player)
end

function UseInteractionExt:interact(player)
  if self._tweak_data.equipment_consume and HGI:IsIngredient(self._tweak_data.special_equipment) then
    HGIHelpers.PM:AddOrRemoveSpecial(managers.player, self._tweak_data.special_equipment, false)

    self._tweak_data.equipment_consume = nil
    self._tweak_data.special_equipment = nil
  end

  return originalInteracted(self, player)
end