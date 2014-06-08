
local PLUGIN = {}

PLUGIN.Name = "Reset Skillsdf"
PLUGIN.Author = "HuntsKikBut"
PLUGIN.Date = "21st September 2007"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2.3
PLUGIN.Gamemodes = { "PERP" } // only load this plugin for sandbox and it's derivatives

if SERVER then

	local function SetSpectate ( Player, Command, Args )
		if !Player:IsModerator() then return false; end
		
		local TargetPlayer = ASS_FindPlayer(Args[1]);

		if !TargetPlayer then return false; end
		
		Player:GetTable().Spectating = TargetPlayer;
		
		Player:Spectate(OBS_MODE_CHASE)
		Player:SpectateEntity(TargetPlayer) 
	end
	concommand.Add('perp_spectate', SetSpectate);
	
	local function StopSpectate ( Player, Command, Args )
		if !Player:IsModerator() then return false; end
		
		Player:GetTable().Spectating = nil;
		
		Player:Spectate(OBS_MODE_NONE);
		Player:UnSpectate();
		
		Player:KillSilent();
	end
	concommand.Add('perp_spectate_stop', StopSpectate);

elseif CLIENT then

	function PLUGIN.DoBlacklist(PLAYER)
		
		PERP_SpectatingEntity = PLAYER;
		RunConsoleCommand('perp_spectate', PLAYER:UniqueID())

	end
	
	
	function PLUGIN.AddGamemodeMenu(DMENU)			
	
		DMENU:AddSubMenu( "Spectate",   nil, function(NEWMENU) ASS_PlayerMenu( NEWMENU, {"IncludeLocalPlayer"}, PLUGIN.DoBlacklist ) end ):SetImage( "gui/silkicons/status_offline" )
		DMENU:AddOption( "Un-Spectate",  function(NEWMENU) RunConsoleCommand('perp_spectate_stop'); PERP_SpectatingEntity = nil; end ):SetImage( "gui/silkicons/status_offline" )

	end

end

ASS_RegisterPlugin(PLUGIN)
