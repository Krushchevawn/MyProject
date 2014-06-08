
local function GetPlayNum(Player)
	for k,v in ipairs(player.GetAll()) do
		if(v == Player) then
			return k
		end
	end
end

function GM.PlayerBindPressPERP2 ( Player, Bind, Press )
	if (string.find(string.lower(Bind), "voicerecord") && !Player:Alive()) then return true; end
	if (string.find(string.lower(Bind), "zoom")) then return true; end

	if (PERP_SpectatingEntity && Press) then
		if (string.find(string.lower(Bind), "+jump")) then
			PERP_SpectatingEntity = nil;
			RunConsoleCommand("perp_a_ss");
			
			return true;
		elseif (string.Left(string.lower(Bind), 8) =="+attack2") then
			local Start = 0
			if(PERP_SpectatingEntity) then
				Start = GetPlayNum(PERP_SpectatingEntity)
			end
							
			Start = Start + 1
			
			local PlayerCount = table.Count(player.GetAll())
			
			if(Start > PlayerCount) then
				Start = 1
			end
			
			PERP_SpectatingEntity = player.GetAll()[Start];
			RunConsoleCommand('perp_a_s', PERP_SpectatingEntity:UniqueID())
			
			return true;
		elseif (string.Left(string.lower(Bind), 7) =="+attack") then
			local Start = 0
			if(PERP_SpectatingEntity) then
				Start = GetPlayNum(PERP_SpectatingEntity)
			end
							
			Start = Start - 1
			
			local PlayerCount = table.Count(player.GetAll())
			
			if(Start < 1) then
				Start = PlayerCount
			end
			
			PERP_SpectatingEntity = player.GetAll()[Start];
			RunConsoleCommand('perp_a_s', PERP_SpectatingEntity:UniqueID())
			
			return true;
		elseif (string.find(string.lower(Bind), "+duck")) then
			RunConsoleCommand("perp_a_cst");
			
			return true
		end
		
		return;
	end
	
	local vT;
	if (LocalPlayer():InVehicle()) then vT = lookForVT(LocalPlayer():GetVehicle()); end

	if (Press && string.find(string.lower(Bind), "impulse 100") && LocalPlayer():InVehicle()) then
		RunConsoleCommand("perp_v_f");
	elseif (Press && string.find(string.lower(Bind), "impulse 201") && LocalPlayer():InVehicle()) then
		RunConsoleCommand("perp_v_ug");
	elseif (Press && string.find(string.lower(Bind), "+reload") && LocalPlayer():InVehicle()) then
		RunConsoleCommand("perp_v_su");
	elseif (LocalPlayer():InVehicle() && (!vT || !vT.SirenNoise_Alt || !LocalPlayer():GetVehicle():GetSharedBool("siren", false)) && Press && string.find(string.lower(Bind), "+walk")) then
		RunConsoleCommand("perp_v_h");
	elseif (Press && string.find(string.lower(Bind), "+speed") && LocalPlayer():InVehicle()) then
		RunConsoleCommand("perp_v_y");
	elseif (Press && string.find(string.lower(Bind), "+menu")) then
		RunConsoleCommand("perp_r_c");
	elseif (string.find(string.lower(Bind), "+duck") && (Player:InVehicle() || PERP_SpectatingEntity) && Press) then
		local iVal = gmod_vehicle_viewmode:GetInt();
		if ( iVal == 0 ) then iVal = 1 else iVal = 0 end
		RunConsoleCommand("gmod_vehicle_viewmode", iVal)
		return true;
	end
end
hook.Add("PlayerBindPress", "PlayerBindPressPERP2", GM.PlayerBindPressPERP2)