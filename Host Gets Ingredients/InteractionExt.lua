local originalSelected = BaseInteractionExt.can_select

function BaseInteractionExt:can_select(player)
  if HGI:IsIngredient(self._tweak_data.special_equipment_block) then
    self._tweak_data.special_equipment_block = nil
  end

  return originalSelected(self, player)
end