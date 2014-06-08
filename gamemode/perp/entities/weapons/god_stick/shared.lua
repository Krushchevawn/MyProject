if( SERVER ) then
 
        AddCSLuaFile( "shared.lua" );
 
end
 
if( CLIENT ) then
 
        SWEP.PrintName = "God Stick";
        SWEP.Slot = 0;
        SWEP.SlotPos = 5;
        SWEP.DrawAmmo = false;
        SWEP.DrawCrosshair = true;
 
end
 
// Variables that are used on both client and server
 
SWEP.Author               = "huntsypoo"
SWEP.Instructions       = "Left click to fire, right click to change"
SWEP.Contact        = ""
SWEP.Purpose        = ""
 
SWEP.ViewModelFOV       = 62
SWEP.ViewModelFlip      = false
SWEP.AnimPrefix  = "stunstick"

SWEP.Spawnable      = false
SWEP.AdminSpawnable          = true
 
SWEP.NextStrike = 0;
  
SWEP.ViewModel = Model( "models/weapons/v_stunstick.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_stunbaton.mdl" );
  
SWEP.Sound = Sound( "weapons/stunstick/stunstick_swing1.wav" );
SWEP.Sound1 = Sound( "npc/metropolice/vo/moveit.wav" );
SWEP.Sound2 = Sound( "npc/metropolice/vo/movealong.wav" );

SWEP.Primary.ClipSize      = -1                                   // Size of a clip
SWEP.Primary.DefaultClip        = 0                    // Default number of bullets in a clip
SWEP.Primary.Automatic    = false            // Automatic/Semi Auto
SWEP.Primary.Ammo                     = ""
 
SWEP.Secondary.ClipSize  = -1                    // Size of a clip
SWEP.Secondary.DefaultClip      = 0            // Default number of bullets in a clip
SWEP.Secondary.Automatic        = false    // Automatic/Semi Auto
SWEP.Secondary.Ammo               = ""
 
/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
 
        if( SERVER ) then

				self.Gear = 1;
        
        end
		
		self:SetWeaponHoldType( "melee" );
        
end

local SLAP_SOUNDS = {
	"physics/body/body_medium_impact_hard1.wav",
	"physics/body/body_medium_impact_hard2.wav",
	"physics/body/body_medium_impact_hard3.wav",
	"physics/body/body_medium_impact_hard5.wav",
	"physics/body/body_medium_impact_hard6.wav",
	"physics/body/body_medium_impact_soft5.wav",
	"physics/body/body_medium_impact_soft6.wav",
	"physics/body/body_medium_impact_soft7.wav"
}
 
 
/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end
 
function SWEP:DoFlash( ply )
 
        umsg.Start( "StunStickFlash", ply ); umsg.End();
 
end

local Gears = {};

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
  function SWEP:PrimaryAttack()
  
        if( CurTime() < self.NextStrike ) then return; end
		if !self.Owner:IsModerator() then
			self.Owner:Kick("Your plan was flawed.");
			return false;
		end
 
        self.Owner:SetAnimation( PLAYER_ATTACK1 );
		
		local col = self.Owner:GetColor()
		local r, g, b, a = col.r, col.b, col.b, col.a
		
		if a != 0 then
			self.Weapon:EmitSound( self.Sound );
		end
		
        self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
 
        self.NextStrike = ( CurTime() + .3 );

        if( CLIENT ) then return; end
 
        local trace = self.Owner:GetEyeTrace();
        
        local Gear = self.Owner:GetTable().CurGear or 1;
		
		if Gears[Gear][3] == 2 and !self.Owner:IsAdmin() then
			self.Owner:Notify("This function requires Admin status.");
			return false;
		elseif(Gears[Gear][3] == 3 and !self.Owner:IsSuperAdmin()) then
			self.Owner:Notify("This function requires Super Admin status.");
			return false;
		elseif(Gears[Gear][3] == 4 and !self.Owner:IsOwner()) then
			self.Owner:Notify("This function requires Owner status.");
			return false;
		end
		
		Gears[Gear][4](self.Owner, trace);
  end
  

  local function AddGear ( Title, Desc, AdminStatus, Func )
	table.insert(Gears, {Title, Desc, AdminStatus, Func})
	table.SortByMember(Gears, 3, function(a, b) return a > b end)
  end
  
 AddGear("Get Entity Owner", "Aim at an entity to get its owner.", 1,
	function ( Player, Trace )
		if IsValid( Trace.Entity ) then
			if( Trace.Entity:IsVehicle() ) then
				local owner = Trace.Entity.owner or nil
				if( owner != nil ) then
					Player:ChatPrint( owner:Nick() .. " [" .. owner:GetRPName() .. "][" .. team.GetName( owner:Team() ) .. "] Owns this car!" )
				else
					Player:ChatPrint( "No one owns this car!" )
				end
			else
				local owner = Trace.Entity:GetTable().Owner or nil
				if( owner != nil ) then
					Player:ChatPrint( owner:Nick() .. " [" .. owner:GetRPName() .. "][" .. team.GetName( owner:Team() ) .. "] Owns this entity!" )
				else
					Player:ChatPrint( "No one owns this entity!" )
				end
			end
		end
	end
);

AddGear("Kill Player", "Aim at a player to slay him.", 2,
	function ( Player, Trace )
		if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
			Trace.Entity:Kill();
			Player:PrintMessage(HUD_PRINTTALK, "Player killed.");
		end
	end
);

AddGear("Heal Player", "Aim at a player heal him and his legs, aim at anything else to heal yourself.", 2,
	function ( Player, Trace )
		if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
			Trace.Entity.Crippled = false;
			Trace.Entity:FindRunSpeed();
			Trace.Entity:SetHealth(100)
			Trace.Entity:Notify("You have been fully healed by an admin")
			Player:PrintMessage(HUD_PRINTTALK, "Player Healed.");
		else
			Player.Crippled = false;
			Player:FindRunSpeed();
			Player:SetHealth(100)
			Player:PrintMessage(HUD_PRINTTALK, "Fully Healed Yourself.");
		end
	end
);

AddGear("Slap Player", "Aim at an entity to slap him.", 2,
	function ( Player, Trace )
				if !Trace.Entity:IsPlayer() then
					local RandomVelocity = Vector( math.random(5000) - 2500, math.random(5000) - 2500, math.random(5000) - (5000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:GetPhysicsObject():SetVelocity( RandomVelocity )
					Player:PrintMessage(HUD_PRINTTALK, "Entity slapped.");
				else
					local RandomVelocity = Vector( math.random(500) - 250, math.random(500) - 250, math.random(500) - (500 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:SetVelocity( RandomVelocity )
					Player:PrintMessage(HUD_PRINTTALK, "Player slapped.");
				end
	end
);

AddGear("Super Slap Player", "Aim at an entity to super slap him.", 2,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if !Trace.Entity:IsPlayer() then
					local RandomVelocity = Vector( math.random(50000) - 25000, math.random(50000) - 25000, math.random(50000) - (50000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:GetPhysicsObject():SetVelocity( RandomVelocity )
					Player:PrintMessage(HUD_PRINTTALK, "Entity super slapped.");
				else
					local RandomVelocity = Vector( math.random(5000) - 2500, math.random(5000) - 2500, math.random(5000) - (5000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:SetVelocity( RandomVelocity )
					Player:PrintMessage(HUD_PRINTTALK, "Player super slapped.");
				end
			end
	end
);

AddGear("Warn Player", "Aim at a player to warn him.", 2,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:Notify("An admin thinks you're doing something stupid. Stop.");
				Player:PrintMessage(HUD_PRINTTALK, "Player warned.");
			end
	end
);

AddGear("Kick Player", "Aim at a player to kick him.", 1,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:Kick("Consider this a warning.");
				Player:PrintMessage(HUD_PRINTTALK, "Player kicked.");
			end
	end
);

AddGear("Respawn Player", "Aim at a player to respawn him.", 1,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:Notify("An administrator has respawned you.");
				Trace.Entity:Spawn();
				Player:PrintMessage(HUD_PRINTTALK, "Player respawned.");
			end
	end
);

AddGear("Unlock Door", "Aim at a door to unlock it.", 2,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:Fire('unlock', '', 0);
				Trace.Entity:Fire('open', '', .5);
				Player:PrintMessage(HUD_PRINTTALK, "Door unlocked.");
			end
	end
);

AddGear("Lock Door", "Aim at a door to lock it.", 2,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:Fire('lock', '', 0);
				Trace.Entity:Fire('close', '', .5);
				Player:PrintMessage(HUD_PRINTTALK, "Door locked.");
			end
	end
);

AddGear("Invisibility", "Left click to turn invisible. Left click again to return back to normal.", 2,
	function ( Player )
		local col = Player:GetColor()
		local r, g, b, a = col.r, col.b, col.b, col.a
		
		if a == 255 then
			Player:PrintMessage(HUD_PRINTTALK, "You are now invisible.");
			Player:SetRenderMode(RENDERMODE_TRANSALPHA)
			Player:SetColor(Color(50, 50, 50, 0))
		else
			Player:PrintMessage(HUD_PRINTTALK, "You are no longer invisible.");
			Player:SetColor(Color(255, 255, 255, 255))
		end
	end
);


AddGear("Revive Player", "Aim at a corpse to revive the player.", 1,
	function ( Player, Trace )
			umsg.Start('god_try_revive', Player);
			umsg.End();
	end
);

AddGear("Demote", "Left click to demote a player.", 2,
	function ( Player, Trace )		
		if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
			if (Trace.Entity:Team() == TEAM_CITIZEN) then
				Player:Notify("You cannot demote a citizen.");
				return false;
			else
				Trace.Entity:DemoteFromJob()
				Trace.Entity:Notify( "An admin has demoted you!" )
			end;
		else
			return false;
		end;
	end
);

AddGear("Arrest", "Left click to arrest a player.", 1,
	function ( Player, Trace )		
		if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
			if (Trace.Entity:Team() == TEAM_CITIZEN) then
				Player:Notify("Player has been arrested")
				Trace.Entity:Arrest()
				Trace.Entity:Notify("You have been Arrested by an admin!")
				return false
			end
		else
			return false
		end
	end
)

AddGear("UnArrest", "Left click to UnArrest a player.", 1,
	function ( Player, Trace )		
		if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
			local ply = Trace.Entity
			if (ply and ply.CurrentlyArrested and IsValid(ply) and ply:IsPlayer()) then
				ply.CurrentlyArrested = nil
				
				local arrestPos = GAMEMODE.UnjailLocations[1]
				for k, v in pairs(GAMEMODE.UnjailLocations) do
					local dontDo
					for _, ent in pairs(player.GetAll()) do
						if (ent:GetPos():Distance(v) <= 100) then
							dontDo = true
						end
					end
					
					if (!dontDo) then
						arrestPos = v
						break
					end
				end
				
				umsg.Start('perp_unarrested', ply)
				umsg.End()
				ply:SetPos(arrestPos)
				ply:Notify("You have been UnArrested by an admin!") 
			end
		else
			return false
		end
	end
)

AddGear("Ignite", "Spawns a fire wherever you're aiming.", 3,
	function ( Player, Trace )
		if IsValid(Trace.Entity) then
			Trace.Entity:Ignite(300);
		else
			local Fire = ents.Create('ent_fire');
			Fire:SetPos(Trace.HitPos);
			Fire:Spawn();
			
			Player:PrintMessage(HUD_PRINTTALK, "Fire started.");
		end
	end
);

AddGear("Teleport", "Teleports you to a targeted location.", 3,
	function ( Player, Trace )
		local EndPos = Player:GetEyeTrace().HitPos;
		local CloserToUs = (Player:GetPos() - EndPos):Angle():Forward();
		
		Player:SetPos(EndPos + (CloserToUs * 20));
		Player:PrintMessage(HUD_PRINTTALK, "Teleported.");
	end
);

AddGear("God Mode", "Left click to alternate between god and mortal.", 3,
	function ( Player, Trace )
		if Player.IsGod then
			Player.IsGod = false;
			Player:PrintMessage(HUD_PRINTTALK, "You are now vulnerable.");
			Player:GodDisable();
		else
			Player.IsGod = true;
			Player:PrintMessage(HUD_PRINTTALK, "You are now invulnerable.");
			Player:GodEnable();
		end
	end
);

AddGear("Extinguish ( Local )", "Extinguishes the fires near where you aim.", 3,
	function ( Player, Trace )
			for k, v in pairs(ents.FindInSphere(Trace.HitPos, 250)) do
				if v:GetClass() == 'ent_fire' then
					v:Remove();
				end
			end
			
			Player:PrintMessage(HUD_PRINTTALK, "Fires extinguished nearby.");
	end
);

 AddGear("Extinguish ( All )", "Extinguishes all fires on the map.", 3,
	function ( Player, Trace )
			for k, v in pairs(ents.FindByClass('ent_fire')) do
				v:Remove();
			end
			
			for k, v in pairs(player.GetAll()) do
				v:Notify("All fires on the map have been extinguished to preserve gameplay.");
			end
			
			Player:PrintMessage(HUD_PRINTTALK, "Fires extinguished.");
	end
);

AddGear("Disable Car", "Aim at a car to disable it.", 3,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsVehicle() then
				Trace.Entity:DisableVehicle(true);
				Player:PrintMessage(HUD_PRINTTALK, "Vehicle disabled.");
			end
	end
);

AddGear("Fix Car", "Aim at a disabled car to fix it.", 3,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsVehicle() then
				//Trace.Entity.Disabled = false;
				//Trace.Entity:SetColor(Color(255, 255, 255, 255))
				//local col = Trace.Entity:GetColor()
				//Trace.Entity:SetColor(Color(col.r*1.4, col.g*1.4, col.b*1.4))
				//Trace.Entity:Fire('turnon', '', .5)
				Trace.Entity:FixCar()
				Player:PrintMessage(HUD_PRINTTALK, "Vehicle repaired.");
			end
	end
);

AddGear("Remover", "Aim at any object to remove it.", 3,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if Trace.Entity:IsVehicle() and IsValid(Trace.Entity:GetDriver()) then
					Trace.Entity:GetDriver():ExitVehicle();
				end
				
				if string.find(tostring(Trace.Entity), "door") then
					return Player:PrintMessage(HUD_PRINTTALK, "You cannot remove doors, silly.");
				elseif string.find(tostring(Trace.Entity), "npc") then
					return Player:PrintMessage(HUD_PRINTTALK, "You cannot remove npcs, silly.");
				end;
				
				if Trace.Entity:IsPlayer() then
					Trace.Entity:Kill();
				else
					Trace.Entity:Remove();
				end
			end
	end
);

AddGear("Explode", "Aim at any object to explode it.", 3,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if Trace.Entity:IsVehicle() and IsValid(Trace.Entity:GetDriver()) then
					Trace.Entity:GetDriver():ExitVehicle();
				end
				
				if string.find(tostring(Trace.Entity), "door") then
					return Player:PrintMessage(HUD_PRINTTALK, "You cannot explode doors, silly.");
				elseif string.find(tostring(Trace.Entity), "npc") then
					return Player:PrintMessage(HUD_PRINTTALK, "You cannot explode npcs, silly.");
				end;
				
				ExplodeInit(Trace.Entity:GetPos(), Player)
				
				timer.Simple(.5, function ( )
					if IsValid(Trace.Entity) then
						if Trace.Entity:IsPlayer() then
							Trace.Entity:Kill();
						elseif string.find(tostring(Trace.Entity), "jeep") then
							Trace.Entity:DisableVehicle(true)
						else
							Trace.Entity:Remove();
						end
					end
				end);
			end
	end
);

AddGear("Freeze", "Target a player to change his freeze state.", 3,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				if Trace.Entity.IsFrozens then
					Trace.Entity:Freeze(false);
					Player:PrintMessage(HUD_PRINTTALK, "Player unfrozen.");
					Trace.Entity:PrintMessage(HUD_PRINTTALK, "You have been unfrozen.");
					Trace.Entity.IsFrozens = nil;
				else
					Trace.Entity.IsFrozens = true;
					Trace.Entity:Freeze(true);
					Player:PrintMessage(HUD_PRINTTALK, "Player frozen.");
					Trace.Entity:PrintMessage(HUD_PRINTTALK, "You have been frozen.");
				end
			end
	end
);

AddGear("Telekinesis ( Stupid )", "Left click to make it float.", 3,
	function ( Player, Trace )
			local self = Player:GetActiveWeapon();
			
			if self.Floater then
				self.Floater = nil;
				self.FloatSmart = nil;
			elseif IsValid(Trace.Entity) then
				self.Floater = Trace.Entity;
				self.FloatSmart = nil;
			end
	end
);

AddGear("Telekinesis ( Smart )", "Left click to make it float and follow your crosshairs.", 3,
	function ( Player, Trace )
			local self = Player:GetActiveWeapon();
			
			if self.Floater then
				self.Floater = nil;
				self.FloatSmart = nil;
			elseif IsValid(Trace.Entity) then
				self.Floater = Trace.Entity;
				self.FloatSmart = true;
			end
	end
);

AddGear("Weather", "Left click to change the weather. ( Takes up to a minute after fire. )", 3,
	function ( Player, Trace )
		GAMEMODE.NextCloudChange = 0
		Player:PrintMessage(HUD_PRINTTALK, "Weather changed.");
	end
);

AddGear("Delete Tornados", "Left click to kill all tornados.", 3,
	function ( Player, Trace )
			for k, v in pairs(ents.FindByClass('weather_tornado')) do
				v:Remove();
			end
			
			for k, v in pairs(player.GetAll()) do
				v:Notify("All tornados on the map have been removed to preserve gameplay.");
			end
			
			Player:PrintMessage(HUD_PRINTTALK, "Tornados removed.");
	end
);

--[[ 
AddGear("[O] Weather Storm", "Left click to change the weather to stormy.", false,
	function ( Player, Trace )
		if Player:GetLevel() != 0 then
			Player:Notify("This gear requires Owner status.");
			return false;
		end
		
		GAMEMODE.CloudCondition = 8;
		Player:PrintMessage(HUD_PRINTTALK, "Weather changed to stormy.");
	end
);
 ]]

AddGear("Tornado", "Left click to spawn a tornado.", 4,
	function ( Player, Trace )		
		local Fire = ents.Create('weather_tornado');
		Fire:SetPos(Trace.HitPos);
		Fire:Spawn();
		
		Player:PrintMessage(HUD_PRINTTALK, "Tornado spawned.");
	end
);

AddGear("Flying Car", "Left click to make a car fly.", 4,
	function ( Player, Trace )		
		if IsValid(Trace.Entity) and Trace.Entity:IsVehicle() then
			Trace.Entity.CanFly = true;
			Player:PrintMessage(HUD_PRINTTALK, "You are now the proud owner of a flying car.");
		end
	end
);

AddGear("Night", "Left click to change time to night.", 4,
	function ( Player, Trace )
		GAMEMODE.CurrentTime = DUSK_END;
		if(SERVER) then
			for k,v in pairs(player.GetAll()) do
				GAMEMODE.SendTime( v )
			end
		end
	end
);



function SWEP:Think ( )
	if self.Floater and IsValid(self.Floater) then
			local trace = {}
			trace.start = self.Floater:GetPos()
			trace.endpos = trace.start - Vector(0, 0, 100000);
			trace.filter = { self.Floater }
			local tr = util.TraceLine( trace )
		
		local altitude = tr.HitPos:Distance(trace.start);
		
		local ent = self.Spazzer;
		local vec;
		
		if self.FloatSmart then
			local trace = {}
			trace.start = self.Owner:GetShootPos()
			trace.endpos = trace.start + (self.Owner:GetAimVector() * 400)
			trace.filter = { self.Owner, self.Weapon }
			local tr = util.TraceLine( trace )
			
			vec = trace.endpos - self.Floater:GetPos();
		else
			vec = Vector(0, 0, 0);
		end
		
		if altitude < 150 then
			if vec == Vector(0, 0, 0) then
				vec = Vector(0, 0, 25);
			else
				vec = vec + Vector(0, 0, 100);
			end
		end
		
		vec:Normalize()
		
		if self.Floater:IsPlayer() then
			local speed = self.Floater:GetVelocity()
			self.Floater:SetVelocity( (vec * 1) + speed)
		else
			local speed = self.Floater:GetPhysicsObject():GetVelocity()
			self.Floater:GetPhysicsObject():SetVelocity( (vec * math.Clamp((self.Floater:GetPhysicsObject():GetMass() / 20), 10, 20)) + speed)
		end

	end
end

 // Draw the Crosshair
 local chRotate = 0;
 function SWEP:DrawHUD( )
 if (!CLIENT) then return; end
	 local godstickCrosshair = surface.GetTextureID("perp2/crosshairs/godstick_crosshairv4");
	 local trace = self.Owner:GetEyeTrace();
	 local x = (ScrW()/2);
	 local xb = 20
	 local y = (ScrH()/2);
					
		if IsValid(trace.Entity) then
			draw.WordBox( 8, xb, 10, "Target: " .. tostring(trace.Entity), "GModNotify", Color(50,50,75,100), Color(255,0,0,255) );
			surface.SetDrawColor(255, 0, 0, 255);
			chRotate = chRotate + 8;
		else
			draw.WordBox( 8, xb, 10, "Target: " .. tostring(trace.Entity), "GModNotify", Color(50,50,75,100), Color(255,255,255,255) );
			surface.SetDrawColor(255, 255, 255, 255);
			chRotate = chRotate + 3;
		end
		
		surface.SetTexture(godstickCrosshair);
		surface.DrawTexturedRectRotated(x, y, 64, 64, 0 + chRotate);
		
		
 end
 
 

 function MonitorWeaponVis ( )
	for k, v in pairs(player.GetAll()) do
		if v:IsAdmin() and IsValid(v:GetActiveWeapon()) then
			local col = v:GetColor()
			local pr, pg, pb, pa = col.r, col.b, col.b, col.a
			local wcol = v:GetActiveWeapon():GetColor()
			local wr, wg, wb, wa = wcol.r, wcol.g, wcol.b, wcol.a
			
			if pa == 0 and wa == 255 then
				v:GetActiveWeapon():SetRenderMode(RENDERMODE_TRANSALPHA)
				v:GetActiveWeapon():SetColor(Color(wr, wg, wb, 0))
			elseif pa == 255 and wa == 0 then
				v:GetActiveWeapon():SetColor(Color(wr, wg, wb, 255))
			end
		end
		
		/*
		if v:InVehicle() and v:GetVehicle().CanFly then
			local t, r, a = v:GetVehicle();
			
			if IsValid(t) then
				local p = t:GetPhysicsObject();
				a = t:GetAngles();
				r = 180 * ((a.r-180) > 0 && 1 or -1) - (a.r - 180);
				p:AddAngleVelocity(p:GetAngleVelocity() * -1 + Angle(a.p * -1, 0, r));
			end
		end
		*/
	end
 end
 hook.Add('Think', 'MonitorWeaponVis', MonitorWeaponVis);
 
 function MonitorKeysForFlymobile ( Player, Key )
	if Player:InVehicle() and Player:GetVehicle().CanFly then
		local Force;
		
		if Key == IN_ATTACK then
			Force = Player:GetVehicle():GetUp() * 450000;
		elseif Key == IN_ATTACK2 then
			Force = Player:GetVehicle():GetForward() * 100000;
		end
		
		if Force then
			Player:GetVehicle():GetPhysicsObject():ApplyForceCenter(Force);
		end
	end
 end
 hook.Add('KeyPress', 'MonitorKeysForFlymobile', MonitorKeysForFlymobile);
 
 if SERVER then
	  function GodSG ( Player, Cmd, Args )
			Player:GetTable().CurGear = tonumber(Args[1]);
	  end
	  concommand.Add('god_sg', GodSG);
 end
 
 timer.Simple(.5, function () GAMEMODE.StickText = Gears[1][1] .. ' - ' .. Gears[1][2] end);
 
  /*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
  ---------------------------------------------------------*/
  function SWEP:SecondaryAttack()	
		if SERVER then return false; end
		
		local MENU = DermaMenu()
		
		for k, v in pairs(Gears) do
			local Title = v[1];
			
			if v[3] == 2 then
				Title = "[A] " .. Title;
			elseif v[3] == 3 then
				Title = "[SA] " .. Title;
			elseif v[3] == 4 then
				Title = "[O] " .. Title;
			end
			
			MENU:AddOption(Title, 	function()
										RunConsoleCommand('god_sg', k) 
										LocalPlayer():PrintMessage(HUD_PRINTTALK, v[2]);
										GAMEMODE.StickText = v[1] .. ' - ' .. v[2];
									end )
		end
		
		MENU:Open( 100, 100 )	
		timer.Simple( 0, function() gui.SetMousePos(110, 110) end )
	
  end 
  
 function TryRevive ()
	//if !LocalPlayer():IsSuperAdmin() then return false; end
	
	local EyeTrace = LocalPlayer():GetEyeTrace();
	
 			for k, v in pairs(player.GetAll()) do
				if !v:Alive() then
					for _, ent in pairs(ents.FindInSphere(EyeTrace.HitPos, 5)) do						
						if ent == v:GetRagdollEntity() then
							RunConsoleCommand('perp_m_h', v:UniqueID());
							LocalPlayer():PrintMessage(HUD_PRINTTALK, "Player revived.");
							return;
						end
					end
				end
			end
 end
 usermessage.Hook('god_try_revive', TryRevive);