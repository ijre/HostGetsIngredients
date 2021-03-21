-- amount on host doesnt change when going into custody
-- amount on transfer peer doesnt go above 4

-- current idea: loop through non-custody'd peers, update HGI.custodyOverride to first found peer
  -- use the already available tables for the specials

local originalSpecial = PlayerManager.add_special
local originalTransfer = PlayerManager.transfer_from_custody_special_equipment_to

function PlayerManager:add_special(params)
  if not HGI:IsIngredient(params.name, false) then
    originalSpecial(self, params)
    return
  end

  local name = params.name
  local equip = tweak_data.equipments.specials[name]

  if not equip then
    originalSpecial(self, params)
    return
  end

  equip.avoid_transfer = true

  local syncedEquips = self:get_synced_equipment_possession(1)
  local amount = 0

  if syncedEquips and syncedEquips[name] then
    amount = syncedEquips[name]

    managers.hud:set_special_equipment_amount(name, amount + 1)
  else
    managers.hud:add_special_equipment(
      {
        id = name,
        icon = equip.icon,
        amount = amount + 1
      }
    )
  end

  self._equipment.specials[name] = amount

  self:update_equipment_possession_to_peers(name, amount + 1)

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

-- function PlayerManager:transfer_from_custody_special_equipment_to(target)
  -- if not LuaNetworking:IsHost() then
    -- originalTransfer(self, target)
    -- return
  -- end

  -- if managers.trade:is_peer_in_custody(1) then
  -- end

-- end