local originalCrimSpawn = TradeManager.criminal_respawn

function TradeManager:criminal_respawn(pos, rot, params)
  if not LuaNetworking:IsHost() or table.empty(HGI.custodyOverride) or managers.criminals:local_character_name() ~= params.id then
    originalCrimSpawn(self, pos, rot, params)
  end

  local overrideChar = managers.criminals:character_data_by_peer_id(HGI.custodyOverride:id())

  for equip, amount in pairs(managers.player._global.synced_equipment_possession[HGI.custodyOverride:id()]) do
    if HGI:IsIngredient(equip) then
      HGIHelpers.PM:AddOrRemoveSpecial(equip, true)

      managers.hud:remove_teammate_special_equipment(overrideChar.panel_id, equip)
      managers.network:session():send_to_peers_synched("sync_remove_equipment_possession", HGI.custodyOverride:id(), equip)
      managers.player:remove_equipment_possession(HGI.custodyOverride:id(), equip)
    end
  end

  HGI.custodyOverride = { }

  originalCrimSpawn(self, pos, rot, params)
end