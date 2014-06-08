hook.Add("HUDPaint", "SpectatePerpsle", function()
	if LocalPlayer():GetObserverMode() == OBS_MODE_NONE then return end
	
	local ply = LocalPlayer():GetObserverTarget()
	if !ply or !ply:IsPlayer() then return end

	local text = "Spectating: " .. ply:Nick() .. "  ( " .. ply:GetRPName() .. " )"
	draw.SimpleText( text, "Trebuchet22", ScrW()/2, 80, Color(255, 20, 10), 1, 1)
end)

concommand.Add("pp_mat_overlay", function() end)