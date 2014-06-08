
VEHICLE_DATABASE = {};

// Display order for garage.
VEHICLE_DISPLAY_ORDER = {"a", "b", "c", "d", "e", "f", "g", "h", "i","j", "k", "l" , "m", "n", "o", "p", "q", "r", "s", "t", "A", "B", "C", "D", "E", "F", "G", "L", "M", "N", "O", "P", "Q", "R", "S", "av"};
// Non-VIPS (Dealership)
VEHICLE_DISPLAY_ORDER_NORMAL = {"a", "b", "c", "d", "e", "f", "g", "h", "i","j", "k", "l" , "m", "n", "o", "p", "q", "r", "s", "t"};
// VIPS (Dealership)
VEHICLE_DISPLAY_ORDER_VIP = {"A", "B", "C", "D", "E", "F", "G"};
// GOLD's (Dealership)
VEHICLE_DISPLAY_ORDER_GOLD = {"V", "L", "M", "N", "O", "P", "Q", "R", "S"};

function GM:RegisterVehicle ( VehicleTable )
	if (VEHICLE_DATABASE[VehicleTable.ID]) then
		Error("Conflicting vehicle ID's #" .. VehicleTable.ID);
	end
	
	if (CLIENT && !VehicleTable.RequiredClass) then
		VehicleTable.Texture = surface.GetTextureID('perp2/vehicles/' .. VehicleTable.Script);
	end
	
	if(!VehicleTable.DynamicPaint) then
		for k, v in pairs(VehicleTable.PaintJobs) do
			util.PrecacheModel(v.model);
		end
	end
	
	VEHICLE_DATABASE[VehicleTable.ID] = VehicleTable;
	Msg("\t-> Loaded " .. VehicleTable.Name .. ", " .. VehicleTable.ID .. "\n");
end

function PLAYER:HasVehicle ( vehicleID )
	local playerTable;
	
	if SERVER then playerTable = self.Vehicles; else playerTable = GAMEMODE.Vehicles; end
	
	if (playerTable[vehicleID]) then return true; else return false; end
end

function GM.GetInnerCitySpeedLimit()
	return GetSharedInt("innercity_speedlimit_i", 60)
end

function GM.GetOutterCitySpeedLimit()
	return GetSharedInt("innercity_speedlimit_o", 100)
end

function ENTITY:IsInInnerCity()
	if(not InnerCity) then return false end
	
	for k, v in pairs(InnerCity) do
		if(table.HasValue(ents.FindInBox(v[1], v[2]), self)) then
			return true
		end
	end
	return false
end

function ENTITY:IsGovernmentVehicle()
	return self.vehicleTable and self.vehicleTable.RequiredClass and self.vehicleTable.RequiredClass != TEAM_ROADSERVICE and self.vehicleTable.RequiredClass != TEAM_BUSDRIVER
end