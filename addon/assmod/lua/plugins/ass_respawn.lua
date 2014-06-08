
local PLUGIN = {}

PLUGIN.Name = "Respawn"				// plugin name
PLUGIN.Author = "Andy Vincent"			// author
PLUGIN.Date = "10th August 2007"		// date of creation / modification
PLUGIN.Filename = PLUGIN_FILENAME		// filename of the plugin
PLUGIN.ClientSide = true			// allow to be loaded clientside
PLUGIN.ServerSide = true			// allow to be loaded serverside
PLUGIN.APIVersion = 2				// API Version
PLUGIN.Gamemodes = {}				// list of gamemodes that this plugin can be used with. If this
						// is empty, all gamemodes are allowed.

if (SERVER) then

	// Define a new log type. This is only needed if you decied to log the actions of the user.
	ASS_NewLogLevel("ASS_ACL_RESPAWN")

	function PLUGIN.RespawnPlayer( PLAYER, CMD, ARGS )

		// Simple check: Is the player a temporary admin or above?
		if (PLAYER:IsModerator()) then

			// Find the player we want to kill. The first argument is the UniqueID
			local TO_KILL = ASS_FindPlayer(ARGS[1])

			// Couldn't find the player, abort with a message.
			if (!TO_KILL) then

				ASS_MessagePlayer(PLAYER, "Player not found!\n")
				return

			end

			// The user should be able to kill themselves. If the user and the player
			// specified aren't the same, then check their levels. If the player to be 
			// killed is of higher rank (or the same), then deny it.
			if (TO_KILL != PLAYER) then
				if (TO_KILL:IsBetterOrSame(PLAYER)) then

					// disallow!
					ASS_MessagePlayer(PLAYER, "Access denied! \"" .. TO_KILL:Nick() .. "\" has same or better access then you.")
					return
				end
			end

			// Plugins can also define new plugin callbacks. In this case we check if
			// any plugins implement the AllowPlayerKill callback, which can stop the 
			// kill from taking place.
			
			if (ASS_RunPluginFunction( "AllowPlayerKill", true, PLAYER, TO_KILL )) then

				// Actually kill the player
				TO_KILL:Kill()
				timer.Simple(0.2, function()
					TO_KILL:Spawn()
				end )

				// Log the action. Note we're using the new log level we defined earlier.
				ASS_LogAction( PLAYER, ASS_ACL_RESPAWN, "respawned " .. ASS_FullNick(TO_KILL) )
					
			end


		else

			// Player doesn't have enough access.
			ASS_MessagePlayer( PLAYER, "Access Denied!\n")

		end

	end
	concommand.Add("ASS_RespawnPlayer", PLUGIN.RespawnPlayer)

end

if (CLIENT) then

	// KillPlayer, called from the ASS_PlayerMenu function.
	function PLUGIN.RespawnPlayer(PLAYER)

		// Pretty simple. All we do is fire off a console command.
		
		if (!PLAYER:IsValid()) then return end

		RunConsoleCommand( "ASS_RespawnPlayer", PLAYER:UniqueID() )
		
		// Returning true at this point would force the menu to stay open,
		// thus allowing the user to re-click then menu item.

	end
	
	function PLUGIN.BuildMenu(NEWMENU)
		
		// ASS_PlayerMenu fills the menu with a list of the players names
		// The first parameter is the menu to fill, the second is a list of options:
		//	"IncludeLocalPlayer"	->	the client is included in the list
		//	"HasSubMenu"		->	the function in the 3rd parameter is
		//					the build menu function, not the on-click
		//					function.
		//	"IncludeAll"		->	if you're the server owner, you get a 3 
		//					menu choice to choose between groups
		//					"all players, "all admins", "all non admins".
		//					if you're not the server owner you get 
		//					"all non admins".
		//	"IncludeAllSO"		->	same as above, but you get the 3 group options
		//					(not dependent on what admin type you are).
		//	Note: If HasSubMenu and one of the IncludeAll flags are both set, then the
		//		"player" parameter of the call back function will actually be a table
		//		of players to act upon.
		
		ASS_PlayerMenu( NEWMENU, {"IncludeLocalPlayer", "IncludeAll"}, PLUGIN.RespawnPlayer  ) 
	end
	
	// AddMenu, the main callback. This is used to add menu items under the "Plugins" heading
	// of the main menu.
	function PLUGIN.AddMenu(DMENU)			

		// Add the Kill option to the menu. The first paramter is the text that appears
		// on the menu item, the second is the function to call when the item is clicked,
		// the third is the function that will build a new menu when the item is hovered
		// over (to create a sub menu).
		
		DMENU:AddSubMenu( "Respawn" , nil, PLUGIN.BuildMenu)

	end

end

// Lastly register the plugin. This will ensure the plugin is loaded, and sent to the 
// player if necessary.
ASS_RegisterPlugin(PLUGIN)


