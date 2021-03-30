local originalAddSpec = PlayerManager.add_special
local originalRemoveSpec = PlayerManager.remove_special
local originalTransfer = PlayerManager.transfer_special_equipment

function PlayerManager:add_special(params)
  if not HGI:IsIngredient(params.name) then
    originalAddSpec(self, params)
    return
  end

  local name = params.name
  local equip = tweak_data.equipments.specials[name]

  HGIHelpers.PM:AddOrRemoveSpecial(self, name, true)

  local text = managers.localization:text(equip.text_id)
  local title = managers.localization:text("present_obtained_mission_equipment_title")

  managers.hud:present_mid_text({
    time = 4,
    text = text,
    title = title,
    icon = equip.icon
  })

  managers.network:session():send_to_peers_synched("sync_show_action_message", self:player_unit(), equip.action_message)
end

function PlayerManager:remove_special(name)
  if not HGI:IsIngredient(name) or table.empty(HGI.CustodyPeer) then
    originalRemoveSpec(self, name)
    return
  end

  HGIHelpers.PM:AddOrRemoveSpecial(self, name, false)
end

function PlayerManager:transfer_special_equipment(peerID, custody)
  local earlyReturn = function(condition)
    if condition or condition == nil then
      originalTransfer(self, peerID, custody)
      return true
    end

    return false
  end

  if earlyReturn(not LuaNetworking:IsHost() or peerID ~= 1) then
    return
  end

  if earlyReturn(not self._global.synced_equipment_possession[1]) then
    return
  end

  for _, peer in pairs(managers.network:session():peers()) do
    if not managers.trade:is_peer_in_custody(peer:id()) then
      HGI.CustodyPeer = peer
      break
    end
  end

  if earlyReturn(table.empty(HGI.CustodyPeer)) then
    return
  end

  for name, amount in pairs(self._global.synced_equipment_possession[1]) do
    local newPeerInv = self:get_synced_equipment_possession(HGI.CustodyPeer:id()) or { }

    if HGI:IsIngredient(name) then
      if not table.contains(newPeerInv, name) then
        HGI.CustodyPeer:send("give_equipment", name, 1, false)
        self:remove_special(name)
      end
    else
      HGIHelpers.Excerpts:transfer_special_equipment(self, name, amount, HGI.CustodyPeer)
    end
  end
end

