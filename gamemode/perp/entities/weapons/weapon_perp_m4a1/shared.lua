/////////////////////////////////////////
// � 2010-2020 D3luX - D3luX-Gaming    //
//    All rights reserved    		   //
/////////////////////////////////////////
// This material may not be  		   //
//   reproduced, displayed,  		   //
//  modified or distributed  		   //
// without the express prior 		   //
// written permission of the 		   //
//   the copyright holder.  		   //
//		D3luX-Gaming.com   			   //
/////////////////////////////////////////


if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
		
end

if ( CLIENT ) then

	SWEP.PrintName			= "M4A1"			
	SWEP.Author				= "Counter-Strike"
	SWEP.ViewModelFOV		= 60
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "W"
	
	SWEP.BackHolster = true;
	
end

SWEP.HoldType			= "ar2";
SWEP.HoldTypeNorm		= "normal";

SWEP.Base				= "weapon_perp_base"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_m4a1.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.AnimPrefix	 = "rpg"

SWEP.Primary.Sound			= Sound( "Weapon_M4A1.Single" )
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay			= 0.07
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector (6.05, -5, 0.6)
SWEP.IronSightsAng = Vector (3, 1.3, 3)

SWEP.NormalPos = Vector( 0, 0, 2 )
SWEP.NormalAng = Vector(  -10, 0, 0 )

SWEP.MaxPenetration = PENETRATION_RIFLE;

SWEP.GrantExperience_Skill 	= SKILL_RIFLE_MARK;
SWEP.GrantExperience_Exp	= 1;