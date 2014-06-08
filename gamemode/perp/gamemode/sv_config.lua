
REGISTRATION_ADDR = "http://localhost/register.php?steamid="; // CHANGE THIS TO YOUR URL FOR REGISTER.PHP
CHANGE_PASSW_ADDR = "";

// EXPERIENCE VALUES
GM.ExperienceForCraft = 20;	
GM.ExperienceForWoordWorking = 50				// Experience given in the SKILL_CRAFTING skill when a new item is mixed.

GM.AllowOOC = true;

// Wut.
GM.JobEquips = {};
GM.JobPaydayInfo = {};
GM.DeadPlayers = {}

// Times
WARRENT_TIME = 60 * 5;

// Jail Info
GM.JailLocations = 		{
							Vector( -7318.3477, -9914.4063, -431.9688),
							Vector( -7318.6299, -10048.5869, -431.9688),
							Vector( -7327.2578, -10192.9951, -431.9688),
							Vector( -7327.9717, -10312.2988, -431.9688),
							Vector( -7629.8472, -10324.2354, -431.9688),
							Vector( -7635.9663, -10200.9092, -431.9688),
							Vector(-7641.3682, -10047.2168, -431.9688),
							Vector(-7635.6816, -9932.9297, -431.9688),
						}
					
GM.UnjailLocations = 	{
							Vector(-6809.7148, -9215.5254, -431.9688),
							Vector(-6874.8022, -9214.7490, -431.9688),
							Vector(-6874.8022, -9214.7490, -431.9688),
							Vector(-6941.9580, -9176.2529, -431.9688),
							Vector(-7029.1284, -9142.4082, -431.9688),
						}
						
GM.FuelVars =			{
							{'1', '4'},
							{'2', '2.25'},
							{'3', '2.5'},
							{'4', '2.75'},
							{'5', '2.75'},
							{'6', '4.5'},
							{'7', '5.5'},
							{'8', '2.75'},
							{'9', '4'},
							{'10', '3.75'},
							{'11', '6'},
							{'12', '4.25'},
							{'13', '5.5'},
							{'14', '4.5'},
							{'15', '3.5'},
							{'16', '4'},
							{'17', '4.25'},
							{'18', '3.75'},
							{'19', '5'},
							{'20', '5.25'},
							{'21', '5'}, --reserved
							{'22', '3'}, --reserved
							{'23', '3.75'}, --reserved
							{'24', '2.75'}, --reserved
							{'25', '4.25'}, --reserved
							{'26', '3'}, --reserved
							{'27', '3'}, --reserved
							{'28', '3'}, --reserved
							{'29', '3'}, --reserved
							{'31', '5'}, 
							{'32', '4.5'},
							{'33', '3.5'},
							{'34', '4'},
							{'35', '5'},
							{'36', '6'},
							{'37', '6.5'},
							{'38', '3'}, --reserved
							{'39', '3'}, --reserved
							{'40', '3'}, --reserved
							{'41', '3'}, --reserved
							{'42', '3'}, --reserved
							{'43', '3'}, --reserved
							{'44', '3'}, --reserved
							{'45', '3'}, --reserved
							{'46', '3'}, --reserved
							{'47', '3'}, --reserved
							{'48', '3'}, --reserved
							{'49', '3'}, --reserved
							{'50', '8'},	
							{'51', '4.5'},	
							{'52', '4.5'},	
							{'53', '4.5'},	
							{'54', '4.5'},
							{'57', '4.5'},
							{'58', '6'},
						}
						
GM.SpeedVars =			{	
							{'1', '11', '1'},
							{'10', '21', '2'},
							{'20', '31', '3'},
							{'30', '41', '4'},
							{'40', '51', '5'},
							{'50', '61', '6'},
							{'60', '91', '7'},
							{'90', '180', '8'},
						}
							
JAIL_TIME = 120
JAIL_TIME_WARRENTED = 60 * 4

GM.CopReward_Arrest = 75

// Max Props
MAX_PROPS_NORM = 20
MAX_PROPS_VIP = 30