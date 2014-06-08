TIME_PER_DAY 	= 60 * 60// * 3.5; // 1 hour is one cycle.
DAY_LENGTH		= 360;

DAY_START		= 5 * 60; // 5 am
DAY_END		= 18.5 * 60; // 6:30 pm
DAWN			= DAY_LENGTH / 4;
DAWN_START	= DAWN - 144;
DAWN_END		= DAWN + 144;
NOON			= DAY_LENGTH / 2;
DUSK			= DAY_LENGTH - DAWN;
DUSK_START	= DUSK - 144;
DUSK_END		= DUSK + 144;

local nextTick = CurTime();
local timePerMinute = TIME_PER_DAY / DAY_LENGTH * .5;
MONTH_DAYS = {31, 28, 30, 31, 30, 31, 30, 31, 30, 31, 30, 31};
CLOUD_NAMES = {"Clear Skies", "Partly Cloudy", "Mostly Cloudy [ PRE ]", "Mostly Clouy [ POST ]", "Stormy", "Stormy [ LIGHT ]", "Stormy [ PRE ]", "Stormy [ SEVERE ]", "Heat Wave"};
							 

local function manageTime ( )
	if (!GAMEMODE.CurrentTime || (SERVER && !GAMEMODE.timeEntities.shadow_control) || nextTick > CurTime()) then return; end
	if ( CLIENT and (!GAMEMODE.CurrentTime or !GAMEMODE.CurrentMonth  or !GAMEMODE.CurrentYear)) then return end
	nextTick = nextTick + timePerMinute;
	
	GAMEMODE.CurrentTime = GAMEMODE.CurrentTime + .5;
	if (GAMEMODE.CurrentTime > DAY_LENGTH) then
		GAMEMODE.CurrentTime = .5;
		
		GAMEMODE.CurrentDay = GAMEMODE.CurrentDay + 1;
		
		if ((MONTH_DAYS[GAMEMODE.CurrentMonth] and GAMEMODE.CurrentDay > MONTH_DAYS[GAMEMODE.CurrentMonth]) or GAMEMODE.CurrentDay > 30) then
			GAMEMODE.CurrentDay = 1;
			GAMEMODE.CurrentMonth = GAMEMODE.CurrentMonth + 1;
			
			if (GAMEMODE.CurrentMonth > 12) then
				GAMEMODE.CurrentMonth = 1;
				GAMEMODE.CurrentYear = GAMEMODE.CurrentYear + 1;
				// Happy near years
			end
		end
		
		if SERVER then GAMEMODE.SaveDate(); end
	end
		
	if SERVER then GAMEMODE.progressTime(); end
end
hook.Add("Think", "manageTime", manageTime);

function GM.GetTime ( )
	local perHour = DAY_LENGTH / 24;
	local perMinute = DAY_LENGTH / 1440;
	
	local hours = math.floor(GAMEMODE.CurrentTime / perHour);
	local mins = math.floor(GAMEMODE.CurrentTime / perMinute) - hours * 60;
	
	return hours, mins;
end

if(SERVER) then
	function GM.SendTime( Player )
		umsg.Start( 'SendTheTime', Player )
			umsg.Short( GAMEMODE.CurrentTime )
			umsg.Short( GAMEMODE.CurrentDay )
			umsg.Short( GAMEMODE.CurrentDay )
			umsg.Short( GAMEMODE.CurrentDay )
		umsg.End()
	end
else

	usermessage.Hook("SendTheTime", function( um )
		//print("Recieving the current time...")
		GAMEMODE.CurrentTime = um:ReadShort()
		GAMEMODE.CurrentDay = um:ReadShort()
		GAMEMODE.CurrentDay = um:ReadShort()
		GAMEMODE.CurrentDay = um:ReadShort()
	end )
	
end