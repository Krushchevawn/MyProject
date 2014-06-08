if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )	
end

if ( CLIENT ) then
	SWEP.PrintName = "Taser";
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFlip		= false
end

SWEP.Author = "Hemirox"
SWEP.HoldType			= "pistol"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize = 3
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Delay = 1.5
SWEP.Primary.Cone = 0.1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = ""
SWEP.Secondary.Delay			= 0.1

function SWEP:DrawWorldModel()
	self:SetColor(Color(255, 255, 0))
	self:DrawModel()
end

function SWEP:Initialize()
	self:SetColor(Color(255, 255, 0))
end
 
 function SWEP:PrimaryAttack()	
	if(!self:CanPrimaryAttack()) then return end
	if(self.Owner.taserent) then return end

	local eyetrace = self.Owner:GetEyeTrace(); 
	if !eyetrace.Entity:IsPlayer() or eyetrace.Entity:Team() != TEAM_CITIZEN then return end
	if(eyetrace.Entity.LastTaze and CurTime() < eyetrace.Entity.LastTaze + 15) then return end
	  
	self.Weapon:EmitSound( "Weapon_StunStick.Activate")  
	self.BaseClass.ShootEffects( self ) 

	if (!SERVER) then return end 
	 
	 local ply = eyetrace.Entity
	if(ply:IsPlayer() and ply:GetPos():Distance(self.Owner:GetPos()) < 1200) then
		self:TakePrimaryAmmo(1)
		self.Owner:TasePlayer( eyetrace.Entity )
	end
end

function SWEP:SecondaryAttack()
	if !self.Owner.taserent then return end

	self.Owner:EmitSound( "Weapon_Pistol.Empty")
	self.Owner:EmitSound( "Weapon_SMG1.Empty")
	if (!SERVER) then return end 

	local shock1 = math.random(-1200, 1200 )
	local shock2 = math.random(-1200, 1200 )
	local shock3 = math.random(-1200, 1200 )
	self.Owner.taserent:GetPhysicsObject():ApplyForceCenter( Vector( shock1, shock2, shock3 ) )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
end
