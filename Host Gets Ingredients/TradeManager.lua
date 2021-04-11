local originalCrimSpawn = TradeManager.criminal_respawn

function TradeManager:criminal_respawn(pos, rot, params)
  if not LuaNetworking:IsHost() or table.empty(HGI.CustodyPeer) or managers.criminals:local_character_name() ~= params.id then
    originalCrimSpawn(self, pos, rot, params)
    return
  end

  for equip, amount in pairs(managers.player._global.synced_equipment_possession[HGI.CustodyPeer:id()]) do
    if HGI:IsIngredient(equip) then
      HGIHelpers.PM:AddOrRemoveSpecial(equip, true)

      managers.player:remove_equipment_possession(HGI.CustodyPeer:id(), equip)
      managers.network:session():send_to_peers_synched("sync_remove_equipment_possession", HGI.CustodyPeer:id(), equip)
    end
  end

  HGI.CustodyPeer = { }

  originalCrimSpawn(self, pos, rot, params)
end