


function GM:PlayerCanHearPlayersVoice ( PlayerListening, PlayerSpeaking )
	if (!IsValid(PlayerListening) || !IsValid(PlayerSpeaking)) then return false; end
	if (PlayerListening == PlayerSpeaking) then return false; end
	
	if (PlayerListening:GetPos():Distance(PlayerSpeaking:GetPos()) <= ChatRadius_Local) then return true; end
	
	if (PlayerListening.Calling && PlayerSpeaking.Calling && PlayerListening.Calling == PlayerSpeaking && PlayerListening.PickedUp) then return true; else end
	//Admin Spectating
	if (PlayerListening:IsAdmin() && PlayerListening:GetTable().Spectating != nil) then
		//Lets not change all the variables and such, just set it equal to the object.
		local specplayer = PlayerListening:GetTable().Spectating
		if (specplayer:GetPos():Distance(PlayerSpeaking:GetPos()) <= ChatRadius_Local) then return true; end 
		
		local wereGov = specplayer:Team() != TEAM_CITIZEN;
		local theyreGov = PlayerSpeaking:Team() != TEAM_CITIZEN;
	
		if (wereGov && theyreGov && PlayerSpeaking:GetSharedBool("tradio", false)) then return true; end
	
		if (theyreGov && PlayerSpeaking:GetSharedBool("tradio", false)) then
			local nearCop;
			for k, v in pairs(player.GetAll()) do
				if (v:GetPos():Distance(specplayer:GetPos()) < ChatRadius_Whisper && v:Team() != TEAM_CITIZEN) then
					nearCop = true;
					break;
				end
			end
			
			if (!nearCop) then
				for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
					if (v:GetPos():Distance(specplayer:GetPos()) < ChatRadius_Whisper && v.vehicleTable && v.vehicleTable.RequiredClass) then
						nearCop = true;
						break;
					end
				end
			end
			
			if (nearCop) then return true; end
		end
	end
	
	local wereGov = PlayerListening:Team() != TEAM_CITIZEN;
	local theyreGov = PlayerSpeaking:Team() != TEAM_CITIZEN;
	
	if (wereGov && theyreGov && PlayerSpeaking:GetSharedBool("tradio", false)) then return true; end
	
	if (theyreGov && PlayerSpeaking:GetSharedBool("tradio", false)) then
		local nearCop;
		for k, v in pairs(player.GetAll()) do
			if (v:GetPos():Distance(PlayerListening:GetPos()) < ChatRadius_Whisper && v:Team() != TEAM_CITIZEN) then
				nearCop = true;
				break;
			end
		end
		
		if (!nearCop) then
			for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
				if (v:GetPos():Distance(PlayerListening:GetPos()) < ChatRadius_Whisper && v.vehicleTable && v.vehicleTable.RequiredClass) then
					nearCop = true;
					break;
				end
			end
		end
		
		if (nearCop) then return true; end
	end
	
	return false;
end

function GM.ChangeRadioTalking ( Player, Cmd, Args )
	if (!Args[1]) then return; end
	
	if (tonumber(Args[1]) == 1) then
		Player:SetSharedBool("tradio", true);
	else
		Player:SetSharedBool("tradio", nil);
	end
end
concommand.Add("perp_tr", GM.ChangeRadioTalking);

