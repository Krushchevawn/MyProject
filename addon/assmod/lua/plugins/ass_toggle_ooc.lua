/////////////////////////////////////////
// © 2010-2020 D3luX - D3luX-Gaming    //
//    All rights reserved    		   //
/////////////////////////////////////////
// This material may not be  		   //
//   reproduced, displayed,  		   //
//  modified or distributed  		   //
// without the express prior 		   //
// written permission of the 		   //
//   the copyright holder.  		   //
//		D3luX-Gaming.com   			   //
/////////////////////////////////////////

local PLUGIN = {}

PLUGIN.Name = "Toggle OOC"
PLUGIN.Author = "D3luX"
PLUGIN.Date = "15th March 2011"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2.3
PLUGIN.Gamemodes = { "PERP" } // only load this plugin for sandbox and it's derivatives


if (CLIENT) then

	function PLUGIN.ToggleOOC()
	RunConsoleCommand('perp_a_ooct');
	end   
	
	
	function PLUGIN.AddGamemodeMenu(DMENU)			
		if LocalPlayer():IsSuperAdmin() then
			DMENU:AddOption( "Toggle OOC",  function(NEWMENU) PLUGIN.ToggleOOC() end )
		end
	end
	
end

ASS_RegisterPlugin(PLUGIN)