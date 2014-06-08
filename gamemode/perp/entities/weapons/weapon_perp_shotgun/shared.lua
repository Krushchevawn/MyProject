


if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
		
end

if ( CLIENT ) then

	SWEP.PrintName			= "Shotgun"			
	SWEP.Author				= "Counter-Strike"

	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "k"
	
	SWEP.BackHolster = true;
	
end

SWEP.HoldType			= "ar2";
SWEP.HoldTypeNorm		= "normal";

SWEP.Base				= "weapon_perp_base"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.AnimPrefix	 = "rpg"

SWEP.Primary.Sound			= Sound( "Weapon_M3.Single" )
SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 5
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.1
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.95
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"


SWEP.IronSightsPos = Vector (2.8185, -1.1064, 1.345)
SWEP.IronSightsAng = Vector (0, 0, 0)
SWEP.NormalPos 			= Vector (-2.7133, 0.1164, 1.9471)
SWEP.NormalAng 			= Vector (-23.2661, -11.0075, 2.3854)

SWEP.MaxPenetration = PENETRATION_SHOTGUN;

SWEP.GrantExperience_Skill 	= SKILL_SHOTGUN_MARK;
SWEP.GrantExperience_Exp	= 5;

function SWEP:Reload()
	self:SetIronsights( false )
	
	if ( self.Weapon:GetSharedBool( "reloading", false ) ) then return end
	
	if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		self.Weapon:SetSharedBool( "reloading", true )
		self.Weapon:SetVar( "reloadtimer", CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
	end
end

function SWEP:Think()
	if ( self.Weapon:GetSharedBool( "reloading", false ) ) then
		if ( self.Weapon:GetVar( "reloadtimer", 0 ) < CurTime() ) then
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SetSharedBool( "reloading", false )
				return
			end
			
			self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			
			self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
			self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
			
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
			end
		end
	end
end
