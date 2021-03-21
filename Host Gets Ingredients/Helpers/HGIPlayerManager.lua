local PMHelper = { }

function PMHelper:AddOrRemoveSpecial(name, add)
  if add == nil then
    return end

  local updateAmount = function(currentAmount)
    return add and currentAmount + 1 or math.max(-1, currentAmount - 1)
  end

  local selfKeyword = managers.player
  local syncedEquips = selfKeyword:get_synced_equipment_possession(1)

  local amount = 0
  if syncedEquips and syncedEquips[name] then
    amount = updateAmount(syncedEquips[name])
  end

  local equip = tweak_data.equipments.specials[name]

  if amount == 0 and not add then
    managers.hud:remove_special_equipment(name)
    self:remove_equipment_possession(1, name)
    managers.network:session():send_to_peers_synched("sync_remove_equipment_possession", 1, name)

    self._equipment.specials[name] = nil
    return
  end

  if amount == 0 and add then
    amount = 1

    managers.hud:add_special_equipment(
    {
      id = name,
      icon = equip.icon,
      amount = amount
    })
  elseif amount > 0 then
    managers.hud:set_special_equipment_amount(name, amount)
  end

  selfKeyword:update_equipment_possession_to_peers(name, amount)

  selfKeyword._equipment.specials[name] =
  {
    amount = amount
  }
end

HGIHelpers.PM = PMHelper