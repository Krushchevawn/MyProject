
local PLUGIN = {}

PLUGIN.Name = "Killvvvv"
PLUGIN.Author = "Andy Vincent"
PLUGIN.Date = "10th August 2007"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2.3
PLUGIN.Gamemodes = { "PERP" } // only load this plugin for sandbox and it's derivatives

if (SERVER) then

	ASS_NewLogLevel("ASS_ACL_REVIVE")

	function PLUGIN.KillPlayer( PLAYER, CMD, ARGS )

		if (PLAYER:IsModerator()) then
			local TO_KILL = ASS_FindPlayer(ARGS[1])
			if (!TO_KILL) then
				ASS_MessagePlayer(PLAYER, "Player not found!\n")
				return
			end

			if (TO_KILL != PLAYER) then
				if (TO_KILL:IsBetterOrSame(PLAYER)) then

					// disallow!
					ASS_MessagePlayer(PLAYER, "Access denied! \"" .. TO_KILL:Nick() .. "\" has same or better access then you.")
					return
				end
			end
			
			if (ASS_RunPluginFunction( "AllowPlayerKill", true, PLAYER, TO_KILL )) then
				TO_KILL.REVIVEPOS = TO_KILL:GetPos()
				local theirUniqueID = TO_KILL:UniqueID()
				local toHeal	
				
				for k, v in pairs(player.GetAll()) do
					if (v:UniqueID() == theirUniqueID) then
						toHeal = v
					end
				end
				
				if (!toHeal) then return end
				if (toHeal:Alive()) then return end
				
				GAMEMODE.DeadPlayers[toHeal:UniqueID()] = nil
				toHeal.DontFixCripple = true
				toHeal:Spawn()
				toHeal:Notify("You have been revived by an admin.")
				//haxx
				for i=1, 4 do
					timer.Simple(i / 10, function()
						toHeal:SetPos(toHeal.DeathPos)
					end)
				end

				// Log the action. Note we're using the new log level we defined earlier.
				ASS_LogAction( PLAYER, ASS_ACL_REVIVE, "revived " .. ASS_FullNick(TO_KILL) )
				
			end
		else
			ASS_MessagePlayer( PLAYER, "Access Denied!\n")
		end
	end
	concommand.Add("ASS_RevivePlayer", PLUGIN.KillPlayer)
end

if (CLIENT) then
	function PLUGIN.KillPlayer(PLAYER)
		if (!PLAYER:IsValid()) then return end
		RunConsoleCommand( "ASS_RevivePlayer", PLAYER:UniqueID() )
	end
	
	function  PLUGIN.AddGamemodeMenu(DMENU)
		DMENU:AddSubMenu( "Revive", nil, function(NEWMENU) 
			ASS_PlayerMenu( NEWMENU, {"IncludeLocalPlayer", "IncludeAll"}, PLUGIN.KillPlayer )
		end )
	end
	
end
ASS_RegisterPlugin(PLUGIN)


