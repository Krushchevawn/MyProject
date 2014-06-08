local seatSituationMode = false

local vehicleSpawnPos = {
//							{Gov Only?, Vector, Angle}

							// Civies
							//Car Dealer
							{false, Vector(5403.5034, -3639.9440, 75.3111), Angle(0, -90, 0)}, 
							{false, Vector(5708.2812, -3653.6308, 75.3111), Angle(0, -90, 0)}, 
							{false, Vector(4775.8208, -3688.4851, 75.3111), Angle(0, -90, 0)}, 
							{false, Vector(5717.7812, -4092.5739, 75.3111), Angle(0, -90, 0)}, 
							{false, Vector(5408.9453, -4101.8496, 75.3111), Angle(0, -90, 0)}, 
							
							//Garage
							{false, Vector(-5252.4648, -10529.8564, 82.3343), Angle(0, -90, 0)}, 
							{false, Vector(-5052.4648, -10529.8564, 82.3343), Angle(0, -90, 0)}, 
							{false, Vector(-4852.4648, -10529.8564, 82.3343), Angle(0, -90, 0)}, 
							{false, Vector(-4652.4648, -10529.8564, 82.3343), Angle(0, -90, 0)}, 
							{false, Vector(-4452.4648, -10529.8564, 82.3343), Angle(0, -90, 0)}, 
							{false, Vector(-4252.4648, -10529.8564, 82.3343), Angle(0, -90, 0)}, 
							{false, Vector(-4052.4648, -10529.8564, 82.3343), Angle(0, -90, 0)}, 
							
							
							// Fire
							{TEAM_FIREMAN, Vector(-3622.5212, -8225.4053, 200.2129), Angle(0, 180, 0)}, 
							{TEAM_FIREMAN, Vector(-3622.5212, -7951.0146, 200.2129), Angle(0, 180, 0)}, 
							{TEAM_FIREMAN, Vector(-3622.5212, -7665.6211, 200.2129), Angle(0, 180, 0)},       
							
							// Cop
							{TEAM_POLICE, Vector(-7623.5034, -8955.1650, -186.0401), Angle(0, 0, 0)}, 
							{TEAM_POLICE, Vector(-7628.9409, -9205.7363, -186.0403), Angle(0, 0, 0)}, 
							{TEAM_POLICE, Vector(-7628.9409, -9492.1416, -186.0403), Angle(0, 0, 0)}, 
							{TEAM_POLICE, Vector(-6924.4512, -8948.3740, -186.0405), Angle(0, -180, 0)}, 
							{TEAM_POLICE, Vector(-6924.5161, -9205.1504, -186.0405), Angle(0, -180, 0)}, 
							{TEAM_POLICE, Vector(-6924.5161, -9492.1416, -186.0405), Angle(0, -180, 0)}, 
							
							// SWAT
							{TEAM_SWAT, Vector(-7605.5474, -10009.7510, -186.4136), Angle(0, 90, 0)}, 
							{TEAM_SWAT, Vector(-7605.5474, -9771.7568, -186.4136), Angle(0, 90, 0)}, 
							
							// SWAT
							{TEAM_SECRET_SERVICE, Vector(-7267.3608, -9146.0469, -185.8752), Angle(0, 180, 0)}, 
							
							// Medic
                            {TEAM_MEDIC, Vector(-8594.3066, 8884.4111, 60.9474), Angle(0.0294, -128.5888, 0.1042)}, 
                            {TEAM_MEDIC, Vector(-8614.8486, 9061.373, 60.9169), Angle(0.0358, -128.3128, 0.0895)}, 
                            {TEAM_MEDIC, Vector(-8599.7012, 9221.835, 60.9476), Angle(0.0258, -126.1745, 0.1039)},
							
							//Bus Driver
                            {TEAM_BUSDRIVER, Vector(-10478.273438, -11829.375977, 82.3343), Angle(0, 0, 0)},
							
							//Road Crew Worker
                            {TEAM_ROADSERVICE, Vector(430, 4016.965088, 83), Angle(0, 180, 0)},
                            {TEAM_ROADSERVICE, Vector(430, 3795.726563, 83), Angle(0, 180, 0)},

						}

function PLAYER:parseVehicleString ( input )
	local itemInfo = string.Explode(";", string.Trim(input));
	
	for k, v in pairs(itemInfo) do
		local splitAgain = string.Explode(",", v);
		
			self.Vehicles[splitAgain[1]] = {tonumber(splitAgain[2] or 1), tonumber(splitAgain[3] or 1), tonumber(splitAgain[4] or 0), tonumber(splitAgain[5] or 0)};
		if (#splitAgain > 0) then
		end
	end
end

function PLAYER:CompileVehicles ( )
	local saveString = "";
	
	for k, v in pairs(self.Vehicles) do
		if (k && tostring(k) != "" && string.len(tostring(k)) == 1) then 
			saveString = saveString .. tostring(k) .. "," .. v[1] .. "," .. v[2] .. "," .. v[3] .. "," .. v[4] .. ";";
		end
	end
	
	return saveString;
end

local function buyVehicle ( Player, Cmd, Args )
	if (!Args[1]) then return; end
	
	local vehicleID = Args[1];
	local vehicleTable = VEHICLE_DATABASE[vehicleID];
	
	if (!vehicleTable) then return; end
	if (vehicleTable.RequiredClass) then return; end
	
	local cost = vehicleTable.Cost + math.Round(vehicleTable.Cost * GAMEMODE.GetTaxRate_Sales())
	
	if (Player:GetBank() < cost) then return; end
	
	GAMEMODE.GiveCityMoney(math.Round(vehicleTable.Cost * GAMEMODE.GetTaxRate_Sales()))
	Player:TakeBank(cost, true);
	Player.Vehicles[vehicleID] = {1, 1, 0, 0};
	
	DataBase:Query("UPDATE `perp_users` SET `vehicles`='" .. Player:CompileVehicles() .. "' WHERE `id`='" .. Player.SMFID .. "'");
	Player:SetPrivateInt("lastcar", vehicleTable.ID)
	Player:Save();
	
	if (!vehicleTable.RequiredClass && Player:Team() != TEAM_CITIZEN) then return; end
	
	GAMEMODE.SpawnVehicle(Player, vehicleID, Player.Vehicles[vehicleID]);
end
concommand.Add("perp_v_p", buyVehicle);

local function sellDaVehicle ( Player, Cmd, Args )
	if (!Args[1]) then return end
	
	local vehicleID = Args[1]
	local vehicleTable = VEHICLE_DATABASE[vehicleID]
	if (!vehicleTable) then return end
	if (vehicleTable.RequiredClass) then return end
	if(not Player.Vehicles[vehicleID]) then return end
	
	Player.Vehicles[vehicleID] = nil
	
	DataBase:Query("UPDATE `perp_users` SET `vehicles`='" .. Player:CompileVehicles() .. "' WHERE `id`='" .. Player:SteamID() .. "'")
	Player:Save()
	
	Player:AddBank(vehicleTable.Cost * 0.5)
	
	Player:Notify("You successfully sold your " .. vehicleTable.Name .. ".")
end
concommand.Add("perp_v_sellit", sellDaVehicle)

local function demoVehicle ( Player, Cmd, Args)
	if (!Args[1]) then return end
	
	if(IsValid(Player.DemoVehicle)) then return end
	
	local vehicleID = Args[1]
	local vehicleTable = VEHICLE_DATABASE[vehicleID]
	
	if (vehicleTable.Cost == 0) then return end
	if (!vehicleTable.RequiredClass && (Player:Team() != TEAM_CITIZEN)) then
		Player:Notify("You can't do this with your current class.")
		return
	end
	
	GAMEMODE.DemoVehicle(Player, vehicleID)
end
concommand.Add("perp_v_demo", demoVehicle)

local function claimVehicle ( Player, Cmd, Args )
	if (!Args[1]) then return; end
	
	local vehicleID = Args[1];
	local vehicleTable = VEHICLE_DATABASE[vehicleID];
	if (!vehicleTable.Cost) then return; end
	if (vehicleTable.Cost == 0) then return; end
	if (!Player:HasVehicle(vehicleID)) then return; end
	if (!vehicleTable.RequiredClass && Player:Team() != TEAM_CITIZEN) then return; end
	if(Player:Team() == TEAM_CITIZEN and Player.currentVehicle and Player.currentVehicle.Disabled) then
		Player:Notify("Your car is disabled! Please get it fixed or wait 5 minutes.")
		return
	end
	
	GAMEMODE.SpawnVehicle(Player, vehicleID, Player.Vehicles[vehicleID]);
end
concommand.Add("perp_v_c", claimVehicle);

local function skinVehicle ( Player, Cmd, Args )
	if (!Args[1]) then return; end
	
	local skinID = tonumber(Args[1]);
	
	local theirVehicle = Player.currentVehicle;
	
	if (!theirVehicle || !IsValid(theirVehicle)) then return; end
	if (Player:GetCash() < theirVehicle.vehicleTable.PaintJobCost) then return; end
	
	if (!theirVehicle.vehicleTable.PaintJobs[skinID]) then 
		Msg("Missing paint job ID " .. theirVehicle.vehicleTable.Name .. " #" .. skinID .. "\n");
	return; end
	
	Player:TakeCash(theirVehicle.vehicleTable.PaintJobCost, true);
	
	if (theirVehicle.vehicleTable.PaintJobs[skinID].model != theirVehicle:GetModel()) then
		theirVehicle:SetModel(theirVehicle.vehicleTable.PaintJobs[skinID].model);
	end
	
	if(theirVehicle.vehicleTable.DynamicPaint) then
		theirVehicle:SetColor(theirVehicle.vehicleTable.PaintJobs[skinID].color)
	else
		theirVehicle:SetSkin(theirVehicle.vehicleTable.PaintJobs[skinID].skin)
	end
	
	Player.Vehicles[theirVehicle.vehicleTable.ID][1] = skinID;
	
	DataBase:Query("UPDATE `perp_users` SET `vehicles`='" .. Player:CompileVehicles() .. "' WHERE `id`='" .. Player.SMFID .. "'");
end
concommand.Add("perp_v_s", skinVehicle);

local function setLightsVehicle ( Player, Cmd, Args )
	if (!Player:IsVIP()) then return; end
	if (!Args[1]) then return; end
	
	local lightID = tonumber(Args[1]);
	
	local theirVehicle = Player.currentVehicle;
	
	if (!theirVehicle || !IsValid(theirVehicle)) then return; end
	if (Player:GetCash() < theirVehicle.vehicleTable.PaintJobCost * 2) then return; end
	if (!HEADLIGHT_COLORS[lightID]) then return; end
	if (HEADLIGHT_COLORS[lightID][3] == "Gold" && !Player:IsGoldMember()) then return; end
	
	Player:TakeCash(theirVehicle.vehicleTable.PaintJobCost * 2, true);
	
	if (theirVehicle.headLightColor != lightID) then
		theirVehicle.headLightColor = lightID;
		theirVehicle:SetSharedVector("lightcolor", Vector(HEADLIGHT_COLORS[theirVehicle.headLightColor][1].r, HEADLIGHT_COLORS[theirVehicle.headLightColor][1].g, HEADLIGHT_COLORS[theirVehicle.headLightColor][1].b, 255));
		
		if (theirVehicle.Headlights) then
			for k, flashlight in pairs(theirVehicle.Headlights) do
				if (flashlight && IsValid(flashlight)) then
					local realColor = HEADLIGHT_COLORS[lightID][1];
					flashlight:SetKeyValue("lightcolor", realColor.r .. " " .. realColor.g .. " " .. realColor.b .. " " .. realColor.a);
				end
			end
		end
	end
		
	Player.Vehicles[theirVehicle.vehicleTable.ID][2] = lightID;
	
	DataBase:Query("UPDATE `perp_users` SET `vehicles`='" .. Player:CompileVehicles() .. "' WHERE `id`='" .. Player.SMFID .. "'");
end
concommand.Add("perp_v_l", setLightsVehicle);

local function setHydVehicle ( Player, Cmd, Args )
	if (!Player:IsVIP()) then return; end
	
	local theirVehicle = Player.currentVehicle;
	
	if (!theirVehicle || !IsValid(theirVehicle)) then return; end
	
	if (Player.Vehicles[theirVehicle.vehicleTable.ID][3] == 1) then
		Player.Vehicles[theirVehicle.vehicleTable.ID][3] = 0;
	else
		if (Player:GetCash() < COST_FOR_HYDRAULICS) then return; end
		
		Player:TakeCash(COST_FOR_HYDRAULICS, true);
		Player.Vehicles[theirVehicle.vehicleTable.ID][3] = 1;
	end
	
	DataBase:Query("UPDATE `perp_users` SET `vehicles`='" .. Player:CompileVehicles() .. "' WHERE `id`='" .. Player.SMFID .. "'");
end
concommand.Add("perp_v_j", setHydVehicle);

// Changes underglow color.
/*
local function setUnderglowChange ( Player, Cmd, Args )
	if (!Player:IsVIP()) then return; end
	if (!Args[1]) then return; end
	
	local lightID = tonumber(Args[1]);
	
	local theirVehicle = Player.currentVehicle;
	
	if (!theirVehicle || !IsValid(theirVehicle)) then return; end
	if (Player:GetCash() < theirVehicle.vehicleTable.PaintJobCost * 2) then return; end
	if (!HEADLIGHT_COLORS[lightID]) then return; end
	
	Player:TakeCash(theirVehicle.vehicleTable.PaintJobCost * 2, true);
		
	if (theirVehicle.Underglow) then
		for k, underglowLight in pairs(theirVehicle.Underglow) do
			if (underglowLight && IsValid(underglowLight)) then
				local realColor = HEADLIGHT_COLORS[lightID][1];
				underglowLight:SetKeyValue("_light", realColor.r .. " " .. realColor.g .. " " .. realColor.b .. " " .. realColor.a);
			end
		end
	end

		
	Player.Vehicles[theirVehicle.vehicleTable.ID][4] = lightID;
	
	DataBase:Query("UPDATE `perp_users` SET `vehicles`='" .. Player:CompileVehicles() .. "' WHERE `id`='" .. Player.SMFID .. "'");
end
concommand.Add("perp_v_ugc", setUnderglowChange);*/

// Adds & Removes underglow.
local function setUnderglowVehicle ( Player, Cmd, Args )
	if (!Player:IsVIP()) then return; end
	
	local theirVehicle = Player.currentVehicle;
	
	if (!theirVehicle || !IsValid(theirVehicle)) then return; end
	
	if (Player.Vehicles[theirVehicle.vehicleTable.ID][4] >= 1) then
		Player.Vehicles[theirVehicle.vehicleTable.ID][4] = 0;
	else
		if (Player:GetCash() < COST_FOR_UNDERGLOW) then return; end
		
		Player:TakeCash(COST_FOR_UNDERGLOW, true);
		Player.Vehicles[theirVehicle.vehicleTable.ID][4] = 1;
	end
	
	DataBase:Query("UPDATE `perp_users` SET `vehicles`='" .. Player:CompileVehicles() .. "' WHERE `id`='" .. Player.SMFID .. "'");
end
concommand.Add("perp_v_uga", setUnderglowVehicle);


function PLAYER:RemoveCar ( )
	if self.VehicleRotator and self.VehicleRotator:IsValid() then
		self.VehicleRotator:Remove();
		self.VehicleRotator = nil;
	end
	
	
	if IsValid(self.currentVehicle) then
		self.currentVehicle:Remove()
		self.currentVehicle = nil
	end
end

function PLAYER:CanRideInCar ( vehicle )
	if (!vehicle:IsVehicle()) then return false; end
	if(seatSituationMode) then return true end
	if (!vehicle:GetNetworkedEntity("owner") || !IsValid(vehicle:GetNetworkedEntity("owner"))) then return false; end
	
	local owner = vehicle:GetNetworkedEntity("owner");

	// Mayor can ride with the secret service (duh)
	if (owner:Team() == TEAM_SECRET_SERVICE && self:Team() == TEAM_MAYOR) then return true end
	if (owner:Team() == TEAM_POLICE && self:Team() == TEAM_CITIZEN && self.currentlyRestrained) then return true end
	
	if (owner:Team() == TEAM_BUSDRIVER) then return true end
	
	if (self:Team() == TEAM_MAYOR) then return false end
	
	if (self:CanManipulateDoor(vehicle)) then return true; end
		
	// check organization members.
	/*if (owner:GetNetworkedInt("org", 0) != 0 && GAMEMODE.OrganizationMembers[self:GetNetworkedInt("org", 0)]) then
		for k, v in pairs(GAMEMODE.OrganizationMembers[self:GetNetworkedInt("org", 0)]) do
			if (v[2] == self:UniqueID()) then
				return true;
			end
		end
	end*/
	
	// if theyre the same team, let 'em do it.
	if (self:Team() == owner:Team() && owner:Team() != TEAM_CITIZEN) then return true; end
	
	return false;
end

local function selectVehicleSpawn ( Player, vehicleID )
	local possibleLocations = {};
	
	for k, v in pairs(vehicleSpawnPos) do
		if (!v[1] || VEHICLE_DATABASE[vehicleID].RequiredClass == v[1]) then
			local canPlaceHere = true;
			
			for _, ent in pairs(ents.FindInSphere(v[2], 100)) do
				if (ent:GetClass() == "prop_vehicle_jeep") then
					canPlaceHere = false;
					break;
				end
			end
			
			if (canPlaceHere) then
				table.insert(possibleLocations, v);
			end
		end
	end	
	
	if (possibleLocations == 0) then return false; end
	
	local closestLocation;
	local closestDist = 100000;
	
	for k, v in pairs(possibleLocations) do
		local dist = v[2]:Distance(Player:GetPos());
		
		if (dist < closestDist) then
			closestLocation = v;
			closestDist = dist;
		end
	end
	
	if (!closestLocation) then return false; end
	
	return closestLocation;
end

function CreatePassengerSeat ( Entity, Vect, Angles )
	local SeatDatabase = list.Get("Vehicles")["Seat_Jeep"];
	local OurPos = Entity:GetPos();
	local OurAng = Entity:GetAngles();
	local SeatPos = OurPos + (OurAng:Forward() * Vect.x) + (OurAng:Right() * Vect.y) + (OurAng:Up() * Vect.z);
	
	local Seat = ents.Create("prop_vehicle_prisoner_pod");
	Seat:SetModel(SeatDatabase.Model);
	Seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt");
	Seat:SetAngles(OurAng + Angles);
	Seat:SetPos(SeatPos);
	Seat:Spawn();
	Seat:Activate();
	Seat:SetParent(Entity);
	Seat:SetRenderMode(RENDERMODE_TRANSALPHA)
	
	Seat:SetSolid(SOLID_NONE);
	Seat:SetMoveType(MOVETYPE_NONE);
	
	if SeatDatabase.Members then table.Merge(Seat, SeatDatabase.Members); end
	if SeatDatabase.KeyValues then
		for k, v in pairs(SeatDatabase.KeyValues) do
			Seat:SetKeyValue(k, v);
		end
	end
	
	Seat:GetTable().ParentCar = Entity;
	Seat.VehicleName = "Jeep Seat";
	Seat.VehicleTable = SeatDatabase;
	Seat.ClassOverride = "prop_vehicle_prisoner_pod";
	
	table.insert(Entity.PassengerSeats, Seat);
	
	Seat.IsPassengerSeat = true;

	if (!seatSituationMode) then
		Seat:SetColor(Color(255, 255, 255, 0))
	end
end

function GM.DemoVehicle(Player, vehicleID)
	local veh = GAMEMODE.SpawnVehicle(Player, vehicleID, {1, 1, 0, 100, 0})
	
	Player:EnterVehicle(veh)
	Player.DemoVehicle = veh
	Player:SetNetworkedEntity("DemoVehicle", veh)
	
	Player:ChatPrint("-- You're able to drive this demonstration vehicle for 2 minutes --")
	Player:ChatPrint("-- The vehicle will automaticly be removed after this time period --")
	
	timer.Create("demo1" .. Player:SteamID(), 120, 1, function()
		if(Player.DemoVehicle) then
			Player:ExitVehicle()
		end
	end)
	timer.Create("demo2" .. Player:SteamID(), 60, 1, function()
		if(Player.DemoVehicle) then
			Player:ChatPrint("-- The vehicle demonstration ends in 60 seconds --")
		end
	end)
	timer.Create("demo3" .. Player:SteamID(), 90, 1, function()
		if(Player.DemoVehicle) then
			Player:ChatPrint("-- The vehicle demonstration ends in 30 seconds --")
		end
	end)
	timer.Create("demo4" .. Player:SteamID(), 105, 1, function()
		if(Player.DemoVehicle) then
			Player:ChatPrint("-- The vehicle demonstration ends in 15 seconds --")
		end
	end)
end

function GM.SpawnVehicle ( Player, vehicleID, paintJob )
	Player.lastVehicleSpawn = Player.lastVehicleSpawn or 0;
	if (Player.lastVehicleSpawn > CurTime()) then return; end
	Player.lastVehicleSpawn = CurTime() + 1;

	local placeToSpawn = selectVehicleSpawn(Player, vehicleID);
	
	if (!placeToSpawn) then
		Player:Notify("There was an error spawning your vehicle. Please try again later.");
		return;
	end
	
	Player:RemoveCar();
	for k, v in pairs(player.GetAll()) do
		umsg.Start("removebadid", Player)
			umsg.Short(Player:GetCarUsed());		// Fuel Left
		umsg.End()
	end
			
	local vehicleTable = VEHICLE_DATABASE[vehicleID];
	local paintJobS = vehicleTable.PaintJobs[paintJob[1]];

	if(!paintJobS) then paintJobS = vehicleTable.PaintJobs[1] end --Failsafe for bad paintjobs
		
	local newVehicle = ents.Create("prop_vehicle_jeep");
		newVehicle:SetModel(paintJobS.model);
		//newVehicle:SetSkin(paintJobS.skin);
		if(vehicleTable.DynamicPaint) then
			newVehicle:SetColor(paintJobS.color)
		else
			newVehicle:SetSkin(paintJobS.skin)
		end
		newVehicle:SetPos(placeToSpawn[2]);
		newVehicle:SetAngles(placeToSpawn[3] - Angle(0, 90, 0));
		newVehicle:SetKeyValue("vehiclescript", "scripts/vehicles/perp2_" .. vehicleTable.Script .. ".txt");
	newVehicle:Spawn();
		
	if (vehicleTable.CustomBodyGroup) then
		newVehicle:Fire("setbodygroup", tostring(vehicleTable.CustomBodyGroup), 0);
	end
	
	newVehicle.CarDamage = 70;
	newVehicle.owner = Player;
	
	newVehicle:Fire("lock", "", 0);
	
	newVehicle:SetNetworkedEntity("owner", Player);
	local ID1 = math.random(1, 32);
	local ID2 = math.random(0, 76);
	local ID3 = math.random(0, 7);

	IDString = (""..ID1..""..ID2..""..ID3.."");
	
	newVehicle.CarDamage = 70;
	newVehicle.owner = Player;	
	newVehicle:Fire("lock", "", 0);
	CarID = tostring(vehicleTable.FID)
	
	newVehicle:SetNetworkedEntity("owner", Player);
	newVehicle:SetNetworkedInt("carid", IDString);
	Player:SetCarUsed(tonumber(newVehicle:GetNetworkedInt("carid")));
		
	ID = newVehicle:GetNetworkedInt("carid")
	
	--shows up shit that ppl dont need (from client: 1083)
	--umsg.Start("sendcarid", Player)
	--	umsg.Long(tonumber(ID));
	--umsg.End();
	
	Player.currentVehicle = newVehicle;
	
	newVehicle.vehicleTable = vehicleTable;
	DF = vehicleTable.DF;
	//if !DF then Player:Notify("false") end
		
	if DF then Player:SetPrivateInt("lastcar", vehicleTable.ID) end;
	
		// Add pulley if its service truck
	if(vehicleID == "%") then
		//-1.1618 4.7689 106.6799
		newVehicle.Thingy = ents.Create("ent_servicetruck")
		newVehicle.Thingy:SetPos(newVehicle:GetPos() + newVehicle:GetUp() * 35 + newVehicle:GetForward() * -125 + newVehicle:GetRight() * -35)
		newVehicle.Thingy:SetAngles(newVehicle:GetAngles() + Angle(0, 270, 0))
		newVehicle.Thingy:SetVehicle(newVehicle)
		newVehicle.Thingy.ThePlayer = Player
		newVehicle.Thingy:Spawn()
	end
	
	// Make passenger seats
	newVehicle.PassengerSeats = {};
	if (vehicleTable.PassengerSeats) then
		for k, v in pairs(vehicleTable.PassengerSeats) do
			CreatePassengerSeat(newVehicle, v[1], v[2]);
		end
	end
	
	newVehicle.headLightColor = paintJob[2];
	newVehicle:SetSharedVector("lightcolor", Vector(HEADLIGHT_COLORS[newVehicle.headLightColor][1].r, HEADLIGHT_COLORS[newVehicle.headLightColor][1].g, HEADLIGHT_COLORS[newVehicle.headLightColor][1].b, 255));
	
	return newVehicle;
end

function GM:PlayerEnteredVehicle ( Player, Vehicle, Role )
	Player:SetPrivateInt("carid", Vehicle:GetNetworkedInt("carid"));
	local ourVehicle = Vehicle.vehicleTable;
	VehicleIgnitionOn = nil;
	
	if (!ourVehicle) then return; end

	if Vehicle:GetClass() == 'prop_vehicle_jeep' then Player:GetTable().OnEnteredHealth = Player:Health(); end
	
	if(!Vehicle.VehicleIgnitionOn) then
		Vehicle:Fire('turnoff', '', 0);
		Vehicle:SetNetworkedBool("Started", false)
	end
	
	if Vehicle:GetTable().Disabled then
		Player:Notify('This vehicle has been disabled in an accident.');
		Vehicle:Fire('turnoff', '', 0);
		Vehicle.VehicleIgnitionOn = nil
		Vehicle:SetNetworkedBool("Started", false)
	end
	
	if Vehicle.LastRadioStation then
		Vehicle:SetNetworkedInt('perp_station', Vehicle.LastRadioStation);
		Vehicle.LastRadioStation = nil;
	end

	if !ourVehicle.PlayerReposition_Pos then return; end
		
	local Rotator = ents.Create('ent_rotator');
		Rotator:SetModel('models/props_junk/cinderblock01a.mdl');
		Rotator:SetPos(Player:GetPos());
		Rotator:SetAngles(Player:GetAngles());
	Rotator:Spawn();
	
	Player:SetParent(Rotator);
	Rotator:SetParent(Vehicle);
	Rotator:SetLocalAngles(ourVehicle.PlayerReposition_Ang);
	Rotator:SetLocalPos(ourVehicle.PlayerReposition_Pos);
	
	Rotator:SetSolid(SOLID_NONE);
	Rotator:SetMoveType(MOVETYPE_NONE);
	
	Player.VehicleRotator = Rotator;
end

function PlayerVehicleStartUp ( Player )
	if (Player.nextStartUp && Player.nextStartUp > CurTime()) then return; end
	if (Player:GetVehicle().IsPassengerSeat) then return; end
	
	local currentVehicle = Player:GetVehicle()
	local vehicleCheck = Player:GetVehicle().vehicleTable;
	
	if currentVehicle:GetTable().Disabled then
		Player:Notify('This vehicle has been disabled in an accident.');
		return;
	end

	if (vehicleCheck && vehicleCheck.Script == "veyron") then
		if (!currentVehicle.VehicleIgnitionOn) then
			currentVehicle.VehicleIgnitionOn = true;
			currentVehicle:EmitSound("perp3.0/vehicle/engine/veyron_ignitionstart.wav", 100, 100);
			currentVehicle:Fire('turnon', '', 3);
			timer.Simple(3, function()
				currentVehicle:SetNetworkedBool("Started", true)
			end)
			Player.nextStartUp = CurTime() + 4;
		else
			currentVehicle.VehicleIgnitionOn = nil;
			currentVehicle:EmitSound("Vehicles/golf/v8_stop1.wav", 100, 100);
			currentVehicle:Fire('turnoff', '', 0);
			currentVehicle:SetNetworkedBool("Started", false)
			Player.nextStartUp = CurTime() + 2;
		end;
	elseif (vehicleCheck && vehicleCheck.Script != "veyron") then
		if (!currentVehicle.VehicleIgnitionOn) then
			currentVehicle.VehicleIgnitionOn = true;
			currentVehicle:EmitSound("Vehicles/Lambo/Start.wav", 100, 100);
			currentVehicle:Fire('turnon', '', 6);
			timer.Simple(6, function()
				currentVehicle:SetNetworkedBool("Started", true)
			end )
			Player.nextStartUp = CurTime() + 7;
		else
			currentVehicle.VehicleIgnitionOn = nil;
			currentVehicle:EmitSound("Vehicles/golf/v8_stop1.wav", 100, 100);
			currentVehicle:Fire('turnoff', '', 0);
			currentVehicle:SetNetworkedBool("Started", false)
			Player.nextStartUp = CurTime() + 2;
		end;
	end;
	
end;
concommand.Add("perp_v_su", PlayerVehicleStartUp);

function GM:CanPlayerEnterVehicle ( Player, Vehicle )
	if (Vehicle:GetClass() == "prop_vehicle_jeep" && seatSituationMode) then return false end

	if (Vehicle:GetClass() != "prop_vehicle_jeep") then
		if (!Vehicle.pickupPlayer) then return true; end
		
		if (Vehicle:GetAngles().r > 2 || Vehicle:GetAngles().r < -2 || Vehicle:GetAngles().p > 2 || Vehicle:GetAngles().p < -2) then
			return false;
		end
		
		return true;
	end

	if(Player:HasItem("item_parkingticket") and not Vehicle.vehicleTable.RequiredClass) then
		Player:Notify("You have to pay your traffic ticket(s) before you can drive in a vehicle again.")
		return false
	end
	
	if Player:GetVelocity():Length() > 100 then return false; end

	Player.LastLeaveVehicle = Player.LastLeaveVehicle or 0;
	if Player.LastLeaveVehicle > CurTime() then return false; end
	
	if !Player:CanRideInCar(Vehicle) then return false; end // not buddies.
	
	if (Vehicle.vehicleTable.RequiredClass && Player:Team() != Vehicle.vehicleTable.RequiredClass) then
		Player:Notify("You are not of the required class to use this vehicle.");
		return false;
	end
	
	if (Vehicle.RiggedToExplode) then
		Player:Kill();
		
		//Vehicle:SetColor(Color(50, 50, 50, 255))
		local col = Vehicle:GetColor()
		Vehicle:SetColor(Color(col.r/1.4, col.g/1.4, col.b/1.4))
		Vehicle:GetTable().Disabled = true;
		Vehicle:GetTable().DisabledTime = CurTime();
		Vehicle:SetNetworkedBool("leftbl", true)
		Vehicle:SetNetworkedBool("rightbl", true)
		
		ExplodeInit(Vehicle:GetPos(), Vehicle.Rigger or Player);
		
		Vehicle.RiggedToExplode = nil;
	end
	
	return true;
end

function GM:CanExitVehicle ( Vehicle, Player )
	Player.Spot = nil
	if (Vehicle.IsPassengerSeat) then 
		Vehicle = Vehicle.ParentCar
	else
		if(Vehicle:GetClass() == "prop_vehicle_prisoner_pod") then return true end
	end
	local Speed = math.Round(Vehicle:GetVelocity():Length() / 17.6);
   
	if (Speed > 15) then
			return false;
	end
   
	// is der an exit? :o
	if (!Vehicle.vehicleTable || !Vehicle.vehicleTable.ExitPoints || #Vehicle.vehicleTable.ExitPoints == 0) then return false end
	
	local Spots = {}		
	for k, v in pairs(Vehicle.vehicleTable.ExitPoints) do
		local AnyRoom = true
		local firstpos = Vector(0,0,0)
        if v.x <= 0 then
            firstpos = v - Vector( 16, 0, 0 )
        else
            firstpos = v + Vector( 16, 0, 0 )
        end
        local CheckVec = Vehicle:LocalToWorld(firstpos) + Vector(0, 0, 32);
		local SpawnVec = Vehicle:LocalToWorld(v) + Vector(0, 0, 32);
        local badcarents = {
			"prop_physics",
			"ent_item",
			"ent_prop_item",
			"func_door",
			"prop_dynamic",
		}
		if util.IsInWorld( CheckVec ) then
			for k,v in pairs( ents.FindInSphere( CheckVec, 32 ) ) do
				if v:IsValid() and ( v:IsPlayer() or (v:IsVehicle() and v != Vehicle) or v:IsWorld() or v:IsNPC() or table.HasValue(badcarents, v:GetClass())) then
					AnyRoom = false
					break
				end
			end
						
			if(AnyRoom) then
				local td = {}
				td.start = Player:GetPos()
				td.endpos = CheckVec
				td.mask = MASK_SOLID 
				td.filter = { Vehicle, Vehicle:GetDriver() }
				local trace = util.TraceLine( td )
				
				if(trace.HitPos != CheckVec) then
					AnyRoom = false
				end
			end
			
			if AnyRoom then
				table.insert( Spots, SpawnVec )
			end
		end
	end
	
	if #Spots == 0 then
		Player:Notify( "All car doors are blocked!" )
		return false
	end
	
	local newpos = Spots[1]
	for k, v in pairs(Spots) do
		if(Player:GetPos():Distance(v) < Player:GetPos():Distance(newpos)) then
			newpos = v
		end
	end
	Player.Spot = newpos
	if(Player.Spot) then return true else return false end
end
 
function GM:PlayerLeaveVehicle ( Player, Vehicle )     
	Player.LastLeaveVehicle = CurTime() + .25;     
   
	if Player.VehicleRotator and Player.VehicleRotator:IsValid() then
			Player.VehicleRotator:Remove();
			Player.VehicleRotator = nil;
	end
   
	if (!Vehicle.IsPassengerSeat) then
			if Vehicle:GetNetworkedInt('perp_station', 0) != 0 then
					Vehicle.LastRadioStation = Vehicle:GetNetworkedInt('perp_station', 0)
					Vehicle:SetNetworkedInt('perp_station', 0)
			end
		   
			if Vehicle:GetNetworkedBool('siren_sound', false) then
					Vehicle:SetNetworkedBool('siren_sound', false);
			end
		   
			Vehicle:Fire('lock', '', .5);
	else
			Vehicle = Vehicle.ParentCar;
	end
   
	if (Vehicle:GetNetworkedBool("siren", false)) then Vehicle:SetNetworkedBool("siren", false); end
	if (Vehicle:GetNetworkedBool("siren_loud", false)) then Vehicle:SetNetworkedBool("siren_loud", false); end
   
	Player:GetTable().OnEnteredHealth = nil;
   
   
	if (!Vehicle.vehicleTable || !Vehicle.vehicleTable.ExitPoints || #Vehicle.vehicleTable.ExitPoints == 0) then return; end
   
	if(Player.DemoVehicle and Player.DemoVehicle == Vehicle) then
		Vehicle:Remove()
		Player:ChatPrint("-- Stopped vehicle demonstration. --")
		Player.DemoVehicle = nil
		Player:SetNetworkedEntity("DemoVehicle", nil)
		timer.Remove("demo1" .. Player:SteamID())
		timer.Remove("demo2" .. Player:SteamID())
		timer.Remove("demo3" .. Player:SteamID())
		timer.Remove("demo4" .. Player:SteamID())
	end
	
	if Player.Spot then
		Player:SetPos(Player.Spot)
	else
		timer.Simple(0.4, function()
			if(Player and Player:IsValid()) then
				Player:GetUnStuck()
			end
		end)
	end
	Player.Spot = nil
end

// Passenger Seats
function GM.EnterVehicle_Seat ( Player, Vehicle )	
	if (Vehicle.pickupPlayer) then return; end

	if !Player or !Player:IsValid() or !Player:IsPlayer() then return; end
	if !Vehicle or !Vehicle:IsValid() or !Vehicle:IsVehicle() then return; end

	Player.LastLeaveVehicle = Player.LastLeaveVehicle or 0;
	if Player.LastLeaveVehicle > CurTime() then return false; end
	
	if Vehicle:IsVehicle() then
		local Driver = Vehicle:GetDriver();
		
		if (Driver.DemoVehicle and Driver.DemoVehicle == Vehicle) then
			Player:GetTable().LastNoDemoWarning = Player:GetTable().LastNoDemoWarning or 0;
				
			if Player:GetTable().LastNoDemoWarning + 2 < CurTime() then
				Player:Notify('You cannot ride in demo cars.');
				Player:GetTable().LastNoDemoWarning = CurTime();
			end
			return false
		end
				
		// make sure the driver seat is filled
		if ((Driver and Driver:IsValid() and Driver:IsPlayer()) || seatSituationMode) then 	
			if (Player:CanRideInCar(Vehicle)) then // make sure we're even wanted
				local seats = {}
				for k, v in pairs(Vehicle.PassengerSeats) do	
					if (v and v:IsValid() and v:IsVehicle()) then  // If the seat is fake, fuck off
						if (Player:Team() != TEAM_MAYOR || k > 1) then // IF we're mayor, we can only sit in the back
							local owner = Vehicle:GetNetworkedEntity("owner")
							local perfectCombo = owner:Team() == TEAM_POLICE && Player:Team() == TEAM_CITIZEN
							
							if (!perfectCombo || k > 1) then // If it's a cop car, and we're an arrested citizen, then we have to be in the back
								local SeatDriver = v:GetPassenger(0)

								// are they avaialble?
								if !SeatDriver or !SeatDriver:IsValid() or !SeatDriver:IsPlayer() or !SeatDriver:InVehicle() then		
									// make a run for it
									if( owner:Team() == TEAM_BUSDRIVER ) then
										if(Player:GetCash() >= 10) then
											Player:TakeCash( 10 )
											Player:Notify( "You paid $10 for the bus fare!" )
											owner:GiveCash( 10 )
											owner:Notify( Player:GetRPName() .. " paid $10 for the bus fare!" )
											Player:EnterVehicle(v);
											return
										else
											Player:GetTable().LastNoMoneyNotify = Player:GetTable().LastNoMoneyNotify or 0
											if(Player:GetTable().LastNoMoneyNotify + 2 < CurTime()) then
												Player:Notify( "It costs $10 to ride the bus!" )
												Player:GetTable().LastNoMoneyNotify = CurTime()
											end
											return
										end
									end
									table.insert(seats, v)
								end
							end
						end
					end
				end
				if(#seats > 0) then
					local seat = seats[1]
					for k, v in pairs(seats) do
						if(Player:GetPos():Distance(v:GetPos()) < Player:GetPos():Distance(seat:GetPos())) then
							seat = v
						end
					end
					Player:EnterVehicle(seat)
				end
			else
				Player:GetTable().LastNotBuddiesWarning = Player:GetTable().LastNotBuddiesWarning or 0;
				
				if Player:GetTable().LastNotBuddiesWarning + 2 < CurTime() then
					Player:Notify('You are not buddies with the driver.');
					Player:GetTable().LastNotBuddiesWarning = CurTime();
				end
			end
		end
	end
end
hook.Add("PlayerUse", "GetInCar", GM.EnterVehicle_Seat);

function ENTITY:DisableVehicle ( NoFire )
	if self.Disabled then return false; end

	if !NoFire then
		local Fire = ents.Create('ent_fire');
		Fire:SetPos(self:GetPos());
		Fire:Spawn();
	end
				
	self:GetTable().OnEnteredHealth = nil;
	self.Disabled = true;
	self.DisabledTime = CurTime()
	self:Fire('turnoff', '', .5)
	self.VehicleIgnitionOn = nil
	self:SetNetworkedBool("Started", false)
	
				
	//self:SetColor(Color(150, 150, 150, 255))
	local col = self:GetColor()
	self:SetColor(Color(col.r/1.4, col.g/1.4, col.b/1.4))
	
	self:SetNetworkedBool("leftbl", true)
	self:SetNetworkedBool("rightbl", true)
				
	if (self:GetNetworkedBool("siren", false)) then self:SetNetworkedBool("siren", false); end
	if (self:GetNetworkedBool("siren_loud", false)) then self:SetNetworkedBool("siren_loud", false); end
	if (self:GetNetworkedBool("slight", false)) then self:SetNetworkedBool("slight", false); end
	if (self:GetNetworkedInt("perp_station", 0) != 0) then self:SetNetworkedInt("perp_station", 0); end
	
	local Driver = self:GetDriver();
	
	if Driver and Driver:IsValid() and Driver:IsPlayer() then
		Driver:ExitVehicle();
		
		if (Driver:Health() <= 30) then
			Driver:Kill();
		else
			Driver:SetHealth(Driver:Health() - 30);
		end
	end
	
	if(Driver.DemoVehicle and Driver.DemoVehicle == Vehicle) then
		Vehicle:Remove()
		Driver:SetNetworkedEntity("DemoVehicle", nil)
		Driver.DemoVehicle = nil
		timer.Remove("demo1" .. Driver:SteamID())
		timer.Remove("demo2" .. Driver:SteamID())
		timer.Remove("demo3" .. Driver:SteamID())
		timer.Remove("demo4" .. Driver:SteamID())
	end
end

function GM.MonitorVehicleHealth ( )
	for k, v in pairs(player.GetAll()) do
		if v:InVehicle() and v:GetVehicle():GetClass() == 'prop_vehicle_jeep' and v:GetTable().OnEnteredHealth and v:GetVehicle():GetModel() != "models/swatvans.mdl" then			
			local Vehicle = v:GetVehicle();
		
			if ((GAMEMODE.IsSerious && v:GetTable().OnEnteredHealth - 20 >= v:Health()) || v:GetTable().OnEnteredHealth - 25 >= v:Health()) then
				v:GetVehicle():DisableVehicle()
			elseif v:GetTable().OnEnteredHealth != v:Health() then
				v:GetTable().OnEnteredHealth = v:Health()
			end
		end
	end
end
hook.Add("Think", "GM.MonitorVehicleHealth", GM.MonitorVehicleHealth);

function GM.TakeFuel ( Player, Command, Args )
	if (!Args[1]) then return; end
	if (!Args[2]) then return; end
	if !Player:InVehicle() then return end
	local ID = tostring(Args[1])
	local Speed = tonumber(Args[2]) or 1;
	local DF = tostring(Args[3]);
	-- Player:Notify(""..ID.."");
	if DF then
	local FuelCost = nil;
	local fcs = 1;
	local Owner = Player:GetVehicle():GetNetworkedEntity("owner");
	/*
	if (Owner:GetFuel() > 0) then
		Player:GetVehicle():Fire('turnon', '', 0)
	end
	*/
		for k, v in pairs(GAMEMODE.FuelVars) do
			if ID == tostring(k) then fcs = v[2] end
		end
		FuelCost = 1
		for k, v in pairs(GAMEMODE.SpeedVars) do
			if (Speed > tonumber(v[1])) and (Speed < tonumber(v[2])) then FuelCost = (tonumber(v[3]) * fcs); end
		end
	if FuelCost > Owner:GetFuel() then FuelCost = Owner:GetFuel() end
	if (Owner:GetFuel() <= 0) then
		Player:GetVehicle():Fire('turnoff', '', 0)
		Player:GetVehicle().VehicleIgnitionOn = nil
		Player:GetVehicle():SetNetworkedBool("Started", false)
	end
	if (Owner:GetFuel() < FuelCost) then return; end
	Owner:TakeFuel(FuelCost);
	Player:GetVehicle():SetNetworkedInt("fuel", Owner:GetFuel());
	else return end;
end
concommand.Add('perp_take_fuel', GM.TakeFuel);
	
function AddFuel ( Player, Command, Args )
CID = Player:GetPrivateInt("carid")
	for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
		if (v:GetNetworkedInt("carid") == tonumber(CID)) then
			ourVehicle = v;
			VOwner = ourVehicle:GetNetworkedEntity("owner");
			local Fuel = tonumber(Args[1]);
			local Cash = tonumber(Args[2])
			Player:TakeCash(tonumber(Cash), true);
			VOwner:AddFuel(Fuel, true);
		end	
	end
end
concommand.Add("perp_t_f", AddFuel)

local function VehicleTimer()
	for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
		if(v.TiresBroken and v:GetVelocity():Length() > 10) and IsValid(v:GetDriver()) then
			v:EmitSound("vehicles/Airboat/pontoon_scrape_rough" .. math.random(1, 3) .. ".wav", 50)
			v:GetPhysicsObject():ApplyForceOffset(v:GetRight() * math.random(-1, 1) * v:GetVelocity() * 2, v:GetForward() * 50)
			
			local e = EffectData()
			local vel = v:GetPos() + Vector(0, 0, 10)
			e:SetOrigin(vel)
			e:SetStart(vel)
			e:SetNormal(v:GetForward() * -1)
			e:SetScale(1)
			util.Effect("ManhackSparks", e)
		end
	end
end
timer.Create("VehicleTimer", 0.25, 0, function() VehicleTimer() end)

function ENTITY:BreakTires()
	self.TiresBroken = true
	
	if(not self.VehicleParameters) then return false end
	
	self:SetVehicleParameter("steering", "speedSlow", 5)
	self:SetVehicleParameter("steering", "speedFast", 20)
	self:SetVehicleParameter("engine", "maxSpeed", 30)
end

function ENTITY:FixTires()
	if(not self.TiresBroken) then return end
	
	self.TiresBroken = false
	
	self:SetVehicleParameter("steering", "speedSlow", self.VehicleParameters["steering"]["speedSlow"])
	self:SetVehicleParameter("steering", "speedFast", self.VehicleParameters["steering"]["speedFast"])
	self:SetVehicleParameter("engine", "maxSpeed", self.VehicleParameters["engine"]["maxSpeed"])
end

function ENTITY:FixCar()
	if !self:IsVehicle() or self:GetClass() != "prop_vehicle_jeep" then return end
	if (!self:GetTable().Disabled) then	return false end
	
	self.Disabled = false;
	self.DisabledTime = nil
	//self:SetColor(Color(255, 255, 255, 255))
	local col = self:GetColor()
	self:SetColor(Color(col.r*1.4, col.g*1.4, col.b*1.4))
	self:SetNetworkedBool("leftbl", false)
	self:SetNetworkedBool("rightbl", false)
	self:Fire('turnon', '', .5)
	self.VehicleIgnitionOn = true
	timer.Simple(.5, function()
		self:SetNetworkedBool("Started", true)
	end)
end

concommand.Add("perp_bl", function( ply, cmd, args )
    if(!ply or !ply:IsValid()) then return end
    if(!ply:InVehicle()) then return end
    if(!args[1]) then return end
    
    local side = tonumber(args[1])
    if(side == 1) then
		ply:GetVehicle():SetNetworkedBool("leftbl", !ply:GetVehicle():GetNetworkedBool("leftbl", false))
		ply:GetVehicle():SetNetworkedBool("rightbl", false)
    elseif(side == 2) then
		ply:GetVehicle():SetNetworkedBool("rightbl", !ply:GetVehicle():GetNetworkedBool("rightbl", false))
		ply:GetVehicle():SetNetworkedBool("leftbl", false)
    elseif(side == 3) then
		if(ply:GetVehicle():SetNetworkedBool("leftbl", false) and ply:GetVehicle():SetNetworkedBool("rightbl", false)) then
			ply:GetVehicle():SetNetworkedBool("leftbl", false)
			ply:GetVehicle():SetNetworkedBool("rightbl", false)
		else
			ply:GetVehicle():SetNetworkedBool("leftbl", true)
			ply:GetVehicle():SetNetworkedBool("rightbl", true)
		end
	end
end )

local CarDisabledTime = 60 * 5
hook.Add("Think", "CheckDisabledCars", function()
	for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
		if(v.Disabled and v.DisabledTime and CurTime() > v.DisabledTime + CarDisabledTime) then
			local owner = v:GetNetworkedEntity("owner")
			if(owner and owner:IsValid() and owner:IsPlayer()) then
				owner:RemoveCar()
				owner:Notify("Your car was removed because it sat disabled for too long!")
			end
		end
	end
end)
