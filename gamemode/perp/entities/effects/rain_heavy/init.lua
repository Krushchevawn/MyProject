


function EFFECT:Init ( data )
	self.time = CurTime() + 1;
end

local function rainCollide ( particle, hitPos )
	particle:SetDieTime(0);
		
	local eData = EffectData();
	eData:SetOrigin(hitPos)
	util.Effect("rain_splash", eData);
end

function EFFECT:Emit ( )
	local Filter = LocalPlayer();
	local PredictSpeed = LocalPlayer():GetVelocity();
	
	if LocalPlayer():InVehicle() then
		Filter = {LocalPlayer(), LocalPlayer():GetVehicle()}
		PredictSpeed = LocalPlayer():GetVehicle():GetVelocity()
	end
	
	if math.Round(PredictSpeed:Length() / 17.6) > 20 then return false; end
	
	//local PredictSpeed = PredictSpeed;
	PredictSpeed = Vector(PredictSpeed.x, PredictSpeed.y, 0);

	local SpawnPos = GAMEMODE.GetWeatherSpawnPos(PredictSpeed, Filter);
	
	for i = 0, 600 do
		local a = math.random(9999)
		local b = math.random(1,180)
		local dist = math.random(256,1024)
		local X = math.sin(b) * math.sin(a) * dist
		local Y = math.sin(b) * math.cos(a) * dist
		local offset = Vector(X,Y,0)
		local spawnpos = SpawnPos + offset;
		
		local velocity = Vector(math.random(20,75), math.random(20,75), math.random(-1000,-400));
		spawnpos = spawnpos + Vector(velocity.x, velocity.y, 0);
		
		if (GetVectorTraceUp(spawnpos).HitSky) then
			local particle = GLOBAL_EMITTER:Add("perp2/rain/drop", spawnpos)
			
			if (particle) then
				particle:SetVelocity(velocity);
				particle:SetLifeTime(0);
				particle:SetDieTime(5);
				particle:SetStartAlpha(50);
				particle:SetEndAlpha(150);
				particle:SetStartLength(20);
				particle:SetEndLength(20);
				particle:SetStartSize(2);
				particle:SetEndSize(2);
				particle:SetAirResistance(0);
				particle:SetCollide(true);
				particle:SetColor(150, 150, 150, 255)
				
				particle:SetCollideCallback(rainCollide);
			end
		end
	end
end

function EFFECT:Think ( )
	if (self.time > CurTime()) then
		self:Emit();
	else
		return false;
	end
end

function EFFECT:Render ( )

end
