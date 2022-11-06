local function doScale( ply, scale )
    if not IsValid(ply) then return end
    ply:SetModelScale(scale, 1)
    ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 72 * scale))
end

net.Receive( "DRP#darkrp_playerscale", function()
    local ply = net.ReadEntity()
    local scale = net.ReadFloat()

    doScale( ply, scale )
end )