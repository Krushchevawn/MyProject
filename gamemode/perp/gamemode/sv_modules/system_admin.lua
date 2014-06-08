 


function PLAYER:PERPBan ( banTime, banReason, ply  )
	local bannerName = "Autobot"
	if (ply && IsValid(ply)) then 
		bannerName = ply:Nick()
		ply:Notify("Player banned.")
	end
	
	self:PDBan(bannerName, banTime, banReason)
end

function BanPlayer ( Player, Cmd, Args ) end

function PLAYER:Kick2 (r) 
	self:Kick(r) 
end 
concommand.Add("perp_a_b", BanPlayer);

local function SetSpectate ( Player, Command, Args )
	if !Player:IsModerator() then return false; end
	if (!Args[1]) then return; end
	
	local toBeBanned = Args[1];
	local toBeBannedPlayer;
	for k, v in pairs(player.GetAll()) do
		if (v:UniqueID() == toBeBanned) then
			toBeBannedPlayer = v;
		end
	end
	if (!toBeBannedPlayer) then Player:Notify("Could not find that player."); return; end
		
	Player:GetTable().Spectating = toBeBannedPlayer;
	
	if(!Player.SpecType) then Player.SpecType = OBS_MODE_CHASE end
	Player:Spectate(Player.SpecType)
	
	Player:SpectateEntity(toBeBannedPlayer) 
end
concommand.Add('perp_a_s', SetSpectate);
	
local function ChangeSpecType ( Player, Command, Args )
	if !Player:IsModerator() then return false; end
	
	if(!Player.SpecType) then Player.SpecType = OBS_MODE_CHASE end
	if(Player.SpecType == OBS_MODE_CHASE) then
		Player.SpecType = OBS_MODE_IN_EYE
	else
		Player.SpecType = OBS_MODE_CHASE
	end
	Player:Spectate(Player.SpecType)
end
concommand.Add('perp_a_cst', ChangeSpecType);

local function StopSpectate ( Player, Command, Args )
	if !Player:IsAdmin() then return false; end
	
	Player:GetTable().Spectating = nil;
	
	Player:Spectate(OBS_MODE_NONE);
	Player:UnSpectate();
	
	Player:KillSilent();
end
concommand.Add('perp_a_ss', StopSpectate);

local function blacklistPlayer ( Player, cmd, Args )
	if (!Player:IsAdmin()) then return; end
	if (!Args[1] || !Args[2]) then return; end
	
	local banTime = tonumber(Args[1]);
	local toBeBanned = Args[2];
	
	banTime = math.Clamp(banTime, 0, 720);
	
	local toBeBannedPlayer;
	for k, v in pairs(player.GetAll()) do
		if (v:UniqueID() == toBeBanned) then
			toBeBannedPlayer = v;
		end
	end
	if (!toBeBannedPlayer) then Player:Notify("Could not find that player."); return; end
	
	if (!GAMEMODE.teamToBlacklist[toBeBannedPlayer:Team()]) then
		Player:Notify("Missing blacklist conversion.");
	return; end
	
	if (Player:HasBlacklist(GAMEMODE.teamToBlacklist[toBeBannedPlayer:Team()])) then
		Player:Notify("They already have that blacklist!");
	return; end
	
	toBeBannedPlayer:GiveBlacklist(GAMEMODE.teamToBlacklist[toBeBannedPlayer:Team()], banTime);
	
	Player:Notify("Player blacklisted.");
	toBeBannedPlayer:Notify("You have been blacklisted by an admin.\n");
		
	if (toBeBannedPlayer:Team() == TEAM_POLICE) then
		GAMEMODE.Police_Leave(toBeBannedPlayer);
	elseif (toBeBannedPlayer:Team() == TEAM_MEDIC) then
		GAMEMODE.Medic_Leave(toBeBannedPlayer);
	elseif (toBeBannedPlayer:Team() == TEAM_FIREMAN) then
		GAMEMODE.Fireman_Leave(toBeBannedPlayer);
	elseif (toBeBannedPlayer:Team() == TEAM_SWAT) then
		GAMEMODE.Swat_Leave(toBeBannedPlayer);
	elseif (toBeBannedPlayer:Team() == TEAM_DISPATCHER) then
		GAMEMODE.Dispatcher_Leave(toBeBannedPlayer);
	elseif (toBeBannedPlayer:Team() == TEAM_SECRET_SERVICE) then
		GAMEMODE.Secret_Service_Leave(toBeBannedPlayer);
	elseif (toBeBannedPlayer:Team() == TEAM_BUSDRIVER) then
		GAMEMODE.BusDriver_Leave(toBeBannedPlayer);
	elseif (toBeBannedPlayer:Team() == TEAM_ROADSERVICE) then
		GAMEMODE.RoadServices_Leave(toBeBannedPlayer);
	elseif (toBeBannedPlayer:Team() == TEAM_MAYOR) then
		toBeBannedPlayer:SetModel(Player.PlayerModel);
		toBeBannedPlayer.JobModel = nil;
		toBeBannedPlayer:EquipMains();
		toBeBannedPlayer:SetTeam(TEAM_CITIZEN);
		
		for k, v in pairs(player.GetAll()) do
			if (v != Player && v != toBeBannedPlayer) then
				v:Notify("The mayor has been impeached!");
			end
		end
	else
		Player:Notify("Error demoting player.");
		return;
	end
end
concommand.Add("perp_a_bl", blacklistPlayer);

local function blacklistPlayer ( Player, cmd, Args )
	if (!Player:IsAdmin()) then return; end
	
	if (!GAMEMODE.IsSerious) then
		Player:Notify("This isn't serious RP.");
		return;
	end
	
	if (!Args[1] || !Args[2]) then return; end
	
	local banTime = tonumber(Args[1]);
	local toBeBanned = Args[2];
	
	banTime = math.Clamp(banTime, 0, 720);
	
	local toBeBannedPlayer;
	for k, v in pairs(player.GetAll()) do
		if (v:UniqueID() == toBeBanned) then
			toBeBannedPlayer = v;
		end
	end
	if (!toBeBannedPlayer) then Player:Notify("Could not find that player."); return; end
	
	if (Player:HasBlacklist('b')) then
		Player:Notify("They already have that blacklist!");
	return; end
	
	Player:Notify("Player blacklisted.");
	toBeBannedPlayer:GiveBlacklist('b', banTime);
end
concommand.Add("perp_a_bs", blacklistPlayer);

function GM.FreezeAll(Player, cmd, Args)
	if (!Player:IsSuperAdmin()) then return end
	
	for k,v in pairs(player.GetAll())do
		if (v:IsAdmin()) then
		else
		v:Freeze(true)
		
		end
		v:Notify("All Non-Administrators have been frozen for Administrative purposes.");
	end
end
concommand.Add("perp_a_fa", GM.FreezeAll)

function GM.UnFreezeAll(Player, cmd, Args)
	if (!Player:IsSuperAdmin()) then return end
	
	for k,v in pairs(player.GetAll()) do
		v:Freeze(false)
		v:Notify("Everyone has been unfrozen, please resume roleplay procedures.");
	end
end
concommand.Add("perp_a_ufa", GM.UnFreezeAll)

function GM.DisableOOC(Player, cmd, Args)
	if (!Player:IsSuperAdmin()) then return end
	
		GAMEMODE.AllowOOC = !GAMEMODE.AllowOOC
	
	for k,v in pairs(player.GetAll()) do
		if !GAMEMODE.AllowOOC then
			v:Notify("OOC Has been temporarily disabled to preserve order.");
		else
			v:Notify("OOC has been re-enabled. Please follow standard roleplay procedures.")
		end
	end
	
end
concommand.Add("perp_a_ooct", GM.DisableOOC)

function GM.Disguise(Player, cmd, Args)
	if (!Player:IsModerator()) then return end
	
	Player:SetSharedBool("disguise", !Player:GetSharedBool("disguise", false))
end
concommand.Add("perp_a_dis", GM.Disguise)

function GM.HideMe(Player, cmd, Args)
	if (!Player:IsSuperAdmin()) then return end
	
	Player:SetSharedBool("hidden", !Player:GetSharedBool("hidden", false))
end
concommand.Add("perp_a_hide", GM.HideMe)

function GM.ForceRename ( Player, cmd, Args )
	if (!Player:IsAdmin()) then return; end
	if (!Args[1]) then return; end
	
	local toBeBanned = Args[1];
		
	local toBeBannedPlayer;
	for k, v in pairs(player.GetAll()) do
		if (v:UniqueID() == toBeBanned) then
			toBeBannedPlayer = v;
		end
	end
	if (!toBeBannedPlayer) then Player:Notify("Could not find that player."); return; end
	//if (toBeBannedPlayer:IsSuperAdmin()) then Player:Notify("You cannot force that player to rename."); return; end
	
	Msg(Player:Nick() .. " forced " .. toBeBannedPlayer:Nick() .. " to rename.\n");
	
	DataBase:Query("INSERT INTO `perp_bname` (`name`) VALUES ('" .. tmysql.escape(toBeBannedPlayer:GetRPName()) .. "')");
	timer.Simple(2, function() GAMEMODE.GatherInvalidNames() end)
	toBeBannedPlayer:ForceRename();
end
concommand.Add("perp_a_fr", GM.ForceRename);

function PickupPlayersFunction( PLAYER, ENTITY )
	if PLAYER:IsAdmin() then
		if ENTITY:IsPlayer() then
			if ENTITY != PLAYER then
				if ENTITY:IsBetterOrSame(PLAYER) then
					return false
				end
			end
			ENTITY:Freeze(true)
			ENTITY:SetMoveType(MOVETYPE_NOCLIP)
			return true
		end
	end
end
hook.Add( "PhysgunPickup", "PhysgunPickup", PickupPlayersFunction )

function DropPlayersFunction(PLAYER, ENTITY)
	if ENTITY:IsPlayer() then
		ENTITY:SetMoveType(MOVETYPE_WALK)
		ENTITY:Freeze(false)
	end
end
hook.Add( "PhysgunDrop", "PhysgunDrop", DropPlayersFunction )

concommand.Add("perp_a_ostime", function()
	umsg.Start("gettime")
		umsg.Float(os.time())
	umsg.End()
end )

concommand.Add("perp_a_unblacklist", function(Player, cmd, args)
	if(!args[1] or !args[2]) then return end
	if(!Player:IsAdmin()) then return end
	local ply
	for k, v in pairs(player.GetAll()) do
		if(v:SteamID() == args[1]) then
			ply = v
		end
	end
	if !ply then return end
	ply:UnBlackList( args[2] )
	Player:Notify("Player Un-Blacklisted")
end )

concommand.Add("perp_a_getblacklists", function(Player, cmd, args)
	if(!Player:IsAdmin()) then return end
	for k, v in pairs(player.GetAll()) do
		umsg.Start("RecievePlayerBlacklists", Player)
			umsg.Entity(v)
			umsg.String(v:GetPrivateString("blacklists", ""))
		umsg.End()
	end
	umsg.Start("donerecievingblacklists", Player)
	umsg.End()
end )

hook.Add("PlayerSpawn", "ManageNLRSpawn", function(Player)
	if(!Player.DontFixCripple and Player.DeathPos) then
		Player.CanNLR = true
		Player.NLRIsDone = CurTime() + 240
		Player.NLRWarnings = 1
	end
end )

local deathzones = 	{				
					// City
					{"The Apartments", Vector(-10289.200195313, -9475.9443359375, -22.094026565552), Vector(-10845.213867188, -10343.647460938, 594.03564453125)},
					{"The Amber Room", Vector(-10289.865234375, -11077.399414063, 252.68455505371), Vector(-10730.173828125, -10340.83984375, 6.9577145576477)},
					{"The Skyscraper", Vector(-5522.0034, -8927.2266, 76.4222), Vector(-3625.9761, -9667.9365, 1864.1808)},
					{"The City Gas Station", Vector(-7972.2719726563, -5773.4350585938, 288.03125), Vector(-6328.5185546875, -6796.4150390625, -3.814564704895)},
					{"Burger King", Vector(-7142.0424804688, -5106.20703125, 368.20227050781), Vector(-7984.7504882813, -3760.4382324219, -28.513628005981)},
					{"The Tides Hotel", Vector(-5728.082031, -5165.652344, 86.945206), Vector(-3406.577637, -4109.761230, 329.761963)},
					{"The Fire Department", Vector(-3401.020752, -6940.677246, 314.737244), Vector(-3901.799316, -8598.751953, 208.903671)},
					//{"The Bank", Vector(-7874.0317382813, -7965.62890625, 292.35754394531), Vector(-6426.1313476563, -7432.943359375, -34.106967926025)},
					//{"The Nexus", Vector(-6346.0361328125, -8626.6884765625, 1.9766192436218), Vector(-7787.96875, -9722.3095703125, 4188.03125)},
					{"The General Store", Vector(-6959.735840, -10610.853516, 85.408897), Vector(-6462.360352, -9854.923828, 198.415985)},
					{"Izzie's Palace", Vector(-6686.904296875, -12797.375, -33.232597351074), Vector(-7589.5288085938, -14759.987304688, 481.73526000977)},
					{"The Park", Vector(-8555.524414, -11669.785156, 86.547623), Vector(-9559.138672, -8627.092773, 288.921631)},
					{"The Clothes Shop", Vector(-5432.330566, -5779.384766, 413.572510), Vector(-4855.898926, -6448.226074, 82.509483)},
					{"The Small Shop", Vector(-5068.813477, -7308.738281, 316.863708), Vector(-5432.423828, -6943.076172, 78.874893)},
					{"The Large Shop", Vector(-5427.433105, -7318.101563, 366.088806), Vector(-5097.693848, -7933.461426, 69.349411)},

					{"The Police Department", Vector(-7770.935059, -10634.707031, 2.742554), Vector(-6369.769531, -8889.467773, -431.816345)},
					{"The Police Department", Vector(-7792.899414, -8542.392578, 274.080231), Vector(-8111.017090, -10652.275391, -179.522827)},
					
					// Exchange
					{"the Junction Warehouse", Vector(-1825.3981, -361.7719, 288.7318), Vector(-4188.9131, 615.0000, 64.4348)},
					
					// Hospitol
					{"the Hospitol", Vector(-8301.739258, 8300.989258, 430.847687), Vector(-11404.297852, 10006.354492, 79.853905)},
					
					// Industrial Zone
					{"the MTL Complex", Vector(-3584.2277832031, 9155.0419921875, 789.73101806641), Vector(-428.931640625, 2692.7922363281, -100.97137451172)},
					{"the Power Plant", Vector(2869.1091, 4607.0313, 701.2580), Vector(4263.1411, 3595.0313, 64.4830)},
					
					// Sickness Road Area
					{"the Old Inn", Vector(-591.2158, -6685.8267, 188.9688), Vector(-1622.9688, -6014.3623, 62.3013)},
					
					// Lake Area
					{"Lake House #1", Vector(-5704.2461, 12495.9688, 362.6231), Vector(-6088.0313, 13134.4287, 188.8057)},
					{"Lake House #2", Vector(-6273.5640, 14439.9688, 363.3763), Vector(-5889.9688, 15076.9268, 187.7479)},

					//Suburbs
					{"Suburbs House #1", Vector(2986.9567871094, 10481.541015625, 402.93566894531), Vector(1398.1433105469, 12109.145507813, -52.877326965332)},
					{"Suburbs House #2", Vector(5560.884765625, 10435.5859375, 405.6481628418), Vector(3845.2705078125, 11738.953125, -27.468559265137)},
					{"Suburbs House #3", Vector(4482.4877929688, 12973.955078125, -60.461616516113), Vector(5791.912109375, 15110.65625, 251.2472076416)},
					{"Suburbs House #4", Vector(3802.2060546875, 12956.916015625, -96.190246582031), Vector(1350.6076660156, 15082.322265625, 334.10098266602)},
					{"Suburbs House #5", Vector(-3311.9968, 12255.0469, 313.4655), Vector(-3696.0313, 11743.8613, 181.2888)},
					{"Suburbs House #6", Vector(-4271.9688, 11743.7852, 316.2161), Vector(-4656.0313, 12254.5029, 186.7185)},
					{"The Country Houses", Vector(6787.2471, 2315.2063, -122.7637), Vector(10854.4180, 5289.4697, 959.4724)},					
				};
				
local function GetZone(pos)
	local lifeAlertZone;
	local pPos = pos
	
	for k, v in pairs(deathzones) do
		local minVec = Vector(math.Min(v[2].x, v[3].x), math.Min(v[2].y, v[3].y), math.Min(v[2].z, v[3].z));
		local maxVec = Vector(math.Max(v[2].x, v[3].x), math.Max(v[2].y, v[3].y), math.Max(v[2].z, v[3].z));
		
		if (pPos.x >= minVec.x && pPos.y >= minVec.y && pPos.z >= minVec.z && pPos.x <= maxVec.x && pPos.y <= maxVec.y && pPos.z <= maxVec.z) then
			lifeAlertZone = k
			break;
		end
	end
	
	if (!lifeAlertZone) then return -1 end
	
	return lifeAlertZone;
end

hook.Add("Think", "ManageNLR", function()
	for _, ply in pairs(player.GetAll()) do
		if(ply.CanNLR and GetZone(ply.DeathPos) != -1) then
			local plyzone = GetZone(ply:GetPos())
			local dzone = GetZone(ply.DeathPos)
			local zonename = deathzones[dzone][1] or "error"
			if(CurTime() < ply.NLRIsDone) then
				if(plyzone == dzone and plyzone != -1) then
					if((!ply.LastNLRWarn or CurTime() > ply.LastNLRWarn) and ply:Alive()) then
						ply:Notify("You are not allowed back to " .. zonename .. " for another " .. math.Round(ply.NLRIsDone - CurTime()) .. " seconds!")
						if(ply.NLRWarnings > 10 and !ply:IsAdmin()) then
							ply:TakeDamage( 5, ply, ply:GetActiveWeapon() )
						end
						for k, v in pairs(player.GetAll()) do
							if(v:IsModerator() and !ply:IsAdmin()) then
								v:ChatPrint(ply:Nick() .. " [" .. ply:GetRPName() .. "] is breaking the NLR at ".. zonename .. "! Warning #" .. ply.NLRWarnings)
							end
						end
						ply.NLRWarnings = ply.NLRWarnings + 1
						ply.LastNLRWarn = CurTime() + 5
					end
				end
			else
				ply.CanNLR = false
				ply:Notify("You can now go back to " .. zonename)
			end
		end
	end
end )

hook.Add( "PlayerSay", "Admin Stuff", function( ply, text, public )
	local text = string.lower(text)
	if(ply:IsAdmin()) then
        --@@@
        if string.sub( text, 1, 3 ) == "@@@" then
                for k,v in pairs( player.GetAll() ) do
                        if v and v:IsValid() then
                                v:PrintMessage( HUD_PRINTCENTER, string.Right( text, string.len( text ) -  3 ) )
                        end
                end
                return ""
        --@@
        elseif string.sub( text, 1, 2 ) == "@@" then
                for k,v in pairs( player.GetAll() ) do
                        if v and v:IsValid() then
                                v:ChatPrint( "(ADMIN) ".. string.Right( text, string.len(text) - 2 ) )
                        end
                end
                return ""
        end
	end
	if(string.sub(text, 1, 4) == "/nlr" or string.sub(text, 1, 4) == "!nlr") then
		if(ply.CanNLR and GetZone(ply.DeathPos) != -1) then
			local dzone = GetZone(ply.DeathPos)
			local zonename = deathzones[dzone][1] or "error"
			ply:Notify("You are not allowed back to " .. zonename .. " for another " .. math.Round(ply.NLRIsDone - CurTime()) .. " seconds!")
		else
			ply:Notify("You are not currently restricted by the NLR.")
		end
	end
end )