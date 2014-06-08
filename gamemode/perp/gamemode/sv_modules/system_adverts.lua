GM.Adverts = {
	"Thanks for playing on Virtual Domination Roleplay!",
	"Please make sure and read the rules by hitting F1.",
	"Need help starting out? Hit F1 and read the FAQ or check out our forums at GENERIC.net",
	"We are always updating and changing things in the server, do not be alarmed if something is different or not working correctly.",
	"Wanna buy some lottery tickets? Go talk to the convenience store clerk to buy tickets!",
	"Drop money in the world by typing /drop <amount>",
	"Want to pimp your physgun? Go color it at the clothes store! (GOLD Members Only)",
}
local pos = 1

timer.Create(	"AdvertTimer", 300, 0, function()
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint(GAMEMODE.Adverts[pos])
	end
	pos = pos + 1
	if(pos > #GAMEMODE.Adverts) then
		pos = 1
	end
end )