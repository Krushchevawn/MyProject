GM.UMsgRedun = {};
function PLAYER:SetUMsgString ( StringID, StringValue )
	self.StringRedun = self.StringRedun or {};
	
	if StringValue == nil then
		self.StringRedun[StringID] = nil;
		
		net.Start("perp_ums");
			net.WriteEntity(self)
			net.WriteString(StringID)
			net.WriteInt(5, 16)
		net.Broadcast()
		
		return;
	end

	self.StringRedun[StringID] = {entity = self, value = StringValue};
	
	self:SendUMsgVar("perp_ums", nil, self, StringID, StringValue);
end

PLAYER.SetUMsgInt = PLAYER.SetUMsgString;
PLAYER.SetUMsgBool = PLAYER.SetUMsgString;

function PLAYER:SendUMsgVar ( Type, ToWho, Entity, StringID, StringValue, loadVar )
	if (ToWho && !IsValid(ToWho)) then return; end
	
	net.Start(Type);
		if (Type == "perp_ums") then
			net.WriteEntity(Entity)
		end
		
		net.WriteString(StringID)
		
		if type(StringValue) == "string" then
			net.WriteInt(1, 16)
			net.WriteString(StringValue)
		elseif type(StringValue) == "number" then
			if (math.floor(StringValue) != StringValue) then
				net.WriteInt(2, 16)
				net.WriteFloat(StringValue)
			else
				net.WriteInt(3, 16)
				
				if (StringID == "cash" || StringID == "bank") then
					net.WriteInt(StringValue, 32)
				else
					net.WriteInt(StringValue, 16)
				end
			end
		elseif type(StringValue) == "boolean" then
			net.WriteInt(4, 16)
			net.WriteBit(StringValue)
		end
		
		if (loadVar) then
			net.WriteBit(1) --true
		else
			net.WriteBit(0) --false
		end
	net.Send(ToWho)
end

function PLAYER:FindRunSpeed()
	if (!self.Stamina) then return; end
	
	self.LastSetSprint = self.LastSetSprint or "";
	
	local newSetSprint = {200, 300};
	if self.Crippled || self.currentlyRestrained then
		newSetSprint = {50, 75};
	else
		if GAMEMODE.IsSerious then
			if (self.Stamina > 0) then
				newSetSprint = {100, 300};
			else
				newSetSprint = {100, 100};
			end
		else
			if (self.Stamina > 0) then
				newSetSprint = {200, 300};
			else
				newSetSprint = {200, 200};
			end
		end
	end
	
	local prospectiveNewSprint = tostring(newSetSprint[1]) .. tostring(newSetSprint[2]);
	
	if (prospectiveNewSprint == self.LastSetSprint) then return; end
	
	self.LastSetSprint = prospectiveNewSprint;
	GAMEMODE:SetPlayerSpeed(self, newSetSprint[1], newSetSprint[2]);
end

function PLAYER:ForceRename ( )
	self.CanRenameFree = true;
		
	umsg.Start("perp_rename", self);
	umsg.End();
end

function PLAYER:HasBuddy ( otherPlayer )
	if (self == otherPlayer) then return true; end
	
	for k, v in pairs(self.Buddies) do
		if (v == tostring(otherPlayer:UniqueID())) then
			return true;
		end
	end
	
	return false;
end

function PLAYER:SpawnProp ( ItemTable, overrideType )
	if (self.lastSpawnProp && self.lastSpawnProp > CurTime() && !self:IsAdmin()) then
		self:Notify("Please slow down your prop spawning.")
		return false;
	end

	
	self.lastSpawnProp = CurTime() + 2;

	self.theirNumItems = self.theirNumItems or 0;
	
	 if (self.theirNumItems >= MAX_PROPS_VIP && !self:IsAdmin() || (!self:IsVIP() && self.theirNumItems >= MAX_PROPS_NORM) && !self:IsAdmin()) then
		self:Notify("You have reached the prop limit.")
		return
	end

	self.theirNumItems = self.theirNumItems + 1;

	local ty = overrideType or "ent_prop_item";

	local trace = {};
		trace.start = self:GetShootPos();
		trace.endpos = self:GetShootPos() + self:GetAimVector() * 50;
		trace.filter = self;
	local tRes = util.TraceLine(trace);

	local itemDrop = ents.Create(ty);
		if (!overrideType || overrideType == "prop_vehicle_prisoner_pod") then
			itemDrop:SetModel(ItemTable.WorldModel);
		end
		
		if (overrideType == "prop_vehicle_prisoner_pod") then
			itemDrop:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt");
			
			local SeatDatabase = list.Get("Vehicles")["Seat_Jeep"];
			if SeatDatabase.Members then table.Merge(itemDrop, SeatDatabase.Members); end
			if SeatDatabase.KeyValues then
				for k, v in pairs(SeatDatabase.KeyValues) do
					itemDrop:SetKeyValue(k, v);
				end
			end
		end
		
		if (itemDrop.SetContents) then
			itemDrop:SetContents(ItemTable.ID, self);
		end
		
		itemDrop:SetPos(tRes.HitPos);
	itemDrop:Spawn();
	
	itemDrop.pickupTable = ItemTable.ID;
	itemDrop.pickupPlayer = self;
	itemDrop.Owner = self
	itemDrop.ReturnToWarehouse = true
	itemDrop.ReturnToWarehouseOwner = self:SteamID()
	itemDrop.ReturnToWarehouseID = tonumber(ItemTable.ID)
	
	return itemDrop;
end

local allPossibleBlacklists = {'a', 'b'};
for k, v in pairs(GM.teamToBlacklist) do table.insert(allPossibleBlacklists, v); end
function PLAYER:RecompileBlacklists ( )
	local blacklistString = "";
	
	for k, v in pairs(allPossibleBlacklists) do
		local hasBL = self:HasBlacklist(v, true);
		
		if (hasBL) then
			blacklistString = blacklistString .. v .. "," .. hasBL .. ";";
		end
	end
	
	if (blacklistString == self:GetPrivateString("blacklists", "")) then return; end
		
	self:SetPrivateString("blacklists", blacklistString)
	DataBase:Query("UPDATE `perp_users` SET `blacklists`='" .. blacklistString .. "' WHERE `id`='" .. self.SMFID .. "'");
end

function PLAYER:GiveBlacklist ( id, time )
	if self:HasBlacklist(id) then return; end
	
	local endTime = os.time() + (time * 60 * 60);
	if (time == 0) then endTime = 0; end

	local newString = self:GetPrivateString("blacklists", "") .. id .. "," .. endTime .. ";";
	self:SetPrivateString("blacklists", newString);
	DataBase:Query("UPDATE `perp_users` SET `blacklists`='" .. newString .. "' WHERE `id`='" .. self.SMFID .. "'");
	
	for k, v in pairs(player.GetAll()) do
		umsg.Start("RecievePlayerBlacklists", v)
			umsg.Entity(self)
			umsg.String(self:GetPrivateString("blacklists", ""))
		umsg.End()
	end
end

function PLAYER:UnBlackList( id )
	if(!self:HasBlacklist( id, true )) then return end
	local blist = string.Explode(";", self:GetPrivateString("blacklists", ""))
	table.remove(blist)
	for k, v in pairs(blist) do
		if(string.find(v, id)) then
			table.remove(blist, k)
			break
		end
	end
	local str = ""
	for k,v in pairs(blist) do
		str = str .. v .. ";"
	end
	self:SetPrivateString("blacklists", str)
	DataBase:Query("UPDATE `perp_users` SET `blacklists`='" .. str .. "' WHERE `id`='" .. self.SMFID .. "'");
	self:RecompileBlacklists()
	umsg.Start("reloadplayerblacklist")
	umsg.End()
	
	for k, v in pairs(player.GetAll()) do
		umsg.Start("RecievePlayerBlacklists", v)
			umsg.Entity(self)
			umsg.String(self:GetPrivateString("blacklists", ""))
		umsg.End()
	end
end

function PLAYER:StripMains ( )
	if (self.PlayerItems[1]) then
		self.PlayerItems[1].Table.Holster(self);
	end
		
	if (self.PlayerItems[2]) then
		self.PlayerItems[2].Table.Holster(self);
	end
end

function PLAYER:EquipMains ( )
	if (self.PlayerItems[1]) then
		self.PlayerItems[1].Table.Equip(self);
	end
		
	if (self.PlayerItems[2]) then
		self.PlayerItems[2].Table.Equip(self);
	end
end

function PLAYER:RemoveEquipped ( ID )
	local id
	if (ID == EQUIP_MAIN) then id = 1 end
	if (ID == EQUIP_SIDE) then id = 2 end
	
	if (!id) then return end
	
	if(self.PlayerItems and self.PlayerItems[id] and self.PlayerItems[id].Table) then
		self.PlayerItems[id].Table.Holster(self)
		self.PlayerItems[id] = nil
		
		umsg.Start("perp_rem_eqp", self)
			umsg.Short(id)
		umsg.End()
	end
end

function PLAYER:Arrest()
	self:ArrestTP()
end


function PLAYER:ArrestTP ( )
	if (self.CurrentlyArrested) then return end
	if (self:Team() != TEAM_CITIZEN) then return end
	
	local goTime = JAIL_TIME
	if (self:GetSharedBool("warrent", false)) then
		goTime = JAIL_TIME_WARRENTED
		self:SetSharedBool("warrent", false)
	end
	
	local arrestPos = GAMEMODE.JailLocations[1]
	for k, v in pairs(GAMEMODE.JailLocations) do
		local dontDo
		for _, ent in pairs(player.GetAll()) do
			if (ent:GetPos():Distance(v) <= 100) then
				dontDo = true
			end
		end
		
		if (!dontDo) then
			arrestPos = v
			break
		end
	end
	
	self:SetPos(arrestPos)
	
	umsg.Start('perp_arrested', self)
		umsg.Short(goTime)
	umsg.End()
	
	umsg.Start('perp_strip_main', self) umsg.End()
	
	self:RemoveEquipped(EQUIP_MAIN)
	self:RemoveEquipped(EQUIP_SIDE)
	
	self.CurrentlyArrested = true
	
	
	timer.Simple(goTime, function ( )
		if (self && IsValid(self) && self:IsPlayer() and self.CurrentlyArrested) then
			self.CurrentlyArrested = nil
			
			local arrestPos = GAMEMODE.UnjailLocations[1]
			for k, v in pairs(GAMEMODE.UnjailLocations) do
				local dontDo
				for _, ent in pairs(player.GetAll()) do
					if (ent:GetPos():Distance(v) <= 100) then
						dontDo = true
					end
				end
				
				if (!dontDo) then
					arrestPos = v
					break
				end
			end
			
			self:SetPos(arrestPos)
		end
	end)
end

local saveString = "UPDATE `perp_users` SET `cash`='%d', `time_played`='%d', `last_played`='%d', `items`='%s', `skills`='%s', `genes`='%s', `formulas`='%s', `bank`='%d', `ringtone`='%d', `ammo_pistol`='%d', `ammo_rifle`='%d', `ammo_shotgun`='%d', `fuelleft`='%d', `lastcar`='%s' WHERE `id`='%s'";
function PLAYER:Save ( )
	if (!self.SMFID) then return false; end
	
	local rpName = tmysql.escape(self:GetRPName())
	DataBase:Query("UPDATE `ip_intel` SET `rp_name`='" .. rpName .. "' WHERE `steamid`='" .. self:SteamID() .. "' LIMIT 1")
	
	if (!self.AlreadyLoaded) then
		for i = 1, 5 do
			self:ChatPrint("Your account is not authorized to save. Reconnect or your progress will not be saved.");
		end
		
		Msg("Refused to save " .. self:Nick() .. ".\n");
		
		return
	end
	
	Msg("Saved " .. self:Nick() .. ".\n");
	
	local timeSinceJoin = CurTime() - math.Round(self.joinTime or CurTime());
	
	local skills = "";
	for i = 1, #SKILLS_DATABASE do	
		skills = skills .. self:GetPrivateInt("s_" .. i, 0) .. ";";
	end
	
	local genes = self:GetPrivateInt("gpoints", 0) .. ";";
	for i = 1, #GENES_DATABASE do	
		genes = genes .. self:GetPrivateInt("g_" .. i, 0) .. ";";
	end
	
	local formulas = self:GetPrivateString("mixtures", "");
	
	DataBase:Query(string.format(saveString, 	
											self:GetPrivateInt("cash", 0), 
											self:GetPrivateInt("time_played", 0) + timeSinceJoin, 
											os.time(), 
											self:CompileItems(),
											skills,
											genes,
											formulas,
											self:GetPrivateInt("bank", 0), 
											tonumber(self:GetSharedInt("ringtone", 1)),
											self:GetAmmoCount('pistol'),
											self:GetAmmoCount('smg1'),
											self:GetAmmoCount('buckshot'),
											self:GetPrivateInt("fuelleft", 0),
											self:GetPrivateInt("lastcar", 0),
											
											self.SMFID
								)
				);
end

function PLAYER:Warrant( reason )
	self.UnwarrentTime = CurTime() + WARRENT_TIME;
	self:SetSharedBool("warrent", true)
	self:Notify("You have been warrented for: " .. reason)
	for k,v in pairs(player.GetAll()) do
		if(v:Team() != TEAM_CITIZEN) then
			v:Notify(self:GetRPName() .. " has been warrented for: " .. reason)
		end
	end
end

function PLAYER:UnWarrant()
	self.UnwarrentTime = nil
	self:SetSharedBool("warrent", false)
	self:Notify("Your warrant was revoked!")
	for k,v in pairs(player.GetAll()) do
		if(v:Team() != TEAM_CITIZEN) then
			v:Notify(self:GetRPName() .. " has been un-warrented!")
		end
	end
end

function PLAYER:SaveInventoryOnly()
	DataBase:Query("UPDATE `perp_users` SET `items`='%s' WHERE `id`='" .. self:SteamID() .. "'")
end

function PLAYER:DemoteFromJob()
	if (self:Team() == TEAM_POLICE) then
		GAMEMODE.Police_Leave(self);
	elseif (self:Team() == TEAM_MEDIC) then
		GAMEMODE.Medic_Leave(self);
	elseif (self:Team() == TEAM_FIREMAN) then
		GAMEMODE.Fireman_Leave(self);
	elseif (self:Team() == TEAM_SWAT) then
		GAMEMODE.Swat_Leave(self);
	elseif (self:Team() == TEAM_DISPATCHER) then
		GAMEMODE.Dispatcher_Leave(self);
	elseif (self:Team() == TEAM_SECRET_SERVICE) then
		GAMEMODE.Secret_Service_Leave(self);
	elseif (self:Team() == TEAM_MAYOR) then
		GAMEMODE.Mayor_Leave(self);
	elseif (self:Team() == TEAM_BUSDRIVER) then
		GAMEMODE.BusDriver_Leave(self);
	elseif (self:Team() == TEAM_ROADSERVICE) then
		GAMEMODE.RoadServices_Leave(self);
	elseif (self:Team() == TEAM_CITIZEN) then
		return false;
	else return false; end
	return true;
end

local function CheckAndAdjust(posMax, posMin, tr, npos)
    tr.start, tr.endpos = posMin, posMax;
    local res = util.TraceLine(tr);
    if (res.Hit && !res.StartSolid) then
        return (npos - (posMax - res.HitPos));
    else
        tr.start, tr.endpos = posMax, posMin;
        res = util.TraceLine(tr);
        if (res.Hit && !res.StartSolid) then
            return (npos - (posMin - res.HitPos));
        end
    end
    return npos;
end

function PLAYER:TasePlayer( ply )
	if( self:Team() != TEAM_POLICE ) then return end
	if( self.taserent ) then return false end
	if(ply.LastTaze and CurTime() < ply.LastTaze + 15) then return false end
		
	-- create ragdoll
	local rag = ents.Create( "prop_ragdoll" )
	if not rag:IsValid() then return end
	rag:SetModel( ply:GetModel() )
	rag:SetKeyValue( "origin", ply:GetPos().x .. " " .. ply:GetPos().y .. " " .. ply:GetPos().z )
	rag:SetAngles( ply:GetAngles() )
	rag:Spawn()
	rag:Activate()
	rag:GetPhysicsObject():SetVelocity(4*ply:GetVelocity())
	
	ply:DrawViewModel(false)
	ply:DrawWorldModel(false)
	ply:Spectate( OBS_MODE_CHASE )
	ply:SpectateEntity(rag)

	self.taserent = rag
	self.taserply = ply
	rag.taseredply = ply
	rag.tasertime = CurTime()
	timer.Simple( 10, function() 
		if(!self.taserent) then return end
		local ent = self.taserent
		if ent.taseredply and ent.taseredply:IsValid() then
			local phy = ent:GetPhysicsObject()
			phy:EnableMotion(false)
			ent:SetSolid(SOLID_NONE)
			ent.taseredply:UnSpectate()
			ent.taseredply.DontFixCripple = true
			ent.taseredply:Spawn()
			ent.taseredply:SetPos(ent:GetPos())
			ent.taseredply:SetAngles(ent:GetAngles())
			ent.taseredply:DrawViewModel(true)
			ent.taseredply:DrawWorldModel(true)
			ent.taseredply:SetVelocity(ent:GetPhysicsObject():GetVelocity())
			ent.taseredply:Freeze(true)

			timer.Simple( 3, function()
				if(self.taserply and self.taserply:IsValid() and self.taserply:IsPlayer()) then
					self.taserply:Freeze(false)
					self.taserply = nil
				end
			end)
			
		end
		self.taserent = nil
		ent:Remove()
	end)
	ply.LastTaze = CurTime()
	return true
end

hook.Add( "Think", "CheckTasedRags", function()
	for k,v  in pairs(ents.FindByClass("prop_ragdoll")) do
		if(!v:IsValid()) then continue end
		if(v.tasertime and CurTime() > v.tasertime + 15) then --Something went wrong..
			if(v.taseredply and v.taseredply:IsValid()) then
				local ply = v.taseredply
				ply.DontFixCripple = true
				ply:Spawn()
				ply:DrawViewModel(true)
				ply:DrawWorldModel(true)
				ply:SetPos(v:GetPos())
				ply:SetAngles(v:GetAngles())
				ply:SetVelocity(v:GetPhysicsObject():GetVelocity())
				ply:Freeze(false)
			end
			v:Remove()
		end
	end
end )

/*
function PLAYER:AddLog( logtype, log )
	if(!PLAYER:IsModerator()) then return end
	net.Start("perp_log")
		net.WriteString(logtype)
		net.WriteString(log)
	net.Send(self)
end*/
