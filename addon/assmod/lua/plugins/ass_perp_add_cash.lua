
local PLUGIN = {}

PLUGIN.Name = "Reset Skills"
PLUGIN.Author = "HuntsKikBut"
PLUGIN.Date = "21st September 2007"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2.3
PLUGIN.Gamemodes = { "PERP" } // only load this plugin for sandbox and it's derivatives

local POWER_TABLE = {
	
	{	Name = "1,000,000",	Cash = 1000000	},
	{	Name = "100,000",	Cash = 100000	},
	{	Name = "10,000",	Cash = 10000	},
	{	Name = "1,000",	Cash = 1000	},
	{	Name = "100",	Cash = 100	},
	{	Name = "10",	Cash = 10	},
	{	Name = "-10",	Cash = -10	},
	{	Name = "-100",	Cash = -100	},
	{	Name = "-1,000",	Cash = -1000	},
	{	Name = "-10,000",	Cash = -10000	},
	{	Name = "-100,000",	Cash = -100000	},
	{	Name = "-1,000,000",	Cash = -1000000	},

	
}

if (SERVER) then
	ASS_NewLogLevel("ASS_ACL_PERP_GIVECASH")
	
	if !file.Exists('cashlog.txt', "DATA") then file.Write('cashlog.txt', ''); end

	function PLUGIN.GrantCash(PLAYER, CMD, ARGS)

		if (PLAYER:IsOwner()) then
		
			if (ARGS[1]) and (ARGS[2]) then

				local TO_CLEAN = ASS_FindPlayer(ARGS[1])

				if (!TO_CLEAN) then
					ASS_MessagePlayer(PLAYER, "Player not found!\n")
					return

				end
				
				TO_CLEAN:AddCash(tonumber(ARGS[2]));
				ASS_LogAction( PLAYER, ASS_ACL_PERP_GIVECASH, "granted $" .. ARGS[2] .. " to " .. ASS_FullNick(TO_CLEAN) )
				file.Write('cashlog.txt', file.Read('cashlog.txt') .. PLAYER:Nick() .. ' -> ' .. TO_CLEAN:Nick() .. ' $' .. ARGS[2] .. '\n');
			else
			
				ASS_MessagePlayer(PLAYER, "Player not found!\n")
			
			end

		else

			// Player doesn't have enough access.
			ASS_MessagePlayer( PLAYER, "Access Denied!\n")

		end
	end
	concommand.Add("ASS_GrantCash", PLUGIN.GrantCash)
	
end

if (CLIENT) then


	function PLUGIN.GiveCash(PLAYER, CASH)
		if (type(PLAYER) == "table") then
			for _, ITEM in pairs(PLAYER) do
				if (ValidEntity(ITEM)) then
					RunConsoleCommand( "ASS_GrantCash", ITEM:UniqueID(), CASH )
				end
			end
		else
			if (!PLAYER:IsValid()) then return end
			RunConsoleCommand( "ASS_GrantCash", PLAYER:UniqueID(), CASH )
		end
	end

	
	function PLUGIN.SlapPower(MENU, PLAYER)

		for k,v in pairs(POWER_TABLE) do
			MENU:AddOption( v.Name,	function() return PLUGIN.GiveCash(PLAYER, v.Cash) end )
		end

	end

	function PLUGIN.AddGamemodeMenu(DMENU)			
		if LocalPlayer():GetLevel() < 1 then
		DMENU:AddSubMenu( "Give Cash", nil, 
			function(NEWMENU)
				ASS_PlayerMenu(NEWMENU, {"IncludeAll", "HasSubMenu", "IncludeLocalPlayer"}, PLUGIN.SlapPower);
			end )
		end
	end
	
end

ASS_RegisterPlugin(PLUGIN)
