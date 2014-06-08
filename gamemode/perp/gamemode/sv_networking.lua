local function PlayerSave ( ply )
	if (!IsValid(ply)) then
		timer.Stop(ourID);
		timer.Remove(ourID);
		return;
	end
			
	ply:Save();
end

GM.OrganizationData = {};
GM.OrganizationMembers = {};

function GM.LoadPlayerProfile ( Player )
	if (Player.AlreadyLoaded) then return false; end
	
	Player.SMFID = Player:SteamID()
	Player.Buddies = Player.Buddies or {}
	
	Msg("Loading " .. Player:Nick() .. "...\n");
	
	if (!Player.StartedSendingVars) then
		Player.StartedSendingVars = true
	end

	DataBase:Query("SELECT `id`, `rp_name_first`, `rp_name_last`, `time_played`, `cash`, `model`, `items`, `skills`, `genes`, `formulas`, `organization`, `bank`, `vehicles`, `blacklists`, `ringtone`, `ammo_pistol`, `ammo_rifle`, `ammo_shotgun`, `fuelleft`, `lastcar` FROM `perp_users` WHERE `id`='" .. Player.SMFID .. "'", function ( PlayerInfo )
		if (!Player || !Player:IsValid() || !IsValid(Player)) then return end
				
		if (!PlayerInfo || !PlayerInfo[1]) then
			DataBase:Query("INSERT INTO `perp_users` (`id`, `uid`, `steamid`, `rp_name_first`, `rp_name_last`, `genes`, `cash`, `blacklists`, `model`, `items`, `skills`, `formulas`, `organization`, `bank`, `vehicles`, `ringtones`, `ringtone`, `time_played`, `last_played`) VALUES ('" .. Player.SMFID .. "', '" .. Player:UniqueID() .. "', '" .. Player:Nick() .. "', 'John', 'Doe', '5', '15000', '', '', '', '', '', '0', '0', '0', '', '1', '0', '0')", function (...)
			PrintTable({...})
			DataBase:Query("INSERT INTO `perp_fuel` (`uid`) VALUES ('" .. Player:UniqueID() .. "')");
				if (!Player || !Player:IsValid() || !IsValid(Player)) then return end
				
				Player.CanSetupPlayer = true;
				timer.Simple(1, function()
					GAMEMODE.LoadPlayerProfile(Player); end)
			end);
			return;
		else
			DataBase:Query("UPDATE `perp_users` SET `steamid`='" .. Player:Nick() .. "' WHERE `id`='" .. Player.SMFID .. "'");
		end
		if (PlayerInfo[1][2] == "John" && PlayerInfo[1][3] == "Doe") then Player.CanSetupPlayer = true; end
		
		if (Player.CanSetupPlayer) then
			Msg("Allowing " .. Player:Nick() .. " to setup new player...\n");
			umsg.Start("perp_newchar", Player);
			umsg.End();
		else
			Player:DetectBaconBot();
		end
		
		Player.joinTime = CurTime();
		

		// Public UMsg Vars
		Player:SetSharedString("rp_fname", PlayerInfo[1][2]);
		Player:SetSharedString("rp_lname", PlayerInfo[1][3]);
		Player:SetSharedInt("ringtone", tonumber(PlayerInfo[1][15]));
		
		// Ammo
		Player:GiveAmmo(tonumber(PlayerInfo[1][16]), 'pistol');
		Player:GiveAmmo(tonumber(PlayerInfo[1][17]), 'smg1');
		Player:GiveAmmo(tonumber(PlayerInfo[1][18]), 'buckshot');
		
		// Private UMsg Vars - This part only sets it for the server. It's also sent to the client via the next section.
		Player:SetPrivateInt("time_played", tonumber(PlayerInfo[1][4]), true);
		Player:SetPrivateInt("cash", tonumber(PlayerInfo[1][5]), true);
		Player:SetPrivateInt("bank", tonumber(PlayerInfo[1][12]), true);
		Player:SetPrivateString("blacklists", PlayerInfo[1][14]);
		Player:SetPrivateInt("fuelleft", tonumber(PlayerInfo[1][19]), true);
		Player:SetPrivateString("lastcar", PlayerInfo[1][20] or "a");

		
		if (PlayerInfo[1][14] != "") then
			Player:RecompileBlacklists();
		end
		
		// Model
		local modelInfo = GAMEMODE.ExplodeModelInfo(PlayerInfo[1][6]) or {};
		local theirNewModel = Player:GetModelPath(modelInfo.sex or "m", tonumber(modelInfo.face) or 1, tonumber(modelInfo.clothes) or 1);
		Player:SetModel(theirNewModel);
		Player:SetPrivateString("model", theirNewModel);
		Player.PlayerModel = theirNewModel;
		Player.PlayerSex = modelInfo.sex or "m";
		Player.PlayerClothes = modelInfo.clothes;
		Player.PlayerFace = tonumber(modelInfo.face) or 1;
		Player.PlayerItems = {}
		
		// Sending the above private vars to the client.
		local st = {}
		st["TimePlayed"] = tostring(PlayerInfo[1][4])
		st["Cash"] = tonumber(PlayerInfo[1][5])
		st["BankCash"] = tonumber(PlayerInfo[1][12])
		st["FuelLeft"] = tonumber(PlayerInfo[1][19])
		st["LastCar"] = tostring(PlayerInfo[1][20])
		st["CurrentTime"] = GAMEMODE.CurrentTime
		st["CurrentDay"] = GAMEMODE.CurrentDay
		st["CurrentMonth"] = GAMEMODE.CurrentMonth
		st["CurrentYear"] = GAMEMODE.CurrentYear
		net.Start("perp_startup") -- NEEEEEEEEEEEEEEEEEEEEEEET LIBRARY
			net.WriteTable(st)
		net.Send(Player)
		
		// mixtures
		Player:SetPrivateString("mixtures", PlayerInfo[1][10]);
		
		// Load Items...
		Player:parseSaveString(PlayerInfo[1][7]);
		net.Start("perp_items_init")
			net.WriteString(tostring(PlayerInfo[1][7]))
		net.Send(Player)
		
		
		// Load Vehicles...
		timer.Simple(1, function ( )
			if (Player && IsValid(Player)) then
				net.Start("perp_vehicles_init")
					net.WriteString(PlayerInfo[1][13])
				net.Send(Player)
			end
		end);
		
		Player.Vehicles = {};
		Player:parseVehicleString(PlayerInfo[1][13]);
		
		// Skills
		local ExplodeSkills = string.Explode(";", PlayerInfo[1][8]);
		for i = 1, #SKILLS_DATABASE do	
			if ExplodeSkills[i] && (i != #ExplodeSkills) then
				Player:SetPrivateInt("s_" .. i, tonumber(ExplodeSkills[i]));
				local postLevel = Player:GetPERPLevel(SKILLS_DATABASE[i][1]);
				Player:AchievedLevel(SKILLS_DATABASE[i][1], tonumber(postLevel));
			end
		end
		
		// Genes
		local ExplodeGenes = string.Explode(";", PlayerInfo[1][9]);
		
		if (#ExplodeGenes > 1) then
			for i = 1, #GENES_DATABASE do			
				if ExplodeGenes[i + 1] && (i != #ExplodeGenes) then
					Player:SetPrivateInt("g_" .. i, tonumber(ExplodeGenes[i + 1]));
					local postLevel = Player:GetPERPLevel(GENES_DATABASE[i][1]);
					Player:AchievedLevel(GENES_DATABASE[i][1], tonumber(postLevel));
				end
			end
		end
		
		if (ExplodeGenes[1]) then
			Player:SetPrivateInt("gpoints", tonumber(ExplodeGenes[1]));
		end
		
		// Check his name...
		if (!Player.CanSetupPlayer && !GAMEMODE.IsValidName(Player:GetFirstName(), Player:GetLastName())) then
			Player:ForceRename();
		end
		
		// Organization
		local org = tonumber(PlayerInfo[1][11]);
		if (org != 0) then
			Player:SetSharedInt("org", org);
			
			if (!GAMEMODE.OrganizationMembers[org]) then
				GAMEMODE.FetchOrganizationData(org);
			end
		end
		
		// Set Varaibles
		Player.AlreadyLoaded = true;
		
		Player:Spawn()
		
		local ourID = Player:SteamID();
		timer.Create(ourID, 180, 0, function() PlayerSave(Player) end);
		
		// Make them bitches load their weapons
		Player:EquipMains();
	
	end);
	
	local ply = Player
	timer.Simple(5, function()
		if( ply and ply:IsValid() ) then
			Msg("Sending the current time to: " .. ply:Nick() .. "\n")
			GAMEMODE.SendTime( ply )
		end
	end )
end
concommand.Add('perp_lp', GM.LoadPlayerProfile);

function GM.NewCharacterCreation ( Player, Cmd, Args )
	if (!Player.CanSetupPlayer) then return false; end
	
	Player.CanSetupPlayer = nil;
	
	local Model = Args[1];
	local FirstName = string.upper(string.sub(Args[2], 1, 1)) .. string.lower(string.sub(Args[2], 2));
	local LastName = string.upper(string.sub(Args[3], 1, 1)) .. string.lower(string.sub(Args[3], 2));
	
	if (!Model || !FirstName || !LastName) then
		Player:ForceRename();
		return;
	end
	
	// Model Stuff
	local modelInfo = GAMEMODE.ExplodeModelInfo(Model) or {};
	local theirNewModel = Player:GetModelPath(modelInfo.sex or "m", tonumber(modelInfo.face) or 1, tonumber(modelInfo.clothes) or 1);
	
	Player:SetModel(theirNewModel);
	Player.PlayerModel = theirNewModel;
	DataBase:Query("UPDATE `perp_users` SET `model`='" .. modelInfo.sex .. "_" .. modelInfo.face .. "_" .. modelInfo.clothes .. "' WHERE `id`='" .. Player.SMFID .. "'");
	
	if (!GAMEMODE.IsValidName(FirstName, LastName)) then 
		Player:ForceRename();
		return; 
	end
	
	DataBase:Query("SELECT `id` FROM `perp_users` WHERE `rp_name_first`='" .. FirstName .. "' AND `rp_name_last`='" .. LastName .. "' LIMIT 1", function ( someoneElseHas )
		if (!Player or !IsValid(Player) or !Player:IsValid()) then return; end
				
		if (someoneElseHas && someoneElseHas[1] && someoneElseHas[1][1]) then
			Player:Notify("That name is already taken.\n");
			Player:ForceRename();
			return; 
		end
	
		Player:SetSharedString("rp_fname", FirstName);
		Player:SetSharedString("rp_lname", LastName);
		
		Player:DetectBaconBot();
		
		DataBase:Query("UPDATE `perp_users` SET `rp_name_first`='" .. FirstName .. "',`rp_name_last`='" .. LastName .. "' WHERE `id`='" .. Player.SMFID .. "'");
	end);
end
concommand.Add('perp_nc', GM.NewCharacterCreation);

function GM.ChangeName ( Player, Cmd, Args )
	local FirstName = string.upper(string.sub(Args[1], 1, 1)) .. string.lower(string.sub(Args[1], 2));
	local LastName = string.upper(string.sub(Args[2], 1, 1)) .. string.lower(string.sub(Args[2], 2));
	
	if (!FirstName || !LastName) then return; end
	
	if (!GAMEMODE.IsValidName(FirstName, LastName)) then 
		Player:ForceRename();
		return; 
	end
	
	DataBase:Query("SELECT `id` FROM `perp_users` WHERE `rp_name_first`='" .. FirstName .. "' AND`rp_name_last`='" .. LastName .. "' LIMIT 1", function ( someoneElseHas )
		if (!Player or !IsValid(Player) or !Player:IsValid()) then return; end
		
		if (someoneElseHas && someoneElseHas[1] && someoneElseHas[1][1]) then
			Player:Notify("That name is already taken.\n");
			Player:ForceRename();
			return; 
		end
	
		if (!Player.CanRenameFree) then
			if (Player:GetCash() < GAMEMODE.RenamePrice) then
				return;
			end
			
			Player:TakeCash(GAMEMODE.RenamePrice, true);
		end
		
		Player.CanRenameFree = nil;
		
		Player:SetSharedString("rp_fname", FirstName);
		Player:SetSharedString("rp_lname", LastName);
		
		DataBase:Query("UPDATE `perp_users` SET `rp_name_first`='" .. FirstName .. "',`rp_name_last`='" .. LastName .. "' WHERE `id`='" .. Player.SMFID .. "'");
	end);
end
concommand.Add("perp_encrypt3D_cn", GM.ChangeName);

function GM.ChangeFace ( Player, Cmd, Args )
	if (!Player) then return; end
	if (!Args[1]) then return; end
	if (Player:Team() != TEAM_CITIZEN) then return; end
	
	local Model = Args[1];
	
	// Model Stuff
	local modelInfo = GAMEMODE.ExplodeModelInfo(Model);
	if (!modelInfo) then return; end
	
	local newSex = SEX_MALE;
	if (modelInfo.sex == 'f') then newSex = SEX_FEMALE; end
	if (tonumber(modelInfo.sex) == 2) then newSex = SEX_FEMALE; end
	if (Player:GetSex() != newSex) then return; end
	if (Player:GetClothes() != modelInfo.clothes) then return; end
	
	Player:TakeCash(GAMEMODE.FacialPrice, false);
	
	local theirNewModel = Player:GetModelPath(modelInfo.sex or "m", tonumber(modelInfo.face) or 1, tonumber(modelInfo.clothes) or 1);
	
	Player:SetModel(theirNewModel);
	Player.PlayerModel = theirNewModel;
	DataBase:Query("UPDATE `perp_users` SET `model`='" .. modelInfo.sex .. "_" .. modelInfo.face .. "_" .. modelInfo.clothes .. "' WHERE `id`='" .. Player.SMFID .. "'");
	
	Player:SetPrivateString("model", theirNewModel);
	Player.PlayerSex = modelInfo.sex or "m";
	Player.PlayerClothes = modelInfo.clothes;
	Player.PlayerFace = tonumber(modelInfo.face) or 1;
end
concommand.Add("perp_cf", GM.ChangeFace);

function GM.ChangeClothes ( Player, Cmd, Args )
	if (!Player) then return; end
	if (!Args[1]) then return; end
	if (Player:Team() != TEAM_CITIZEN) then return; end
	
	local Model = Args[1];
	
	// Model Stuff
	local modelInfo = GAMEMODE.ExplodeModelInfo(Model);
	if (!modelInfo) then Msg("fail info\n"); return; end
	
	local newSex = SEX_MALE;
	if (modelInfo.sex == 'f') then newSex = SEX_FEMALE; end
	if (tonumber(modelInfo.sex) == 2) then newSex = SEX_FEMALE; end
	if (Player:GetSex() != newSex) then return; end
	if (Player:GetFace() != modelInfo.face) then return; end
	
	Player:TakeCash(GAMEMODE.ClothesPrice, true);
	
	local theirNewModel = Player:GetModelPath(modelInfo.sex or "m", tonumber(modelInfo.face) or 1, tonumber(modelInfo.clothes) or 1);
	
	Player:SetModel(theirNewModel);
	Player.PlayerModel = theirNewModel;
	DataBase:Query("UPDATE `perp_users` SET `model`='" .. modelInfo.sex .. "_" .. modelInfo.face .. "_" .. modelInfo.clothes .. "' WHERE `id`='" .. Player.SMFID .. "'");
	
	Player:SetPrivateString("model", theirNewModel);
	Player.PlayerSex = modelInfo.sex or "m";
	Player.PlayerClothes = modelInfo.clothes;
	Player.PlayerFace = tonumber(modelInfo.face) or 1;
end
concommand.Add("perp_cc", GM.ChangeClothes);

function GM.ChangeSex ( Player, Cmd, Args )
	if (!Player) then return; end
	if (Player:Team() != TEAM_CITIZEN) then return; end
	
	
	// Model Stuff
	local newSex = "m";
	if (Player:GetSex() == SEX_MALE) then newSex = "f"; end
	
	local modelInt = SEX_MALE;
	if (newSex == "f") then modelInt = SEX_FEMALE; end

	Player:TakeCash(GAMEMODE.SexChangePrice, true);
	
	local theirNewModel = Player:GetModelPath(newSex, 1, 1);
	
	Player:SetModel(theirNewModel);
	Player.PlayerModel = theirNewModel;
	DataBase:Query("UPDATE `perp_users` SET `model`='" .. modelInt .. "_1_1' WHERE `id`='" .. Player.SMFID .. "'");
	
	Player:SetPrivateString("model", theirNewModel);
	Player.PlayerSex = modelInt;
	Player.PlayerClothes = 1;
	Player.PlayerFace = 1;
end
concommand.Add("perp_cs", GM.ChangeSex);

/*function GM.Typing ( Player, Cmd, Args )
	if (Args[1] && tostring(Args[1]) == "1") then
		Player:SetSharedInt("typing", 1);
		Player.StartedTyping = CurTime();
	else
		Player.StartedTyping = nil;
		Player:SetSharedInt("typing", nil);
	end
end
concommand.Add("pt", GM.Typing);*/

function GM.AddBuddy ( Player, Cmd, Args )
	if (!Args[1] || !Player.Buddies) then return; end
	if (tostring(tonumber(Args[1])) != tostring(Args[1])) then return; end
	
	table.insert(Player.Buddies, Args[1]);
end
concommand.Add("perp_ab", GM.AddBuddy);

function GM.RemoveBuddy ( Player, Cmd, Args )
	if (!Args[1] || !Player.Buddies) then return; end
	if (tostring(tonumber(Args[1])) != tostring(Args[1])) then return; end
	
	for k, v in pairs(Player.Buddies) do
		if (v == Args[1]) then
			Player.Buddies[k] = nil;
		end
	end
end
concommand.Add("perp_rb", GM.RemoveBuddy);

function GM.BankDeposit ( Player, Cmd, Args )
	if (!Args[1]) then return; end
	if(!Player:NearNPC(2) and !Player:NearNPC(20)) then return end
	
	local toTake = tonumber(Args[1]);
	
	if (toTake <= 0) then return; end
	if (Player:GetCash() < toTake) then return; end
	
	Player:TakeCash(toTake, true);
	Player:GiveBank(toTake, true);
end
concommand.Add("perp_b_d", GM.BankDeposit);

function GM.BankWithdraw ( Player, Cmd, Args )
	if (!Args[1]) then return; end
	if(!Player:NearNPC(2) and !Player:NearNPC(20)) then return end
	
	local toTake = tonumber(Args[1]);
	
	if (toTake <= 0) then return; end
	if (Player:GetBank() < toTake) then return; end
	if ((Player:GetCash() + toTake) > MAX_CASH) then return; end
	
	Player:GiveCash(toTake, true);
	Player:TakeBank(toTake, true);
end
concommand.Add("perp_b_w", GM.BankWithdraw);

// Event Start Script
function GM.StartEvent ( Player, Cmd, Args )
	if Player:GetLevel() > 0 then return false; end
	local Event = Args[1];
	
	if !file.Exists("perp/gamemode/events/".. Event .. ".lua", "LUA") then

		Player:PrintMessage(HUD_PRINTCONSOLE, "That event does not exist.");
		return false;
	end
	
	include('perp3/gamemode/events/' .. Event .. '.lua');
end
concommand.Add("perp2_encrypt3D_events", GM.StartEvent);

function GM.ResetFirstName( Player, Cmd, Args )
	Player:SetSharedString("rp_fname", Player:GetSharedString("rp_fname", "John"))
end
concommand.Add("perp_r_fn", GM.ResetFirstName)
/*
function GM.ResetLastCar( Player, Cmd, Args )
	umsg.Start("perp_rs_lc")
*/