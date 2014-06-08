if SERVER then

	hook.Add( "EntityTakeDamage", "HitMarker", function(ent, dmginfo)
		local inflictor = dmginfo:GetInflictor()
		local attacker = dmginfo:GetAttacker()
		if( attacker and attacker:IsPlayer() and ent:IsPlayer() and ent != attacker and !inflictor:IsVehicle() ) then
			umsg.Start( "HitMarkerDo", attacker )
			umsg.End()
		end
	end )

else

	local CanHitMaker = CreateClientConVar( "perp_hitmarker", 1, true, false )
	local hitmakertime = 0
	
	usermessage.Hook( "HitMarkerDo", function()
		hitmakertime = CurTime() + 0.2
	end )

	local hitmarkertime = 0
	hook.Add( "HUDPaint", "DrawHitMarker", function()
		if !CanHitMaker:GetBool() then return end
		ply = LocalPlayer()

		if CurTime() < hitmakertime then
			local x = ScrW()/2
			local y = ScrH()/2
			 
			local length = (hitmakertime - CurTime()) * 40
			
			surface.SetDrawColor( 225, 255, 255, 200 )
			surface.DrawLine( x + 3 + length, y - 3 - length, x + 7 + length, y - 7 - length)
			surface.DrawLine( x - 3 - length, y + 3 + length, x - 7 - length, y + 7 + length )
			surface.DrawLine( x + 3 + length, y + 3 + length, x + 7 + length, y + 7 + length )
			surface.DrawLine( x - 3 - length, y - 3 - length, x - 7 - length, y - 7 - length )
		end
	end )
	
end
