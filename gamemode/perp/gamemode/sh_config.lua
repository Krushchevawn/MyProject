// Shared config
GM.Name = "VDRP"
GM.Author = "GENERIC"

WEBSERVER_ADDRESS = "www.GENERIC.net/perpfiles";

VALID_CHARACTERS 			= 	{"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", 
								"1", "2", "3", "4", "5", "6", "7", "8", "9", ".", ",", "-", "_", "=", "+", "0"};
VALID_NAME_CHARACTERS		=	{"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
								"-"};

URL_INVALID_RP_NAMES 		= 	"http://" .. WEBSERVER_ADDRESS .. "/invalid_names.txt";

EQUIP_WEAPON_MAIN 			= 1;
EQUIP_MAIN 					= 1;
EQUIP_WEAPON_SIDE 			= 2;
EQUIP_SIDE 					= 2;

INVENTORY_WIDTH 			= 13;
INVENTORY_HEIGHT 			= 6;

NORMAL_HORNS = 1337;

MAX_CASH = 100000;

local folder = GM.Folder
FOLDER_NAME = folder:gsub("gamemodes/", "")

HEADLIGHT_COLORS = {
						{Color(255, 255, 255, 1500), Color(255, 255, 255, 255), "White"},
						{Color(255, 255, 255, 2500), Color(255, 255, 255, 255), "Ultra Bright White"},
						{Color(255, 0, 0, 1500), Color(255, 0, 0, 255), "Red"},
						{Color(0, 255, 0, 1500), Color(0, 255, 0, 255), "Green"},
						{Color(127, 255, 0, 1500), Color(127, 255, 0, 255), "Lime Green"},
						{Color(0, 0, 255, 1500), Color(0, 0, 255, 255), "Blue"},
						{Color(95, 159, 160, 1500), Color(95, 159, 160, 255), "Blue #1"},
						{Color(152, 245, 255, 1500), Color(152, 245, 255, 255), "Blue #2"},
						{Color(100, 149, 237, 1500), Color(100, 149, 237, 255), "Blue #3"},
						{Color(16, 78, 139, 1500), Color(16, 78, 139, 255), "Blue #4"},
						{Color(0, 0, 128, 1500), Color(0, 0, 128, 255), "Navy Blue"},
						{Color(0, 255, 255, 1500), Color(0, 255, 255, 255), "Teal"},
						{Color(255, 255, 0, 1500), 	Color(255, 255, 0, 255), "Yellow"},
						{Color(255, 20, 147, 1500), Color(255, 20, 147, 255), "Pink"},
						{Color(255, 125, 0, 1500), Color(255, 125, 0, 255), "Orange"},
						{Color(255, 0, 255, 1500), Color(255, 0, 255, 255), "Violet"},
						{Color(255, 215, 0, 1500), 	Color(255, 215, 0, 255), "Gold"},
					};
										
UNDERGLOW_COLORS = {
						{Color(255, 255, 255, 1500), Color(255, 255, 255, 255), "White"},
						{Color(255, 255, 255, 2500), Color(255, 255, 255, 255), "Ultra Bright White"},
						{Color(255, 0, 0, 1500), Color(255, 0, 0, 255), "Red"},
						{Color(0, 255, 0, 1500), Color(0, 255, 0, 255), "Green"},
						{Color(127, 255, 0, 1500), Color(127, 255, 0, 255), "Lime Green"},
						{Color(0, 0, 255, 1500), Color(0, 0, 255, 255), "Blue"},
						{Color(95, 159, 160, 1500), Color(95, 159, 160, 255), "Blue #1"},
						{Color(152, 245, 255, 1500), Color(152, 245, 255, 255), "Blue #2"},
						{Color(100, 149, 237, 1500), Color(100, 149, 237, 255), "Blue #3"},
						{Color(16, 78, 139, 1500), Color(16, 78, 139, 255), "Blue #4"},
						{Color(0, 0, 128, 1500), Color(0, 0, 128, 255), "Navy Blue"},
						{Color(0, 255, 255, 1500), Color(0, 255, 255, 255), "Teal"},
						{Color(255, 255, 0, 1500), 	Color(255, 255, 0, 255), "Yellow"},
						{Color(255, 20, 147, 1500), Color(255, 20, 147, 255), "Pink"},
						{Color(255, 125, 0, 1500), Color(255, 125, 0, 255), "Orange"},
						{Color(255, 0, 255, 1500), Color(255, 0, 255, 255), "Violet"},
						{Color(255, 215, 0, 1500), 	Color(255, 215, 0, 255), "Gold"},
					};

GM.SprintDecay = .25;
if {GENE_STRENGTH, 0} then
	GM.FistDamage = 5;
elseif {GENE_STRENGTH, 1} then
	GM.FistDamage = 6;
elseif {GENE_STRENGTH, 2} then
	GM.FistDamage = 7;
elseif {GENE_STRENGTH, 3} then
	GM.FistDamage = 8;
elseif {GENE_STRENGTH, 4} then
	GM.FistDamage = 9;
elseif {GENE_STRENGTH, 5} then
	GM.FistDamage = 10;
end

// Weapon penetration data
PENETRATION_RIFLE = 8000;
PENETRATION_SMG = 7000;
PENETRATION_PISTOL = 6000;

// Ringtones
GM.Ringtones = 	{
					{"Digital Ring", "digital.mp3"},
					{"Old Phone Ring", "classic.mp3"},
					{"Doorbell", "doorbell.mp3"},
					{"Jam Jingle", "jam.mp3"},
					{"Raindrops", "raindrops.mp3"},
					{"Mysterious", "mysterious.mp3"},
					{"Close Encounters", "cencounters.mp3"},
					{"Drum 'N' Bass", "dnb.mp3", "IsVIP"},
					{"Garden Party", "garden_party.mp3", "IsVIP"},
					{"Tetris", "tetris.mp3", "IsVIP"},
					{"Mario", "mario.mp3", "IsVIP"},
					{"Voice Ring", "human.mp3", "IsVIP"},
					{"Dubstep", "dubstep.mp3", "IsVIP"},
					{"Bad Touch", "badtouch.mp3", "IsVIP"},
					{"DJ Smash", "djsmash.mp3", "IsVIP"},
					{"Infinity", "infinity.mp3", "IsVIP"},
					{"Let Go", "letgo.mp3", "IsVIP"},
					{"MilkShake", "yard.mp3", "IsVIP"},
					{"Ass", "Ass.mp3", "IsVIP"},
					{"Raving", "milkshake.mp3", "IsVIP"},
					{"Pendulum", "pendulum.mp3", "IsVIP"},
					{"Pjanno", "pjanno.mp3", "IsVIP"},
					{"Right Here", "righthere.mp3", "IsVIP"},
					{"Shut your Mouth", "shutyourmouth.mp3", "IsVIP"},
					{"Lights Off", "turnlightsoff.mp3", "IsVIP"},
					{"Gold Member", "gold.mp3", "IsGoldMember"},
					{"Britland Theme", "brit.mp3", "IsAdmin"},
					{"Santa Dub", "santa.mp3", "IsAdmin"}
				};


// Drugs
GM.CopReward_Shrooms = 50;

				
// Teams
TEAM_CITIZEN = 1;
TEAM_MAYOR = 2;
TEAM_POLICE = 3;
TEAM_MEDIC = 4;
TEAM_PARAMEDIC = 4;
TEAM_FIREMAN = 5;
TEAM_FIREMEN = 5;
TEAM_SWAT = 6;
TEAM_DISPATCHER = 7
TEAM_SECRET_SERVICE = 8
TEAM_ROADSERVICE = 9;
TEAM_BUSDRIVER = 10;

team.SetUp(TEAM_CITIZEN, "Citizen", Color(0, 255, 0, 255));
team.SetUp(TEAM_POLICE, "a Police Officer", Color(0, 0, 255, 255));
team.SetUp(TEAM_MAYOR, "The Mayor", Color(255, 0, 0, 255));
team.SetUp(TEAM_MEDIC, "a Paramedic", Color(255, 0, 255, 255));
team.SetUp(TEAM_FIREMAN, "a Fireman", Color(255, 165, 0, 255));
team.SetUp(TEAM_SWAT, "a SWAT Officer", Color(0, 0, 100, 255));
team.SetUp(TEAM_DISPATCHER, "a Police Operator", Color(0, 0, 200, 255));
team.SetUp(TEAM_SECRET_SERVICE, "a Secret Service Agent", Color(0, 0, 200, 255));
team.SetUp(TEAM_ROADSERVICE, "a Road Crew Worker", Color(255, 100, 0, 255));
team.SetUp(TEAM_BUSDRIVER, "a bus chauffeur", Color(120, 0, 255, 255));

// Blacklist Info
GM.teamToBlacklist = {};
GM.teamToBlacklist[TEAM_POLICE] = 'c';
GM.teamToBlacklist[TEAM_MAYOR] = 'd';
GM.teamToBlacklist[TEAM_MEDIC] = 'e';
GM.teamToBlacklist[TEAM_FIREMAN] = 'f';
GM.teamToBlacklist[TEAM_SWAT] = 'g';
GM.teamToBlacklist[TEAM_DISPATCHER] = 'h';
GM.teamToBlacklist[TEAM_SECRET_SERVICE] = 'i';
GM.teamToBlacklist[TEAM_ROADSERVICE] = 'j';
GM.teamToBlacklist[TEAM_BUSDRIVER] = 'k';

// Times
GM.RequiredTime_Cop = 5; // in hours
GM.RequiredTime_SecretService = 8;
GM.RequiredTime_SWAT = 24;
GM.RequiredTime_Fire = 2;
GM.RequiredTime_Paramedic = 1;
GM.RequiredTime_Dispatcher = 8;
GM.RequiredTime_RoadService = 4;
GM.RequiredTime_BusDriver = 24;

// Other

CAR_PAINT_RANGE = 750;
PHYSGUN_COLORPRICE = 5000

// Experience Values
GM.ExperienceForSprint = 1;					// Experience given every 5 ticks of stamina is taken.
GM.ExperienceForSwimming = 1;				// Experience for every 1 seconds swimming.
GM.ExperienceForDriving = 1;				// Experience for every 5 seconds driving.

// Drowning
GM.DrowningDamage = 10;
GM.DrowningDelay = 1;
GM.DrownTime = 8;

// Chat distances
ChatRadius_Whisper = 200;
ChatRadius_Local = 600;
ChatRadius_Yell = 800;

// Prices
GM.RenamePrice = 10000;
GM.FacialPrice = 5000;
GM.ClothesPrice = 1000;
GM.SexChangePrice = 20000;

COST_FOR_HYDRAULICS = 20000;
COST_FOR_UNDERGLOW = 20000;
COST_FOR_LOTTO = 5000

// Medic NPC
COST_FOR_HEALTHRESET = 500;
COST_FOR_LEGFIX = 1000;

GM.GeneResetPrice = 5000;
GM.NewGenePrice = 5000;

GM.MaxGenes = 10;
GM.MaxGenesReg = 10;
GM.MaxGoldGenes = 15;

GM.MaxTicketPrice = 200


// Radio
GM.RadioStations = 	{
						{'85.9 Dubstep Radio', 'http://46.4.79.69:6090/listen.pls'},
						{'89.7 D&B Central', 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=218503'},
						{'91.8 True R&B', 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=127014'},
						{'94.3 The Buzz', 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=37586'},
						{'95.9 ChroniX Metal', 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=558051'},
						{'96.5 HARD FM', 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=881390'},
						{'97.7 The Hitz', 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=1283896'},
						{'98.5 Trance', 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=35124'},
						{'102.1 Hot Jams', 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=32999'},
						{'102.8 Electro House', 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=4123'},						
						{'103.3 Classic Hits', 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=153501'},
						{"104.7 Kickin' Country", 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=1283687'},
						{"105.5 Smooth Jazz", 'http://www.sky.fm/mp3/smoothjazz.pls'},	
						{"107.2 Comedy Central", 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=212920'},
					    {"108.1 Hip Hop FM", 'http://yp.shoutcast.com/sbin/tunein-station.pls?id=190767'},
					};

// Mayor Stuffs					
GM.UpkeepCost_PoliceCar 	= 25
GM.UpkeepCost_Firetruck 	= 25
GM.UpkeepCost_SWATVan 		= 50
GM.UpkeepCost_Ambulance 	= 25
GM.UpkeepCost_Stretch 		= 50

GM.MaxPayDay_Police = 125
GM.MaxPayDay_SWAT = 150
GM.MaxPayDay_Paramedic = 125
GM.MaxPayDay_Fireman = 125
GM.MaxPayDay_Dispatcher = 150
GM.MaxPayDay_SecretService = 150
GM.MinimumPayGov = 50

GM.MaxVehicles_SWAT = 2
GM.MaxVehicles_Police = 5
GM.MaxVehicles_Medic = 5
GM.MaxVehicles_Fire = 5
GM.MaxVehicles_SecretService = 1

GM.MaxEmployment_Police = 10
GM.MaxEmployment_SWAT = 4
GM.MaxEmployment_Fire = 5
GM.MaxEmployment_Medic = 5
GM.MaxEmployment_SecretService = 2
GM.MaxEmployment_BusDriver = 1
GM.MaxEmployment_Tow = 2

GM.MaxTax_Sales = 50
GM.MaxTax_Income = 50

GM.MayorPay = 125
FREE_CASH_PER_PLAYER = 50

MAX_COCA = 5
MAX_POT = 5
POT_GROW_TIME = 600
COCA_GROW_TIME = 600

// Client config stuff
if SERVER then return; end

URL_RULES 					= 	"http://" .. WEBSERVER_ADDRESS .. "/rules.txt";
URL_CHAT 					= 	"http://" .. WEBSERVER_ADDRESS .. "/chat.txt";
URL_FAQ						=	"http://" .. WEBSERVER_ADDRESS .. "/faq.txt";
URL_LAWS						=	"http://" .. WEBSERVER_ADDRESS .. "/laws.txt";

GM.CurrentTime = 0
GM.ASS_HideNoticeBar = true