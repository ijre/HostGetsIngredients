local originalSync = UnitNetworkHandler.sync_interacted

function UnitNetworkHandler:sync_interacted(unit, u_id, equipment, status, sender)
  if not HGI:IsIngredient(equipment, true) then
    originalSync(self, unit, u_id, equipment, status, sender)
    return
  end

  sender:sync_interaction_reply(false)

  local c_unit = managers.criminals:character_data_by_peer_id(1)
  unit:interaction():sync_interacted(managers.network:session():local_peer(), c_unit, status)
end