local matLight 		= Material( "sprites/light_ignorez" );
local PixelTable = { };
local SirenTable = { };

function GM.RenderLights( )
	
	local PixelID = 0;
	
	if ( GAMEMODE.CurrentTime == nil || NOON == nil) then return; end
	
	local percChange = 1;
	local percChange_Siren = 1;
	local PercentOf = 0;
	--local FPS = 1/FrameTime();
	
	if (GAMEMODE.CurrentTime > NOON) then
		// Past noon - look for sunset
		if (GAMEMODE.CurrentTime < DUSK_START) then
			percChange = .25;
			percChange_Siren = 0.5
		elseif (GAMEMODE.CurrentTime < DUSK_END) then
			PercentOf = (GAMEMODE.CurrentTime - DUSK_START) / (DUSK_END - DUSK_START);
			percChange = .25 + (.75 * PercentOf);
			percChange_Siren = .5 + (.5 * PercentOf);
		end
	else
		// Pre-noon - look for sunrise
		if (GAMEMODE.CurrentTime > DAWN_END) then
			percChange = .25;
			percChange_Siren = .5;
		elseif (GAMEMODE.CurrentTime > DAWN_START) then
			PercentOf = (GAMEMODE.CurrentTime - DAWN_START) / (DAWN_END - DAWN_START);
			percChange = 1 - (.75 * PercentOf);
			percChange_Siren = 1 - (.5 * PercentOf);
		end
	end
	
	render.SetMaterial( matLight );
	
	local decel = false;
	local Light = false;
	local InVehicle = LocalPlayer():InVehicle();
	local ActiveLight = 0;
	local cSpeed = 0.0;
	local truePos = Vector(0,0,0);
	local trueAng = Angle(0,0,0);
	local ViewNormal = Vector(0,0,0);
	local Distance = 0.0;
	local ViewDot = 0.0;
	local LightPos = Vector(0,0,0);
	local Visible = 0.0;
	local Size = 0;
	local Alpha = 0;
	local Col = Color(0,0,0,0);
	local CurLight = 0;
	local TempVec = Vector(0,0,0);
	local fov = LocalPlayer():GetFOV();
	local forward = LocalPlayer():EyeAngles():Forward();
	
	local LocalVehicle = nil;
	
	if ( LocalPlayer():InVehicle() ) then
		LocalVehicle = LocalPlayer():GetVehicle();
	end
	
	for _, Vehicle in pairs(ents.FindByClass("prop_vehicle_jeep")) do
	
		if ( !Vehicle.vehicleTable ) then
			Vehicle.vehicleTable = lookForVT(Vehicle);
			
			if ( !Vehicle.vehicleTable ) then
				continue;
			end
		end
		
		decel = false;
		
		if (LocalVehicle && LocalVehicle == Vehicle) then
			decel = LocalPlayer():KeyDown(IN_JUMP);
		end
		
		Vehicle.lastSpeed = Vehicle.lastSpeed or 0;
		cSpeed = Vehicle:GetVelocity():Length();
		
		if (cSpeed < Vehicle.lastSpeed - 2) then
			decel = true;
		end
		
		Vehicle.lastSpeed = cSpeed;
		
		if ( !Vehicle.sirenNoise && Vehicle.vehicleTable.SirenNoise ) then
			Vehicle.sirenNoise = CreateSound(Vehicle, Vehicle.vehicleTable.SirenNoise);
			Vehicle.sirenNoise_Duration = SoundDuration(Vehicle.vehicleTable.SirenNoise) * .98;
		end
		
		if ( !Vehicle.sirenNoise_Alt && Vehicle.vehicleTable.SirenNoise_Alt ) then
			Vehicle.sirenNoise_Alt = CreateSound(Vehicle, Vehicle.vehicleTable.SirenNoise_Alt);
			Vehicle.sirenNoise_Alt_Duration = SoundDuration(Vehicle.vehicleTable.SirenNoise_Alt) * .98;
		end
		
		Light = Vehicle:GetSharedBool("hl", false);
		ActiveLight = 0;
		--ActiveLight = Vehicle:GetSharedInt("fl", 0);
		
		if ( !Vehicle.vehicleTable.DF && Vehicle:GetSharedBool("slights", false)) then
		
			ActiveLight = 3;
			
			local shouldBeOn_C = math.sin(CurTime() * 5);
			if (shouldBeOn_C > .4 && shouldBeOn_C < .85) then
				ActiveLight = 1;
			elseif (shouldBeOn_C > -0.85 && shouldBeOn_C < -0.4) then
				ActiveLight = 2;
			end
		
			if (table.Count(Vehicle.vehicleTable.SirenColors) == 2) then
				curLight = 3;
				shouldBeOn_C = math.sin(CurTime() * 8);
				if (shouldBeOn_C > .4 && shouldBeOn_C < .85) then
					curLight = 1;
				elseif (shouldBeOn_C > -0.85 && shouldBeOn_C < -0.4) then
					curLight = 2;
				end
	
				if (curLight != 3) then
					truePos = Vehicle:LocalToWorld(Vehicle.vehicleTable.SirenColors[curLight][2] + Vector(0, 0, 5))
					ViewNormal = truePos - EyePos()
					Distance = ViewNormal:Length()
					
					if ( Distance > 5000 ) then continue end
					
					if ( !InVehicle && ViewNormal:Dot( forward ) < math.abs( math.cos( math.acos( Distance / math.sqrt( Distance * Distance + 16 * 16 ) ) + fov * ( math.pi / 180 ) ) ) ) then continue end
					
					trueAng = Angle(90, -90, 0) + Vehicle:GetAngles();
					ViewNormal:Normalize()
					LightNrm = trueAng:Up()
					ViewDot = ViewNormal:Dot( LightNrm )
					LightPos = truePos + ViewNormal * -6
						
					PixelID = PixelID + 1;
					if ( !PixelTable[PixelID] ) then
						PixelTable[PixelID] = util.GetPixelVisibleHandle();
					end
	
					Visible = util.PixelVisible(LightPos, 32, PixelTable[PixelID])
	
					if ( !Visible ) then continue end

					Size = math.Clamp(Distance * Visible * 2, 32, 256) * percChange
	
					Distance = math.Clamp(Distance, 32, 800);
					Alpha = math.Clamp(math.Clamp((1000 - Distance) * Visible, 0, 75) * percChange, 0, 255);
							
					TempVec = Vehicle.vehicleTable.SirenColors[curLight][1];
	
					render.DrawSprite(LightPos, Size, Size, Color(TempVec.r, TempVec.g, TempVec.b, Alpha), Visible)

					local dlight = DynamicLight( Vehicle:EntIndex() )
					if ( dlight ) then
						dlight.Pos = LightPos;
						dlight.r = TempVec.r
						dlight.g = TempVec.g
						dlight.b = TempVec.b
						dlight.Brightness = 5 * percChange
						dlight.Decay = 256
						dlight.Size = 512
						dlight.DieTime = CurTime() + 0.05
					end
				end
			else
				local numPhases = math.ceil(table.Count(Vehicle.vehicleTable.SirenColors) / 2)
				local timePerPhase = 0.7 / numPhases
	
				local curPhase = math.ceil((CurTime() - math.floor(CurTime())) / timePerPhase)
	
				if (curPhase > numPhases) then	
					curPhase = curPhase - numPhases
				end
	
				local lightStart = curPhase * 2

				for curLight = lightStart - 1, lightStart do
					if (Vehicle.vehicleTable.SirenColors[curLight]) then
						
						truePos = Vehicle:LocalToWorld(Vehicle.vehicleTable.SirenColors[curLight][2] + Vector(0, 0, 7))
						trueAng = Angle(90, -90, 0) + Vehicle:GetAngles();
	
						LightNrm = trueAng:Up()
						ViewNormal = truePos - EyePos()
						Distance = ViewNormal:Length()
						
						if ( Distance > 5000 ) then continue end
						
						if ( !InVehicle && ViewNormal:Dot( forward ) < math.abs( math.cos( math.acos( Distance / math.sqrt( Distance * Distance + 16 * 16 ) ) + fov * ( math.pi / 180 ) ) ) ) then continue end
						
						ViewNormal:Normalize()
						ViewDot = ViewNormal:Dot( LightNrm )
						LightPos = truePos + ViewNormal * -6
							
						PixelID = PixelID + 1;
						if ( !PixelTable[PixelID] ) then
							PixelTable[PixelID] = util.GetPixelVisibleHandle();
						end
	
						Visible = util.PixelVisible(LightPos, 16, PixelTable[PixelID])
	
						if ( !tobool(Visible) ) then continue end

						Size = math.Clamp( (Distance * Visible * 2) * percChange, 150, 256)
	
						Distance = math.Clamp(Distance, 32, 800);

						TempVec = Vehicle.vehicleTable.SirenColors[curLight][1];

						Alpha = math.Clamp(math.Clamp((1000 - Distance) * 2, 0, 255) * percChange, 0, 255);
						AlphaGlow = math.Clamp(math.Clamp((1000 - Distance) * Visible, 0, 75) * percChange, 0, 255);

						render.DrawSprite(LightPos, Size / 5, Size / 5, Color(TempVec.r, TempVec.g, TempVec.b, Alpha), Visible);
						render.DrawSprite(LightPos, Size / 2, Size / 2, Color(TempVec.r, TempVec.g, TempVec.b, AlphaGlow), Visible);


						local dlight = DynamicLight( 0)//Vehicle:EntIndex() )
						if ( dlight ) then
							dlight.Pos = LightPos;
							dlight.r = TempVec.r
							dlight.g = TempVec.g
							dlight.b = TempVec.b
							dlight.Brightness = 5 * percChange
							dlight.Decay = 256
							dlight.Size = 512
							dlight.DieTime = CurTime() + 0.05
							dlight.NoModel = true
						end
					end
				end
			end
		end

		// Turn Signals
		local turnsigs = {}
		for k,v in pairs(Vehicle.vehicleTable.TaillightPositions) do table.insert(turnsigs, v) end
		for k,v in pairs(Vehicle.vehicleTable.HeadlightPositions) do table.insert(turnsigs, v) end
		
		if ( table.Count(turnsigs) > 0 and math.fmod(math.Round(CurTime()), 2) == 0) then --blink
			for k, v in pairs(turnsigs) do
				if(v[1].x < 0) then
					if(!Vehicle:GetSharedBool("leftbl", false)) then continue end
					truePos = Vehicle:LocalToWorld(Vector(v[1].x - 6, v[1].y, v[1].z)) --Left Signals
				else
					if(!Vehicle:GetSharedBool("rightbl", false)) then continue end
					truePos = Vehicle:LocalToWorld(Vector(v[1].x + 6, v[1].y, v[1].z)) --Right Signals
				end
				ViewNormal = truePos - EyePos()
				Distance = ViewNormal:Length()
				
				if ( Distance > 5000 ) then continue end
				
				if ( !InVehicle && ViewNormal:Dot( forward ) < math.abs( math.cos( math.acos( Distance / math.sqrt( Distance * Distance + 16 * 16 ) ) + fov * ( math.pi / 180 ) ) ) ) then continue end
				
				trueAng =  Angle(0, v[2].y, v[2].r) - Angle(-90, 90, 0) + Vehicle:GetAngles();
				LightNrm = trueAng:Up()
				ViewNormal:Normalize()
				ViewDot = ViewNormal:Dot( LightNrm )
				LightPos = truePos + ViewNormal * 6

				if ( ViewDot >= 0 ) then
			
					PixelID = PixelID + 1;
					if ( !PixelTable[PixelID] ) then
						PixelTable[PixelID] = util.GetPixelVisibleHandle();
					end
			
					Visible = util.PixelVisible(LightPos, 16, PixelTable[PixelID])	
					if (!Visible) then continue; end
			
					Size = math.Clamp(Distance * Visible * ViewDot / 2, 64, 256) * percChange;
			
					Distance = math.Clamp(Distance, 32, 800);
					
					Alpha = math.Clamp((1000 - Distance) * Visible * ViewDot, 0, 100) * percChange;
			
					Col = Color(255, 220, 10, Alpha);
			
					render.DrawSprite(LightPos, Size, Size, Col, Visible * ViewDot)
					render.DrawSprite(LightPos, Size * 0.2, Size * 0.2, Col, Visible * ViewDot);
				end
			end
		end
		
		// Headlights
		if ( Vehicle.vehicleTable.HeadlightPositions && Light ) then
		
			for k, v in pairs(Vehicle.vehicleTable.HeadlightPositions) do
				if (ActiveLight == 0 || ActiveLight == k) then

					truePos = Vehicle:LocalToWorld(v[1]);
					ViewNormal = truePos - EyePos()
					Distance = ViewNormal:Length()
					
					if ( Distance > 5000 ) then continue end
					
					if ( !InVehicle && ViewNormal:Dot( forward ) < math.abs( math.cos( math.acos( Distance / math.sqrt( Distance * Distance + 16 * 16 ) ) + fov * ( math.pi / 180 ) ) ) ) then continue end
					
					trueAng = Angle(0, v[2].y, v[2].r) - Angle(-90, 90, 0) + Vehicle:GetAngles();
					ViewNormal:Normalize()
					ViewDot = ViewNormal:Dot( trueAng:Up() )
					LightPos = truePos + ViewNormal * -6

					if ( ViewDot >= 0 ) then
					
						PixelID = PixelID + 1;
						if ( !PixelTable[PixelID] ) then
							PixelTable[PixelID] = util.GetPixelVisibleHandle();
						end
				
						Visible = util.PixelVisible(LightPos, 16, PixelTable[PixelID]);
						if (!Visible) then continue; end
				
						Size = math.Clamp(Distance * Visible * ViewDot * 2, 100, 1024) * percChange;
				
						Distance = math.Clamp(Distance, 32, 800);
						Alpha = math.Clamp((1000 - Distance) * Visible * ViewDot, 0, 200) * percChange;
						TempVec = Vehicle:GetSharedVector("lightcolor", Vector(0,0,0));
						Col = Color(TempVec.x, TempVec.y, TempVec.z, Alpha);
				
						render.DrawSprite(LightPos, Size * 0.4, Size * 0.4, Col, Visible * ViewDot)
						render.DrawSprite(LightPos, Size * 0.4, Size * 0.4, Col, Visible * ViewDot);
					end
					
				end
			end
			
		end
				
		if ( Vehicle.vehicleTable.RequiredClass ) then 
			if (Vehicle:GetSharedBool("siren", false)) then
				if (Vehicle:GetSharedBool("siren_loud", false)) then
					if (Vehicle.LastSirenPlay) then
						Vehicle.sirenNoise:Stop();
						Vehicle.LastSirenPlay = nil;
					end
			
					if (!Vehicle.LastSirenPlay_Alt || Vehicle.LastSirenPlay_Alt <= CurTime()) then
						Vehicle.LastSirenPlay_Alt = CurTime() + Vehicle.sirenNoise_Alt_Duration;
						Vehicle.sirenNoise_Alt:Stop();
						Vehicle.sirenNoise_Alt:Play();
					end
				else
					if (Vehicle.LastSirenPlay_Alt) then
						Vehicle.sirenNoise_Alt:Stop();
						Vehicle.LastSirenPlay_Alt = nil;
					end
			
					if (!Vehicle.LastSirenPlay || Vehicle.LastSirenPlay <= CurTime()) then
						Vehicle.LastSirenPlay = CurTime() + Vehicle.sirenNoise_Duration;
						Vehicle.sirenNoise:Stop();
						Vehicle.sirenNoise:Play();
					end
				end
			elseif (Vehicle.LastSirenPlay) then
				Vehicle.sirenNoise:Stop();
				Vehicle.LastSirenPlay = nil;
			elseif (Vehicle.LastSirenPlay_Alt) then
				Vehicle.sirenNoise_Alt:Stop();
				Vehicle.LastSirenPlay_Alt = nil;
			end
		end
	end
end
hook.Add("PostDrawTranslucentRenderables", "GM.RenderLights", GM.RenderLights);
