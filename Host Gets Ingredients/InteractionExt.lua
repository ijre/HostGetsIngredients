local originalSelected = BaseInteractionExt.can_select
local originalInteracted = UseInteractionExt.interact

function BaseInteractionExt:can_select(player)
  if HGI:IsIngredient(self._tweak_data.special_equipment_block) then
    self._tweak_data.special_equipment_block = nil
  end

  return originalSelected(self, player)
end

function UseInteractionExt:interact(player)
  local isIngred = false

  if self._tweak_data.equipment_consume and HGI:IsIngredient(self._tweak_data.special_equipment) then
    if not HGI.Settings.SavedData.Infinite then
      HGIHelpers.PM:AddOrRemoveSpecial(self._tweak_data.special_equipment, false)
    end

    self._tweak_data.equipment_consume = nil
    isIngred = true
  end

  local result = originalInteracted(self, player)

  if isIngred then
    self._tweak_data.equipment_consume = true
  end

  return result
end