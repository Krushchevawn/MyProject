GM.JobPaydayInfo[TEAM_MEDIC] = {"as a paycheck for being a paramedic.", 100}

GM.JobEquips[TEAM_MEDIC] = function ( Player )
	Player:Give("weapon_perp_paramedic_defib")
	Player:Give("weapon_perp_paramedic_health")
end

function GM.Medic_Join ( Player )
	if (Player:HasBlacklist(GAMEMODE.teamToBlacklist[TEAM_MEDIC])) then return end
	if (!Player:NearNPC(13)) then return end
	if (Player:Team() != TEAM_CITIZEN) then return end
	if (Player.RunningForMayor) then return end
	if (Player:GetSharedBool("warrent", false)) then return end
	if (team.NumPlayers(TEAM_MEDIC) >= GAMEMODE.MaximumParamedic) then return end
	
	Player:SetTeam(TEAM_MEDIC)
	
	Player:RemoveCar()
	
	GAMEMODE.JobEquips[TEAM_MEDIC](Player)
	
	Player.JobModel = JOB_MODELS[TEAM_MEDIC][Player:GetSex()][Player:GetFace()] or JOB_MODELS[TEAM_MEDIC][SEX_MALE][1]
	Player:SetModel(Player.JobModel)
	Player:StripMains()
	hook.Call("PlayerLoadout", Player)
end
concommand.Add("perp_m_j", GM.Medic_Join)

function GM.Medic_Quit ( Player )
	if (!Player:NearNPC(13)) then return end
	GAMEMODE.Medic_Leave(Player)
end
concommand.Add("perp_m_q", GM.Medic_Quit)

function GM.Medic_Leave ( Player )
	Player:SetTeam(TEAM_CITIZEN)
	
	Player:StripWeapon("weapon_perp_paramedic_defib")
	Player:StripWeapon("weapon_perp_paramedic_health")
	
	Player:RemoveCar()
	
	Player.JobModel = nil
	Player:SetModel(Player.PlayerModel)
	Player:EquipMains()
end

function GM.Medic_SpawnCar ( Player )
	if (Player:Team() != TEAM_MEDIC) then return end
	if (!Player:NearNPC(13)) then return end
	
	local numFireCars = 0
	
	for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do		
		if (v.vehicleTable && v.vehicleTable.RequiredClass == TEAM_MEDIC && v:GetSharedEntity("owner", nil) != Player) then
			numFireCars = numFireCars + 1
		end
	end
	
	if (numFireCars >= GAMEMODE.MaxAmbulances) then return end
	
	GAMEMODE.SpawnVehicle(Player, "w", {1, 1, 0})
end
concommand.Add("perp_m_c", GM.Medic_SpawnCar)

function GM.Medic_DoDefib ( Player, Cmd, Args )
	if (!Player) then return end
	if (!Args[1]) then return end
	if (Player:Team() != TEAM_MEDIC and !Player:IsModerator()) then return end
	
	local theirUniqueID = Args[1]
	local toHeal	
	
	for k, v in pairs(player.GetAll()) do
		if (v:UniqueID() == theirUniqueID) then
			toHeal = v
		end
	end
	
	if (!toHeal) then return end
	if (toHeal:Alive()) then return end
	if (Player:GetPos():Distance(toHeal.DeathPos) > 500) then return end
		
	toHeal.RequiredDefib = toHeal.RequiredDefib - 1
	
	if (toHeal.RequiredDefib > 0) then return end
	
	GAMEMODE.DeadPlayers[toHeal:UniqueID()] = nil
	toHeal.DontFixCripple = true
	toHeal:Spawn()
	toHeal:Notify("You have been revived by a medic.")
	//haxx
	for i=1, 4 do
		timer.Simple(i / 10, function()
			toHeal:SetPos(toHeal.DeathPos)
			toHeal:GetUnStuck()
		end)
	end
	
	Player:GiveCash(50)
	Player:Notify("You have earned $50 for reviving a player.")
	
	Player:GiveExperience(SKILL_FIRST_AID, 10)
end
concommand.Add("perp_m_h", GM.Medic_DoDefib)

function GM.Medic_FinishPlayer ( Player, Cmd, Args )
	if (!IsValid(Player)) then return end
	if (!Args[1]) then return end
	if (Player:Team() != TEAM_CITIZEN) then return end
	
	local theirUniqueID = Args[1]
	local toHeal	
	
	local t = player.GetAll()
	for k=1, #t do
		local v = t[k]
		if (v:UniqueID() == theirUniqueID) then
			toHeal = v
		end
	end
	
	if (!toHeal) then return end
	if (toHeal:Alive()) then return end
	if (Player:GetPos():Distance(toHeal.DeathPos) > 500) then return end
	if(toHeal.IsFinished) then return end
	
	toHeal.IsFinished = true
	
	Player.DontFixCripple = nil
	
	timer.Simple(0.5, function()
		if(not IsValid(toHeal)) then return end
		GAMEMODE.DeadPlayers[toHeal:UniqueID()] = nil
		toHeal:Spawn()
		toHeal.IsFinished = false
	end)
	toHeal:Notify("You have been finished off by a bullet to the head.")
end
concommand.Add("perp_m_k", GM.Medic_FinishPlayer)