// log IPs
local function logIPs ( user )
	if (!user || !IsValid(user) || !user:IsPlayer() || !user.IPAddress || !user.SteamID || !user.Nick || !user.UniqueID) then return end
	local steamID = user:SteamID()
	local ipAddress = string.Explode(":", user:IPAddress())[1] or "INVALID IP ADDRESS"
	local name = tmysql.escape(user:Nick())
	local uniqueID = user:UniqueID()
	local curTime = os.time()
	
	user.playerJoinTime = CurTime()
	
	DataBase:Query("INSERT INTO `ip_intel` (`steamid`, `ip`, `name`, `first_seen`, `last_seen`, `num_seen`, `unique_id`, `rp_name`, `play_time`) VALUES ('" .. steamID .. "', '" .. ipAddress .. "', '" .. name .. "', '" .. curTime .. "', '" .. curTime .. "', '1', '" .. uniqueID .. "', '', '0') ON DUPLICATE KEY UPDATE `ip`='" .. ipAddress .. "', `name`='" .. name .. "', `last_seen`='" ..curTime .. "', `num_seen`=`num_seen`+'1'")
end
hook.Add("PlayerInitialSpawn", "logIPs", logIPs)

local function saveNewPlayTime ( user )	
	if (!user || !IsValid(user) || !user:IsPlayer() || !user.playerJoinTime || !user.SteamID) then return end
	local addedPlayTime = math.floor(CurTime() - user.playerJoinTime)
	user.playerJoinTime = CurTime()
	
	DataBase:Query("UPDATE `ip_intel` SET `play_time`=`play_time`+'" .. addedPlayTime .. "' WHERE `steamid`='" .. user:SteamID() .. "' LIMIT 1")
end
hook.Add("PlayerDisconnected", "saveNewPlayTime", saveNewPlayTime)

Msg("Loading gatekeeper module... ")
require("gatekeeper")

if (gatekeeper) then
	Msg("done!\n")
else
	Msg("failed! Locking server to maintain security...\n")
	//RunConsoleCommand("sv_password", "security123")
	return
end

local serverBans = {}

local function manageIncomingConnections ( Name, Pass, SteamID, IP )
	Msg(tostring(Name) .. " [" .. tostring(IP) .. "] joined with steamID " .. tostring(SteamID) .. ".\n")
	
	// We don't wanna mess with this if it's single player.
	if (game.SinglePlayer()) then return end
	if (!game.IsDedicated()) then return end
	
	if (SteamID == "STEAM_ID_PENDING") then return {false, "SteamID Error."}; end
	
	return
end
hook.Add("PlayerPasswordAuth", "manageIncomingConnections", manageIncomingConnections)

concommand.Add("pp_mat_overlay", function() end)
