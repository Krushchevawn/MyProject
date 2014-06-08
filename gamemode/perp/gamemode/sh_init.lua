
// Random
PLAYER 						= 	FindMetaTable("Player");
ENTITY						= 	FindMetaTable("Entity");
VIEW_LOCK					=   999;


// Include shared files.
include("sh_config.lua");
include("sh_player.lua");
include("sh_items.lua");
include("sh_npcs.lua");
include("sh_shops.lua");
include("sh_skills.lua");
include("sh_mixtures.lua");
include("sh_misc.lua");
include("sh_property.lua");
include("sh_vehicles.lua");
include("sh_warehouse.lua");

for k, v in pairs(file.Find("PERP/gamemode/sh_modules/*.lua", "LUA")) do include("sh_modules/" .. v); end

Msg("Loading Items...\n")
local itemfiles = {
	"ammo",
	"drugs",
	"explosives",
	"food",
	"furniture",
	"items",
	"weapons"
}
for _, v in pairs(itemfiles) do
	for _, i in pairs(file.Find("PERP/gamemode/items/" .. v .. "/*.lua", "LUA")) do
		if(SERVER) then
			if(string.Left(i, 3) != "cl_") then
				include("items/" .. v .. "/" .. i)
			end
			AddCSLuaFile("items/" .. v .. "/" .. i)
		else
			if(string.Left(i, 3) != "sv_") then
				include("items/" .. v .. "/" .. i)
			end
		end
		
	end
end

Msg("Loading Shops...\n");
for k, v in pairs(file.Find("PERP/gamemode/shops/*.lua", "LUA")) do include("shops/" .. v); end

Msg("Loading Mixtures...\n");
for k, v in pairs(file.Find("PERP/gamemode/mixtures/*.lua", "LUA")) do include("mixtures/" .. v); end

Msg("Loading Vehicles...\n");
for k, v in pairs(file.Find("PERP/gamemode/vehicles/*.lua", "LUA")) do include("vehicles/" .. v); end

local function loadPostInt ( )
	Msg("Loading Properties...\n");
	for k, v in pairs(file.Find("PERP/gamemode/properties/*.lua", "LUA")) do include("PERP/gamemode/properties/" .. v); end
	
	Msg("Loading NPCs...\n");
	for k, v in pairs(file.Find("PERP/gamemode/npcs/*.lua", "LUA")) do include("PERP/gamemode/npcs/" .. v);	end
end
hook.Add("InitPostEntity", "loadPostInt", loadPostInt);

