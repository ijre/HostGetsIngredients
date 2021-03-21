-- excerpts of original functions for easy calling

local Excerpts = { }

function Excerpts:transfer_special_equipment(name, amount, p)
  local selfKeyword = managers.player

  local equipment_data = tweak_data.equipments.specials[name]

  if equipment_data and not equipment_data.avoid_tranfer then
    local equipment_lost = true
    local amount_to_transfer = amount
    local max_amount = equipment_data.transfer_quantity or 1

    local id = p:id()
    local peer_amount = selfKeyword._global.synced_equipment_possession[id] and selfKeyword._global.synced_equipment_possession[id][name] or 0

    if max_amount > peer_amount then
      local transfer_amount = math.min(amount_to_transfer, max_amount - peer_amount)
      amount_to_transfer = amount_to_transfer - transfer_amount

      p:send("give_equipment", name, transfer_amount, true)

      for i = 1, transfer_amount do
        selfKeyword:remove_special(name)
      end

      if amount_to_transfer == 0 then
        equipment_lost = false
      end
    end

    if equipment_lost and name == "evidence" then
      managers.mission:call_global_event("equipment_evidence_lost")
    end
  end
end

HGIHelpers.Excerpts = Excerpts