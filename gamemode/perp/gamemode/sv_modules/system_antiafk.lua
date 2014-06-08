


local keysToMonitor = 	{
							IN_ATTACK,
							IN_DUCK,
							IN_FORWARD,
							IN_BACK,
							IN_USE,
							IN_CANCEL,
							IN_LEFT,
							IN_RIGHT,
							IN_MOVELEFT,
							IN_MOVERIGHT,
							IN_ATTACK2,
							IN_RUN,
							IN_RELOAD,
							IN_ALT1,
							IN_ALT2,
							IN_SCORE,
							IN_SPEED,
							IN_WALK,
							IN_ZOOM,
							IN_WEAPON1,
							IN_WEAPON2,
						};

local function doAntiAFK ( Player )
	Player.lastAction = Player.lastAction or CurTime();
	
	for k, v in pairs(keysToMonitor) do
		local keyDown = Player:KeyDown(v);
		local keyDownLast = Player:KeyDownLast(v);
		
		if (keyDown && !keyDownLast) then
			Player.lastAction = CurTime();
		elseif (!keyDown && keyDownLast) then
			Player.lastAction = CurTime();
		end
	end
	
	Player.nextDistanceCheck = Player.nextDistanceCheck or CurTime();
	if (CurTime() >= Player.nextDistanceCheck) then
		Player.lastPos = Player.lastPos or Player:GetPos();
		
		Player.nextDistanceCheck = CurTime() + 20;
		
		if (Player.lastPos:Distance(Player:GetPos()) > 150) then
			Player.lastAction = CurTime();
		end
		
		Player.lastPos = Player:GetPos();
	end
	
	local timeSince = CurTime() - Player.lastAction;
	if (!Player.isAFK && timeSince > 600) then
		Player.isAFK = true
		Msg(Player:Nick() .. " [ " .. Player:GetRPName() .. " ] is AFK.\n");
		
		if (!Player:IsAdmin()) then
			Player:Kick("AFK");
		else
			Msg("Not kicking because of administrator status.\n");
		end
	elseif (Player.isAFK && timeSince <= 300) then
		Msg(Player:Nick() .. " [ " .. Player:GetRPName() .. " ] is no longer AFK.\n");
		Player.isAFK = nil;
	end
end

local function AntiAFKMainTimer ( )
	for k, v in pairs(player.GetAll()) do
		doAntiAFK(v);
	end
end
hook.Add("Think", "AntiAFKMainTimer", AntiAFKMainTimer);