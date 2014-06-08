
hook.Add("Think", "BackGunManager", function () 
	for _, Player in pairs(player.GetAll()) do
		if ( Player == LocalPlayer() ) then continue end
		for _, Gun in pairs(Player:GetWeapons()) do
			if ( Gun.BackHolster ) then
				if ( Player:GetActiveWeapon() != Gun and Gun:GetSharedBool("holstered", false) ) then
					if ( !IsValid(Gun.BackGun) ) then
						Gun.BackGun = ClientsideModel(Gun:GetModel(), RENDERGROUP_OPAQUE)
						if(!Gun.BackGun) then return end
						Gun.BackGun:SetMoveType( MOVETYPE_NONE )
						Gun.BackGun:SetSolid( SOLID_NONE )
					end
					
					local Attachment = Player:GetAttachment(Player:LookupAttachment("chest"));
					local Pos = Attachment.Pos;
					local Ang = Attachment.Ang;
	
					if (!Player:Crouching()) then
						if (Player:GetVelocity():Length() > 20) then
							Gun.BackGun:SetPos(Pos + Ang:Right() * 8 + Ang:Forward() * -5 + Ang:Up() * -15);
						else
							Gun.BackGun:SetPos(Pos + Ang:Right() * 8 + Ang:Forward() * -7 + Ang:Up() * -15);
						end
		
						Gun.BackGun:SetAngles(Ang + Angle(-60, 90, 0));
					else
						local Forward = -4;
						local Right = 8;
						if (Player:GetVelocity():Length() > 20) then
							Forward = -5;
							Right = 4;
						end
		
						Gun.BackGun:SetPos(Pos + Ang:Right() * Right + Ang:Forward() * Forward + Ang:Up() * -15);
						Gun.BackGun:SetAngles(Ang + Angle(-90, 40, 60 - Ang.r));
					end
					
					Gun.BackGun:SetParent(Player);
				else
					if ( IsValid(Gun.BackGun) ) then
						Gun.BackGun:Remove();
						Gun.BackGun = nil;
					end
				end
			end
		end
	end
end);