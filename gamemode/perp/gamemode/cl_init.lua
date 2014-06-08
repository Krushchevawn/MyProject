
// Include the shared init file.
include("sh_init.lua");

// Include the client files.
include("cl_networking.lua");
include("cl_hooks.lua");
include("cl_items.lua");
include("cl_player.lua");
include("cl_misc.lua");
include("cl_chat.lua");
include("cl_vehicles.lua");
include("cl_trade.lua");     
include("cl_scoreboards.lua");

// Fonts
surface.CreateFont("perp2_IntroTextBig", {
	size = ScaleToWideScreen(70), 
	weight = 100, 
	antialias = true,
	shadow = false, 
	font = "coalition"
})
surface.CreateFont("perp2_IntroTextSmall", {
	size = ScaleToWideScreen(15), 
	weight = 100, 
	antialias = true,
	shadow = false, 
	font = "coalition"
})
surface.CreateFont("perp2_TextHUDBig", {
	size = ScaleToWideScreen(16), 
	weight = 100, 
	antialias = true,
	shadow = false, 
	font = "coalition"
})
surface.CreateFont("perp2_TextHUDSmall", {
	size = ScaleToWideScreen(12), 
	weight = 100, 
	antialias = true,
	shadow = false, 
	font = "coalition"
})
surface.CreateFont("perp2_RealtorFontNew", {
	size = ScaleToWideScreen(24), 
	weight = 100, 
	antialias = true,
	shadow = false, 
	font = "coalition"
})
surface.CreateFont("perp3_HeaderFontLarge", {
	size = ScaleToWideScreen(32), 
	weight = 100, 
	antialias = true,
	shadow = false, 
	font = "coalition"
})
surface.CreateFont("HUDFont", {
	size = ScaleToWideScreen(12), 
	weight = 100, 
	antialias = true,
	shadow = false, 
	font = "coalition"
})
surface.CreateFont("Trebuchet18", {
	size = 18,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "Trebuchet MS"
})
surface.CreateFont("Trebuchet19", {
	size = 19,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "Trebuchet MS"
})
surface.CreateFont("Trebuchet20", {
	size = 20,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "Trebuchet MS"
})
surface.CreateFont("Trebuchet22", {
	size = 22,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "Trebuchet MS"
})
surface.CreateFont("Trebuchet24", {
	size = 24,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "Trebuchet MS"
})
surface.CreateFont("TabLarge", {
	size = 17,
	weight = 700,
	antialias = true,
	shadow = false,
	font = "Trebuchet MS"
})
surface.CreateFont("UiBold", {
	size = 16,
	weight = 800,
	antialias = true,
	shadow = false,
	font = "Default"
})
surface.CreateFont("ScoreboardHeader", {
	size = 32,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "coolvetica"
})
surface.CreateFont("ScoreboardSubtitle", {
	size = 22,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "coolvetica"
})
surface.CreateFont("ScoreboardPlayerName", {
	size = 19,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "coolvetica"
})
surface.CreateFont("ScoreboardPlayerName2", {
	size = 15,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "coolvetica"
})
surface.CreateFont("ScoreboardPlayerNameBig", {
	size = 22,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "coolvetica"
})
surface.CreateFont("consoletext", {
	size = 14,
	weight = 100,
	antialias = true,
	shadow = false,
	font = "default"
})
surface.CreateFont("ScoreboardText", {
	size = 13,
	weight = 300,
	antialias = true,
	shadow = false,
	font = "coolvetica"
})

for k, v in pairs(file.Find("PERP/gamemode/cl_modules/*.lua", "LUA")) do include("cl_modules/" .. v); end
for k, v in pairs(file.Find("PERP/gamemode/vgui/*.lua", "LUA")) do include("vgui/" .. v); end