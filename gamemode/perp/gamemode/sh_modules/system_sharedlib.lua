// Shared Networking Library.
// Not sure who made this, but credits to them.
// I just converted it to the net library, and added SetSharedTable.
// - Hemirox

local entities = { }
local changedents = { }

local function set( entity, name, newvalue, ntype )
	if ( !entities[entity] ) then
		entities[entity] = { }
	end

	if ( entities[entity][name] && entities[entity][name].value == newvalue ) then
		// No change, no need to update.
		return false
	end
	
	if ( SERVER ) then
	
		if ( !changedents[entity] ) then
			changedents[entity] = { }
		end

		changedents[entity][name] = { value = newvalue, type = ntype, delete = false }
	
		if ( newvalue == nil ) then
			changedents[entity][name].delete = true
			entities[entity][name] = nil
			return true
		end
	end
	
	entities[entity][name] = { value = newvalue, type = ntype }
	
	return true
end

local function get( entity, name, default )	
	if ( entities[entity] && entities[entity][name] ) then
		if ( entities[entity][name].type == "Entity" ) then
			local value = Entity(entities[entity][name].value)
			if ( value && value:IsValid() ) then
				return value
			else
				return default
			end
		else
			return entities[entity][name].value
		end
	else
		return default
	end
end

if SERVER then

function syncjoin( Player )
	for ent, vars in pairs(entities) do
		for name, var in pairs(vars) do
			net.Start("perp_recv_shared")
				net.WriteInt(ent, 16)
				net.WriteString(tostring(name))
				net.WriteString(var.type)
				local ntype = var.type
				if ( ntype == "Entity" or ntype == "Int" ) then
					net.WriteInt(var.value, 32)
				else
					net["Write" .. ntype](var.value)
				end
			net.Send(Player)
		end
	end
end
hook.Add("PlayerInitialSpawn", "syncjoin", syncjoin)

local function sync( )
	for ent, vars in pairs(changedents) do
		for name, var in pairs(vars) do
			if ( var.delete ) then
				net.Start("perp_rem_shared")
					net.WriteInt(ent, 16)
					net.WriteString(tostring(name))
				net.Broadcast()
			else
				net.Start("perp_recv_shared")
					net.WriteInt(ent, 16)
					net.WriteString(tostring(name))
					net.WriteString(var.type)
					local ntype = var.type
					if ( ntype == "Entity" or ntype == "Int" ) then
						net.WriteInt(var.value, 32)
					else
						net["Write" .. ntype](var.value)
					end
				net.Broadcast()
			end
		end
	end
	changedents = { }
end
hook.Add("Tick", "netsync", sync)

local function entremoved( ent )
	local index = ent:EntIndex()
	net.Start("perp_remove_shared")
		net.WriteInt(index, 16)
	net.Broadcast()
	entities[index] = nil
	
	for ent, vars in pairs(changedents) do
		for name, var in pairs(vars) do
			if ( var.type == "Entity" && var.value == index ) then
			
				entities[ent][name] = nil
				
				if ( !changedents[entity] ) then
					changedents[entity] = { }
				end

				changedents[entity][name] = { delete = true }
			end
		end
	end
end
hook.Add("EntityRemoved", "netentremoved", entremoved)

else --CLIENT

local function receive()
	local index = net.ReadInt(16)
	local name = net.ReadString()
	local ntype = net.ReadString()
	if ( ntype == "Entity" or ntype == "Int" ) then
		local value = net.ReadInt(32)
		--MsgN("recv update "..name.." ("..tostring(value)..") on "..index)
		set(index, name, value, ntype)
	else
		local value = net["Read" .. ntype](data)
		--MsgN("recv update "..name.." ("..tostring(value)..") on "..index)
		set(index, name, value, ntype)
	end
end
net.Receive("perp_recv_shared", receive)

local function removed()
	local index = net.ReadInt(16)
	local name = net.ReadString()
	if ( entities[index] ) then
		entities[index][name] = nil
	end
end
net.Receive("perp_rem_shared", removed)

local function entremoved()
	local index = net.ReadInt(16)
	entities[index] = nil
end
net.Receive("perp_remove_shared", entremoved)

end

// ENTITY Shared Networking.

function ENTITY:GetSharedAngle( name, default )
	return get(self:EntIndex(), name, default)
end

function ENTITY:GetSharedBool( name, default )
	return tobool(get(self:EntIndex(), name, default))
end

function ENTITY:GetSharedEntity( name, default )
	return get(self:EntIndex(), name, default)
end

function ENTITY:GetSharedFloat( name, default )
	return get(self:EntIndex(), name, default)
end

function ENTITY:GetSharedInt( name, default )
	if ( default == nil ) then
		default = 0
	end
	return get(self:EntIndex(), name, default)
end

function ENTITY:GetSharedString( name, default )
	return get(self:EntIndex(), name, default)
end

function ENTITY:GetSharedVector( name, default )
	return get(self:EntIndex(), name, default)
end

function ENTITY:GetSharedTable( name, default )
	return get(self:EntIndex(), name, default)
end

function ENTITY:SetSharedAngle( name, value )
	return set(self:EntIndex(), name, value, "Angle")
end

function ENTITY:SetSharedBool( name, value )
	return set(self:EntIndex(), name, value, "Bit")
end

function ENTITY:SetSharedEntity( name, value )
	if ( value && value:IsValid() ) then
		return set(self:EntIndex(), name, value:EntIndex(), "Entity")
	else
		return set(self:EntIndex(), name, nil, "Entity")
	end
end

function ENTITY:SetSharedFloat( name, value )
	return set(self:EntIndex(), name, value, "Float")
end

function ENTITY:SetSharedInt( name, value )
	value = tonumber(value)
	return set(self:EntIndex(), name, value, "Int")
end

function ENTITY:SetSharedString( name, value )
	return set(self:EntIndex(), name, tostring(value), "String")
end

function ENTITY:SetSharedVector( name, value )
	return set(self:EntIndex(), name, value, "Vector")
end

function ENTITY:SetSharedTable( name, value )
	return set(self:EntIndex(), name, value, "Table")
end

// Global Shared Networked.

function GetSharedAngle( name, default )
	return get(-1, name, default)
end

function GetSharedBool( name, default )
	return tobool(get(-1, name, default))
end

function GetSharedEntity( name, default )
	return get(-1, name, default)
end

function GetSharedFloat( name, default )
	return get(-1, name, default)
end

function GetSharedInt( name, default )
	if ( default == nil ) then
		default = 0
	end
	return get(-1, name, default)
end

function GetSharedString( name, default )
	return get(-1, name, default)
end

function GetSharedVector( name, default )
	return get(-1, name, default)
end

function GetSharedTable( name, default )
	return get(-1, name, default)
end

function SetSharedAngle( name, value )
	return set(-1, name, value, "Angle")
end

function SetSharedBool( name, value )
	return set(-1, name, value, "Bit")
end

function SetSharedEntity( name, value )
	if ( value && value:IsValid() ) then
		return set(-1, name, value:EntIndex(), "Entity")
	else
		return set(-1, name, nil, "Entity")
	end
end

function SetSharedFloat( name, value )
	return set(-1, name, value, "Float")
end

function SetSharedInt( name, value )
	value = tonumber(value)
	return set(-1, name, value, "Int")
end

function SetSharedString( name, value )
	return set(-1, name, tostring(value), "String")
end

function SetSharedVector( name, value )
	return set(-1, name, value, "Vector")
end

function SetSharedTable( name, value )
	return set(-1, name, value, "Table")
end
