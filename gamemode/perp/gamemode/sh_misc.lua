
local function MonitorDrowning ( )
	for k, v in pairs(player.GetAll()) do
		if (SERVER || v == LocalPlayer()) then
			if (v:WaterLevel() >= 3) then
				v.UnderwaterStart = v.UnderwaterStart or CurTime();
				local availableUnderwaterTime = GAMEMODE.DrownTime * (1 + ((v:GetPERPLevel(SKILL_SWIMMING) - 1) * .2));
				
				if (v:Alive() && v.UnderwaterStart + availableUnderwaterTime <= CurTime()) then
					v.LastWaterDamage = v.LastWaterDamage or 0;
					
					if (v.LastWaterDamage + GAMEMODE.DrowningDelay <= CurTime()) then
						v.LastWaterDamage = CurTime();
						
						if SERVER then
							local ProspectiveHealth = v:Health() - GAMEMODE.DrowningDamage;
							
							if (ProspectiveHealth <= 0) then
								v:Kill();
							else
								v:SetHealth(ProspectiveHealth);
							end
						else
							surface.PlaySound(Sound("player/pl_drown" .. math.random(1, 3) .. ".wav"));
							vgui.Create("perp2_drown");
						end
					end
				end
				
				v.LastSwimmingAllowance = v.LastSwimmingAllowance or 0;
				local realSpeed = v:GetVelocity():Length();
				
				if (realSpeed >= 50 && v.LastSwimmingAllowance + 1 <= CurTime()) then
					v:GiveExperience(SKILL_SWIMMING, GAMEMODE.ExperienceForSwimming, true);
					v.LastSwimmingAllowance = CurTime();
				end
			else
				if (v:InVehicle() && v:GetVehicle():GetClass() == "prop_vehicle_jeep") then
					v.LastDrivingAllowance = v.LastDrivingAllowance or 0;
					local realSpeed = v:GetVehicle():GetVelocity():Length();
					
					if (realSpeed >= 10 && v.LastDrivingAllowance <= CurTime()) then
						v:GiveExperience(SKILL_DRIVING, GAMEMODE.ExperienceForDriving, true);
						v.LastDrivingAllowance = CurTime() + 5;
					end
				end
				
				v.UnderwaterStart = nil;
			end
		end
	end
end
hook.Add("Think", "MonitorDrowning", MonitorDrowning);

function IsValid( object )
	if (!object) then return false; end
	if (!object.IsValid) then return false; end
	
	return object:IsValid();
end;

function ScaleToWideScreen(size)
	return math.min(math.max( ScreenScale(size / 2.62467192), math.min(size, 14) ), size);
end;