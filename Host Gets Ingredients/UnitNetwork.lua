local originalSync = UnitNetworkHandler.sync_interacted

function UnitNetworkHandler:sync_interacted(unit, uid, equipment, status, sender)
  local isIngred = HGI:IsIngredient(equipment)
  local isLabEquip = HGI:IsLabEquipment(equipment)

  if not isIngred and not isLabEquip then
    originalSync(self, unit, uid, equipment, status, sender)
    return
  end

  local senderPeer = self._verify_sender(sender)

  local peerToUse = managers.network:session():local_peer()

  if isIngred then
    sender:sync_interaction_reply(false)
  elseif isLabEquip then
    if table.empty(HGI.CustodyPeer) or HGI.CustodyPeer:id() ~= senderPeer:id() then
      sender:sync_interaction_reply(false)
      return
    end

    local equipmentName = tweak_data.interaction[isLabEquip].special_equipment

    peerToUse = HGI.CustodyPeer
    peerToUse:send("give_equipment", equipmentName, 1, false)
    managers.player:remove_special(equipmentName)
  end

  local c_unit = managers.criminals:character_data_by_peer_id(peerToUse:id())
  unit:interaction():sync_interacted(peerToUse, c_unit, status)
end