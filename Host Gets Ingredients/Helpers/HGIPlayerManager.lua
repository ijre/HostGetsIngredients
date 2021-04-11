local PMHelper = { }

function PMHelper:AddOrRemoveSpecial(name, add)
  if add == nil then
    return end

  local updateAmount = function(currentAmount)
    return add and currentAmount + 1 or math.max(0, currentAmount - 1)
  end

  local syncedEquips = managers.player:get_synced_equipment_possession(1)

  local amount = -1
  if syncedEquips and syncedEquips[name] then
    amount = updateAmount(syncedEquips[name])
  end

  local equip = tweak_data.equipments.specials[name]

  if amount == 0 and not add then
    managers.hud:remove_special_equipment(name)
    managers.player:remove_equipment_possession(1, name)
    managers.network:session():send_to_peers_synched("sync_remove_equipment_possession", 1, name)

    managers.player._equipment.specials[name] = nil
    return
  elseif amount == -1 and add then
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

  managers.player:update_equipment_possession_to_peers(name, amount)

  managers.player._equipment.specials[name] =
  {
    amount = amount
  }
end

HGIHelpers.PM = PMHelper