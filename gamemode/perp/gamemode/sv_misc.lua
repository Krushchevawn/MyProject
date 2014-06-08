
local function ManageSprint ( )
	for k, v in pairs(player.GetAll()) do
		v:CalculateStaminaLoss();
	end
end
hook.Add("Think", "ManageSprint", ManageSprint);

local function ManageHealthRegeneration ( )
	for k, v in pairs(player.GetAll()) do
		v:CalculateRegeneration();
	end
end
timer.Create("ManageHealthRegeneration", 1, 0, function() ManageHealthRegeneration() end)

function ExplodeInit ( pos, damage_dealer )
	umsg.Start('perp_bomb');
		umsg.Vector(pos);
	umsg.End();

	if (damage_dealer && IsValid(damage_dealer) && damage_dealer:IsPlayer()) then
		for i = 1, 5 do
			util.BlastDamage(damage_dealer, damage_dealer, pos, 300, 300 )
		end
	else
		for i = 1, 5 do
			util.BlastDamage(Entity(), Entity, pos, 300, 300 )
		end
	end
	
	for k, v in pairs(ents.FindInSphere(pos, 1000)) do
		if v:GetClass() == 'prop_vehicle_jeep' and !v:GetTable().Disabled and (!v:GetDriver() or !v:GetDriver():IsValid() or !v:GetDriver():IsPlayer()) then
			umsg.Start('perp_car_alarm');
				umsg.Entity(v);
			umsg.End();
		end
	end
	
	for i = 1, 5 do
		local Offset = Vector(math.random(-50, 50), math.random(-50, 50), 0);
			
		local Trace = {};
			Trace.start = pos + Offset + Vector(0, 0, 32);
			Trace.endpos = pos + Offset - Vector(0, 0, 1000);
			Trace.mask = MASK_SOLID_BRUSHONLY;
		local TR = util.TraceLine(Trace);
				
		if TR.Hit then					
			local Fire = ents.Create('ent_fire');
				Fire:SetPos(TR.HitPos);
			Fire:Spawn();
		end
	end
end

function GM.SetDate ( )
	local curDate = os.date("%m.%d")
	
	if (GetSharedString("os.date", "") != curDate) then
		SetSharedString("os.date", curDate)
	end
end
timer.Create("perp2_setdate", 60, 0, function() GAMEMODE.SetDate() end)
GM.SetDate()

function SetDropPos ( Player )
	//if !game.SinglePlayer() then return false; end
	if !Player:IsSuperAdmin() then return false; end
	
	local P = Player:GetEyeTrace().HitPos + Vector(0, 0, 16);
	local WriteText = "Vector(" .. P.x .. ", " .. P.y .. ", " .. P.z .. "), \n";
	
	if !file.Exists('zombspawn.txt') then
		file.Write('zombspawn.txt', WriteText);
	else
		file.Write('zombspawn.txt', file.Read('zombspawn.txt') .. WriteText);
	end
	
	local Marker = ents.Create('prop_physics');
	Marker:SetPos(P);
	Marker:SetModel('models/error.mdl');
	Marker:Spawn();
	Marker:SetMoveType(MOVETYPE_NONE);
	Marker:SetSolid(SOLID_NONE);
end
concommand.Add('perp3_zombiehere', SetDropPos);

function NexusTop ( )
	for k, ply in pairs(ents.FindInSphere(Vector(-7267.128418, -9195.308594, 4400), 400)) do
		if ply:IsValid() and ply:IsPlayer() then
			if ply:IsAdmin() then
				return;
			else
				ply:Kick("Autokick -- Exploiting");
			end;
		end
	end
	
	for k, ply in pairs(ents.FindInSphere(Vector(-6745.465820, -8667.694336, 4400.609863), 400)) do
		if ply:IsValid() and ply:IsPlayer() then
			if ply:IsAdmin() then
				return;
			else
				ply:Kick("Autokick -- Exploiting");
			end;
		end
	end
	
	for k, ply in pairs(ents.FindInSphere(Vector(-6508.780273, -9406.659180, 4400.420410), 400)) do
		if ply:IsValid() and ply:IsPlayer() then
			if ply:IsAdmin() then
				return;
			else
				ply:Kick("Autokick -- Exploiting");
			end;
		end
	end
end;
timer.Create("NexusTopCheck", 10, 0, function() NexusTop() end)