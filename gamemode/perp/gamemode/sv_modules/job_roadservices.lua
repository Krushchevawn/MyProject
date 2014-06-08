GM.JobPaydayInfo[TEAM_ROADSERVICE] = {"for keeping the infrastructure going.", 80}

GM.JobEquips[TEAM_ROADSERVICE] = function ( Player )
	Player:Give("car_wrench")
end

function GM.RoadServices_Join ( Player )
	if (Player:HasBlacklist(GAMEMODE.teamToBlacklist[TEAM_ROADSERVICE])) then return end
	if (!Player:NearNPC(24)) then return end
	if (Player:Team() != TEAM_CITIZEN) then return end
	if (Player.RunningForMayor) then return end
	if (team.NumPlayers(TEAM_ROADSERVICE) >= GAMEMODE.MaximumRoadService) then return end
	if ((Player:GetTimePlayed() < GAMEMODE.RequiredTime_RoadService * 60 * 60 or !Player:IsGoldMember()) and !Player:IsSuperAdmin() ) then return end
	
	Player:SetTeam(TEAM_ROADSERVICE)
	
	Player:RemoveCar()
	
	GAMEMODE.JobEquips[TEAM_ROADSERVICE](Player)
	
	Player:StripMains()
	hook.Call("PlayerLoadout", Player)
end
concommand.Add("perp_rs_j", GM.RoadServices_Join)

function GM.RoadServices_Leave ( Player )
	
	//Strip weapons
	Player:StripWeapon("car_wrench")
	
	Player:SetTeam(TEAM_CITIZEN)
	
	Player:RemoveCar()
	
	Player.JobModel = nil
	Player:SetModel(Player.PlayerModel)
	Player:EquipMains()
end
concommand.Add("perp_rs_q", GM.RoadServices_Leave)

function GM.RoadServices_SpawnCar ( Player )
	if (Player:Team() != TEAM_ROADSERVICE) then return end
	if (!Player:NearNPC(24)) then return end
	
	local numSquadCars = 0
	
	for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do		
		if (v.vehicleTable && v.vehicleTable.RequiredClass == TEAM_ROADSERVICE && v:GetSharedEntity("owner", nil) != Player) then
			numSquadCars = numSquadCars + 1
		end
	end
	
	if (!Player:IsGoldMember() && numSquadCars >= GAMEMODE.MaxRoadServiceTrucks) then return end
	
	GAMEMODE.SpawnVehicle(Player, "%", {1, 1, 0})
end
concommand.Add("perp_rs_c", GM.RoadServices_SpawnCar)
