
/*Add Net Messages*/
util.AddNetworkString( "perp_vehicles_init" )
util.AddNetworkString( "perp_items_init" )
util.AddNetworkString( "perp_startup" )
util.AddNetworkString( "perp_recv_shared" )
util.AddNetworkString( "perp_rem_shared" )
util.AddNetworkString( "perp_remove_shared" )
util.AddNetworkString( "perp_ps" )
util.AddNetworkString( "perp_log" )
util.AddNetworkString( "perp_ums" )
util.AddNetworkString("Perp_PhysColor")
util.AddNetworkString("perp_ac")

// Include the shared init file.
include("sh_init.lua");

// Include the server files.
include("sv_config.lua");
include("sv_hooks.lua");
include("sv_networking.lua");
include("sv_player.lua");
include("sv_items.lua");
include("sv_skills.lua");
include("sv_misc.lua");
include("sv_chat.lua");
include("sv_organizations.lua");
include("sv_vehicles.lua");
include("sv_trade.lua");
include("sv_warehouse.lua");
include("sv_surfaceproperties.lua")

GM.maxPlayers = 50

for k, v in pairs(file.Find("PERP/gamemode/sv_modules/*.lua", "LUA")) do include("sv_modules/" .. v) end
for k, v in pairs(file.Find("PERP/gamemode/sounds/*.lua", "LUA")) do include("sounds/" .. v) end

// Add client lua resources.
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("cl_player.lua");
AddCSLuaFile("cl_networking.lua");
AddCSLuaFile("cl_hooks.lua");
AddCSLuaFile("cl_misc.lua");
AddCSLuaFile("cl_items.lua");
AddCSLuaFile("cl_chat.lua");
AddCSLuaFile("cl_vehicles.lua");
AddCSLuaFile("cl_trade.lua");
AddCSLuaFile("cl_scoreboards.lua");

AddCSLuaFile("sh_init.lua");
AddCSLuaFile("sh_player.lua");
AddCSLuaFile("sh_items.lua");
AddCSLuaFile("sh_config.lua");
AddCSLuaFile("sh_npcs.lua");
AddCSLuaFile("sh_shops.lua");
AddCSLuaFile("sh_skills.lua");
AddCSLuaFile("sh_misc.lua");
AddCSLuaFile("sh_mixtures.lua");
AddCSLuaFile("sh_property.lua");
AddCSLuaFile("sh_vehicles.lua");
AddCSLuaFile("sh_warehouse.lua");

for k, v in pairs(file.Find("PERP/gamemode/cl_modules/*.lua", "LUA")) do AddCSLuaFile("cl_modules/" .. v); end
for k, v in pairs(file.Find("PERP/gamemode/sh_modules/*.lua", "LUA")) do AddCSLuaFile("sh_modules/" .. v); end
for k, v in pairs(file.Find("PERP/gamemode/vgui/*.lua", "LUA")) do AddCSLuaFile("vgui/" .. v); end
for k, v in pairs(file.Find("PERP/gamemode/items/*.lua", "LUA")) do AddCSLuaFile("items/" .. v); end
for k, v in pairs(file.Find("PERP/gamemode/npcs/*.lua", "LUA")) do AddCSLuaFile("npcs/" .. v); end
for k, v in pairs(file.Find("PERP/gamemode/shops/*.lua", "LUA")) do AddCSLuaFile("shops/" .. v); end
for k, v in pairs(file.Find("PERP/gamemode/mixtures/*.lua", "LUA")) do AddCSLuaFile("mixtures/" .. v); end
for k, v in pairs(file.Find("PERP/gamemode/properties/*.lua", "LUA")) do AddCSLuaFile("properties/" .. v); end
for k, v in pairs(file.Find("PERP/gamemode/vehicles/*.lua", "LUA")) do AddCSLuaFile("vehicles/" .. v); end
for k, v in pairs(file.Find("PERP/gamemode/scoreboards/*.lua", "LUA")) do AddCSLuaFile("scoreboards/" .. v); end

local ClientResources = 0;
local function ProcessFolder ( Location )
	local a, b = file.Find(Location .. '/*', "GAME")
	for k,v in pairs(a) do
		local loc = Location
		local OurLocation = string.gsub(loc .. v, 'gamemodes/PERP/content/', '')
		if string.sub(loc, -2) != 'db' then
			ClientResources = ClientResources + 1;
			resource.AddFile(OurLocation)
		end
	end
	for k, v in pairs(b) do
		local loc = Location .. v .. "/"
		for _, f in pairs(file.Find(loc .. "/*", "GAME")) do
			local OurLocation = string.gsub(loc .. f, 'gamemodes/PERP/content/', '')
			
			if string.sub(loc, -2) != 'db' then
				ClientResources = ClientResources + 1;
				resource.AddFile(OurLocation)
			end
		end
		ProcessFolder( loc )
	end
end

/*if game.IsDedicated() then
	ProcessFolder('gamemodes/PERP/content/models/')
	ProcessFolder('gamemodes/PERP/content/materials/')
	ProcessFolder('gamemodes/PERP/content/sound/')
	ProcessFolder('gamemodes/PERP/content/resource/')
end*/

Msg("Sent " .. ClientResources .. " client resources.\n")