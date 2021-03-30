local Utils = { }

function Utils:GetFirstAlivePeer()
  for _, peer in pairs(managers.network:session():peers()) do
    if peer ~= managers.network:session():local_peer() and not managers.trade:is_peer_in_custody(peer:id()) then
      return peer
    end
  end

  return { }
end

HGIHelpers.Utils = Utils