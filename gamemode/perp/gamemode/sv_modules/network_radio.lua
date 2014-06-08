
local function changeRadioStation ( Player )
	if (Player.nextRadio && Player.nextRadio > CurTime()) then return; end
	
	local ent;
	if (Player:InVehicle() and Player:GetVehicle():GetClass() == "prop_vehicle_jeep") then
		local vehicleTable = Player:GetVehicle().vehicleTable;
		
		if (vehicleTable && vehicleTable.SirenNoise) then
			GAMEMODE.ToggleSiren(Player);
		return; end
		
		if (vehicleTable and vehicleTable.ID == 'a') then
			Player:Notify("ATVs are not equipped with radios.");
		return; end
			
		ent = Player:GetVehicle();
	else
		local eyeTrace = Player:GetEyeTrace();
		
		if (!eyeTrace.Entity || !IsValid(eyeTrace.Entity) || eyeTrace.Entity:GetPos():Distance(Player:GetShootPos()) > 200) then return; end
		if (eyeTrace.Entity:GetClass() != "ent_prop_item") then return; end
		if (eyeTrace.Entity:GetModel() != "models/props/cs_office/radio.mdl") then return; end
		local owner = eyeTrace.Entity:GetTable().Owner
		if(owner and owner:IsPlayer()) then
			if ( ( owner != Player and owner:GetSharedInt( "org", 0 ) != Player:GetSharedInt( "org", 0 ) ) or ( owner != Player and ( owner:GetSharedInt( "org", 0 ) == 0 or Player:GetSharedInt( "org", 0 ) == 0 ) ) ) then 
				return
				Player:Notify("You are not in the same org as the owner of this radio!")
			end
		end
		
		ent = eyeTrace.Entity;
	end
	
	if (GAMEMODE.RadioStations[ent:GetSharedInt("perp_station", 0) + 1]) then
		ent:SetSharedInt("perp_station", ent:GetSharedInt("perp_station", 0) + 1)
	else
		ent:SetSharedInt("perp_station", 0);
	end
		
	umsg.Start('perp_rmsg', Player);
		umsg.Short(ent:GetSharedInt("perp_station", 0));
	umsg.End();
	
	Player.nextRadio = CurTime() + .5;
end
concommand.Add("perp_r_c", changeRadioStation);