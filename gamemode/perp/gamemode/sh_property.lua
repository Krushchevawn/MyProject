
PROPERTY_DATABASE = {};

local policeDoors = {
						{Vector(-7515, -9169, 518.28100585938), 'models/props_c17/door01_left.mdl'},
						{Vector(-6963, -9169, 518.28100585938), 'models/props_c17/door01_left.mdl'},
						{Vector(-6528, -9556.5, 527.5), '*218'},
						{Vector(-6528, -9423.5, 527.5), '*219'},
						{Vector(-7432, -9099, 1798), 'models/props_c17/door01_left.mdl'},
						{Vector(-7432, -8975, 1798), 'models/props_c17/door01_left.mdl'},
						{Vector(-7060, -8975, 1798), 'models/props_c17/door01_left.mdl'},
						{Vector(-7060, -9099, 1798), 'models/props_c17/door01_left.mdl'},
						{Vector(-7308, -9101, 3845.25), 'models/props_c17/door01_left.mdl'},
						{Vector(-7214, -9101, 3845.25), 'models/props_c17/door01_left.mdl'},
						{Vector(-6760, -9359, 3845.25), 'models/props_c17/door01_left.mdl'},
						{Vector(-6760, -9499, 3845.25), 'models/props_c17/door01_left.mdl'},
						{Vector(-7125, -8798, -377.75), 'models/props_c17/door03_left.mdl'},
						{Vector(-7389, -9272, -377.75), 'models/props_c17/door03_left.mdl'},
						{Vector(-3816, -8232, 290), '*113'},
						{Vector(-3816, -7944, 290), '*111'},
						{Vector(-3816, -7656, 290), '*112'},
						{Vector(-3804, -7572.009765625, 248), '*115'},
						{Vector(-3684, -7572.009765625, 248), '*114'},
						{Vector(-3828, -7122, 252.25), 'models/props_c17/door01_left.mdl'},
						{Vector(-3828, -7306.990234375, 252.25), 'models/props_c17/door01_left.mdl'},
						{Vector(-3828, -7370.990234375, 252.25), 'models/props_c17/door01_left.mdl'},
						{Vector(-3659, -7317, 252.25), 'models/props_c17/door01_left.mdl'},
						{Vector(-3659, -7381, 252.25), 'models/props_c17/door01_left.mdl'},
                        {Vector(-9383, 9044, 126.281), 'models/props_c17/door03_left.mdl'},
                        {Vector(-9768, 9097, 126.281), 'models/props_c17/door03_left.mdl'},
                        {Vector(-9880, 9334, 126.25), 'models/props_c17/door03_left.mdl'},
                        {Vector(-9880, 9240, 126.25), 'models/props_c17/door03_left.mdl'},
                        {Vector(-10256, 9020, 126.25), 'models/props_c17/door03_left.mdl'},
                        {Vector(-10015, 9495, 126.25), 'models/props_c17/door03_left.mdl'},
                        {Vector(-10121, 9495, 126.25), 'models/props_c17/door03_left.mdl'},
                        {Vector(-10529, 9231, 126.25), 'models/props_c17/door03_left.mdl'},
                        {Vector(-10623, 9231, 126.25), 'models/props_c17/door03_left.mdl'},
                        {Vector(-10609, 9495, 126.25), 'models/props_c17/door03_left.mdl'},
                        {Vector(-10703, 9495, 126.25), 'models/props_c17/door03_left.mdl'},
					}
					
local civilDoors = 	{
                       
					}
					
local clubDoors = 	{
						{Vector(-6967, -12459, 135), '*244'},
						{Vector(-7089, -12459, 135), '*245'}
					}
					
function ENTITY:IsPoliceDoor ( )
	if (!self:IsDoor()) then return false; end
	if (self.isPoliceDoor) then return true; end
	
	for k, v in pairs(policeDoors) do
		if (v[1]:Distance(self:GetPos()) < 50 && v[2] == self:GetModel()) then
			self.isPoliceDoor = true;
			return true;
		end
	end
	
	return false;
end

function ENTITY:IsCivilDoor ( )
	if (!self:IsDoor()) then return false; end
	if (self.isCivilDoor) then return true; end
	
	for k, v in pairs(civilDoors) do
		if (v[1]:Distance(self:GetPos()) < 50 && v[2] == self:GetModel()) then
			self.isCivilDoor = true;
			return true;
		end
	end
	
	return false;
end

function ENTITY:IsClubDoor ( )
	if (!self:IsDoor()) then return false; end
	if (self.isClubDoor) then return true; end
	
	for k, v in pairs(clubDoors) do
		if (v[1]:Distance(self:GetPos()) < 50 && v[2] == self:GetModel()) then
			self.isClubDoor = true;
			return true;
		end
	end
	
	return false;
end;

function GM.FindEntity ( pos, model )
	for _, ent in pairs(ents.FindInSphere(pos, 50)) do
		//if (ent:GetModel() == model) then
			return ent
		//end
	end
end

function GM:RegisterProperty ( PropertyTable )
	if (PROPERTY_DATABASE[PropertyTable.ID]) then
		Error("Conflicting property ID's #" .. PropertyTable.ID);
	end
	
	if CLIENT then
		PropertyTable.Texture = surface.GetTextureID("PERP2/property/" .. PropertyTable.Image);
	else
		for k, v in pairs(PropertyTable.Doors) do
			local foundDoor = false
			
			for _, ent in pairs(ents.FindInSphere(v[1], 50)) do
				if (ent:IsDoor() && ent:GetModel() == v[2]) then
					ent:Fire("lock", "", 0);
					foundDoor = true
					break
				end
			end
			
			if (!foundDoor) then
				Msg("\t\tMissing Door -> " .. PropertyTable.Name .. " #" .. k .. "\n")
			end
		end
	end
	
	Msg("\t-> Loaded " .. PropertyTable.Name .. "\n");

	PROPERTY_DATABASE[PropertyTable.ID] = PropertyTable;
end

function PLAYER:CanManipulateDoor ( door )
	if ( self:Team() != TEAM_CITIZEN && door:IsPoliceDoor()) then return true; end
	if (self:Team() == TEAM_CITIZEN && door:IsCivilDoor()) then return true; end
	
	if (!door:IsDoor() && !door:IsVehicle()) then return false; end
	
	local doorOwner = door:GetTrueOwner();
	if (!doorOwner || !IsValid(doorOwner) || !doorOwner:IsPlayer()) then return false; end
	
	if (self == doorOwner || doorOwner:HasBuddy(self)) then return true; end
		
	return false;
end

function ENTITY:IsDoor ( )
	return self:GetClass() != "item_doorbuster" and string.find(self:GetClass(), "door");
end

local doorAssosiations = {};
function ENTITY:GetPropertyTable ( )
	if (!self:IsDoor()) then return nil; end
	
	if (!doorAssosiations[self:EntIndex()]) then
		for k, v in pairs(PROPERTY_DATABASE) do
			for _, doorInfo in pairs(v.Doors) do
				if (doorInfo[1]:Distance(self:GetPos()) < 50 && self:GetModel() == doorInfo[2]) then
					doorAssosiations[self:EntIndex()] = k;
				end
			end
		end
	end
	
	return PROPERTY_DATABASE[doorAssosiations[self:EntIndex()]];
end

function ENTITY:GetTrueOwner ( )
	if (!self:IsVehicle() && !self:IsDoor()) then return nil; end
	
	if (self:IsDoor()) then
		if (self:GetPropertyTable()) then
			return GetGlobalEntity("p_" .. self:GetPropertyTable().ID);
		else
			return nil;
		end
	end
	
	return self:GetNetworkedEntity("owner");
end

ENTITY.GetDoorOwner = ENTITY.GetTrueOwner;
ENTITY.GetVehicleOwner = ENTITY.GetTrueOwner;
ENTITY.GetCarOwner = ENTITY.GetTrueOwner;

if CLIENT then return; end

local autolockDoors = 	{
							{Vector(-6967, -12459, 135), '*244'},
							{Vector(-7089, -12459, 135), '*245'}
						};
						
local autodeleteEnts = 	{
							{Vector(-7744, -9204.5, 888), '*144'},
							{Vector(-7738, -9204.5, 888), '*143'},
							{Vector(-7744, -9204.5, 888), '*144'},
							{Vector(-7738, -9204.5, 888), '*143'},
							{Vector(-7670, -9109.41015625, 888), '*155'},
							{Vector(-7664, -9109.41015625, 888), '*156'},
							{Vector(-7838, -9109.5, 888), '*153'},
							{Vector(-7832, -9109.5, 888), '*154'},
							{Vector(-7906, -9204.5, 888), '*145'},
							{Vector(-7912, -9204.5, 888), '*146'},
							{Vector(-8006, -9109.5, 888), '*151'},
							{Vector(-8000, -9109.5, 888), '*152'},
							{Vector(-8091.4399414063, -9118.98046875, 888), '*147'},
							{Vector(-8091.4301757813, -9112.9697265625, 888), '*148'},
							{Vector(-8080, -9204.5, 888), '*150'},
							{Vector(-8074, -9204.5, 888), '*149'},
							{Vector(-9001, -9899.8603515625, 117.08000183105), '*119'},
							{Vector(-9001, -9851.8603515625, 117.08000183105), '*117'},
							{Vector(-6761.5, -9456, 890), '*128'},
							{Vector(-6761.5, -9450, 890), '*130'},
						};
						
local autoopenDoors =	{
							{Vector(-8992, -9985, 196), '*116'},
							{Vector(-8992, -9769, 196), '*118'},
							{Vector(-6768, -8892, -377.75), 'models/props_c17/door03_left.mdl'},
							{Vector(-9880, 9334, 126.25), 'models/props_c17/door03_left.mdl'},
							{Vector(-9880, 9240, 126.25), 'models/props_c17/door03_left.mdl'},
							{Vector(-10015, 9495, 126.25), 'models/props_c17/door03_left.mdl'},
							{Vector(-10121, 9495, 126.25), 'models/props_c17/door03_left.mdl'},
							{Vector(-6768, -8986, -377.75), 'models/props_c17/door03_left.mdl'},
							{Vector(-6768, -8892, -377.75), 'models/props_c17/door03_left.mdl'},
							
						}
						
local function lockDoors ( )
	for k, v in pairs(autolockDoors) do
		for _, ent in pairs(ents.FindInSphere(v[1], 50)) do
			if (ent:IsDoor() && ent:GetModel() == v[2]) then
				ent:Fire("lock", "", 0);
			end
		end
	end
	
	for k, v in pairs(autoopenDoors) do
		for _, ent in pairs(ents.FindInSphere(v[1], 50)) do
			if (ent:IsDoor() && ent:GetModel() == v[2]) then
				ent:Fire("open", "", 0);
			end
		end
	end
	
	for k, v in pairs(autodeleteEnts) do
		for _, ent in pairs(ents.FindInSphere(v[1], 50)) do
			if (ent:GetModel() == v[2]) then
				ent:Remove()
			end
		end
	end
	
	for k, ent in pairs(ents.FindByClass("prop_physics")) do ent:Remove() end
	for k, ent in pairs(ents.FindByClass("prop_physics_multiplayer")) do ent:Remove() end
	
	for k, v in pairs(policeDoors) do
		for _, ent in pairs(ents.FindInSphere(v[1], 50)) do
			if (ent:IsDoor() && ent:GetModel() == v[2]) then
				ent:Fire("lock", "", 0);
			end
		end
	end
	
	for k, v in pairs(civilDoors) do
		for _, ent in pairs(ents.FindInSphere(v[1], 50)) do
			if (ent:IsDoor() && ent:GetModel() == v[2]) then
				ent:Fire("lock", "", 0);
			end
		end
	end
end
hook.Add("InitPostEntity", "lockDoors", lockDoors);

function GM.ToggleProperty ( Player, Cmd, Args )
	if (!Args[1]) then return; end
	
	local property = tonumber(Args[1]);
	
	if (!PROPERTY_DATABASE[property]) then return; end
	
	local curOwner = GetGlobalEntity('p_' .. property);
	local hasOwner = curOwner && curOwner:IsValid() && curOwner:IsPlayer();
	
	if (hasOwner && curOwner != Player) then return; end
	
	local cost = PROPERTY_DATABASE[property].Cost + math.Round(PROPERTY_DATABASE[property].Cost * GAMEMODE.GetTaxRate_Sales())
	
	if (!hasOwner && Player:GetCash() < cost) then return; end
	
	if (hasOwner) then
		Player:GiveCash(math.Round(PROPERTY_DATABASE[property].Cost * .5));
		GAMEMODE.HouseAlarms[property] = nil;
		
		Player.OwnsThisProperty = nil;
		
		SetGlobalEntity("p_" .. property, NULL);
	else
		GAMEMODE.GiveCityMoney(math.Round(PROPERTY_DATABASE[property].Cost * GAMEMODE.GetTaxRate_Sales()))
		Player:TakeCash(cost);
		
		if (PROPERTY_DATABASE[property].OnBought) then
			PROPERTY_DATABASE[property].OnBought()
		end
		
		Player.OwnsThisProperty = property;
		
		SetGlobalEntity("p_" .. property, Player);
	end
end
concommand.Add("perp_p_b", GM.ToggleProperty);

local function showReadout ( user )
	if (game.IsDedicated()) then return end
	
	local ent = user:GetEyeTrace().Entity
	
	Msg("{Vector(" .. ent:GetPos().x .. ", " .. ent:GetPos().y .. ", " .. ent:GetPos().z .. "), '" .. ent:GetModel() .. "'},\n")
end
concommand.Add("perp_p_s", showReadout)