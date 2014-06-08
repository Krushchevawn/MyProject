
local PLUGIN = {}

PLUGIN.Name = "Extra Format Identifiers"
PLUGIN.Author = "Andy Vincent"
PLUGIN.Date = "08th September 2007"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2.3
PLUGIN.Gamemodes = {}

function PLUGIN.FormatText(TEXT)
	
	if (CLIENT) then
		
		TEXT = string.Replace(TEXT, "%fps%", string.format("%0.2f", 1 / FrameTime() ) )
		TEXT = string.Replace(TEXT, "%ping%", tostring(LocalPlayer():Ping()) )
		TEXT = string.Replace(TEXT, "%frags%", tostring(LocalPlayer():Frags()) )
		TEXT = string.Replace(TEXT, "%deaths%", tostring(LocalPlayer():Deaths()) )
		TEXT = string.Replace(TEXT, "%name%", LocalPlayer():Nick() )
		
	end
	if (SERVER) then
	
	end
	
	return TEXT
	

end

ASS_RegisterPlugin(PLUGIN)


