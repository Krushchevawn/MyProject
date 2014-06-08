///////////////////////////////
// © 2009-2010 Pulsar Effect //
//    All rights reserved    //
///////////////////////////////
// This material may not be  //
//   reproduced, displayed,  //
//  modified or distributed  //
// without the express prior //
// written permission of the //
//   the copyright holder.   //
///////////////////////////////


if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Fists"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Hunts"
SWEP.Instructions = "Left Click: Punch, Right Click: Knock\nHas custom animation! USE KEYS FOR NORMAL RP"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.LockSound = "doors/door_latch1.wav"
SWEP.UnlockSound = "doors/door_latch3.wav"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = "models/perp2/v_fists.mdl";
SWEP.WorldModel = "models/weapons/w_fists_t.mdl"

function SWEP:Initialize()
	self:SetWeaponHoldType("fist")
end

function SWEP:CanPrimaryAttack ( ) return true; end

function SWEP:PrimaryAttack()
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Weapon:EmitSound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav");
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:SetNextPrimaryFire(CurTime() + .5)

	local EyeTrace = self.Owner:GetEyeTrace();
	
	local Distance = self.Owner:EyePos():Distance(EyeTrace.HitPos);
	if Distance > 75 then return false; end
	
	if EyeTrace.MatType == MAT_GLASS then
		self.Weapon:EmitSound("physics/glass/glass_cup_break" .. math.random(1, 2) .. ".wav");
		return false
	end
	
	if EyeTrace.HitWorld then
		self.Weapon:EmitSound("physics/flesh/flesh_impact_hard" .. math.random(1, 5) .. ".wav");
		
		return false;
	end
	
	if !EyeTrace.Entity or !EyeTrace.Entity:IsValid() or !EyeTrace.HitNonWorld then return false; end
	
	if EyeTrace.MatType == MAT_FLESH then
		// probably another person or NPC
		self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random(1, 5) .. ".wav")
		
		local OurEffect = EffectData();
		OurEffect:SetOrigin(EyeTrace.HitPos);
		util.Effect("BloodImpact", OurEffect);
		
		if SERVER and !EyeTrace.Entity:IsNPC() then
			EyeTrace.Entity:TakeDamage(GAMEMODE.FistDamage, self.Owner, self.Weapon);
			self.Owner:GiveExperience(SKILL_UNARMED_COMBAT, 2, true);
		end
		
		return false;
	else
		// something else?
		
		self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random(1, 5) .. ".wav")
	end
end

function SWEP:SecondaryAttack()
	local EyeTrace = self.Owner:GetEyeTrace()

	if !EyeTrace.Entity:IsValid() or !EyeTrace.Entity:IsDoor() then return false; end
	
	local Distance = self.Owner:EyePos():Distance(EyeTrace.HitPos);
	
	if Distance > 75 then return false; end
	
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Weapon:EmitSound("physics/plastic/plastic_box_impact_hard" .. tostring(math.random(1, 4)) .. ".wav", 100, 100)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:SetNextSecondaryFire(CurTime() + .25)
end

function SWEP:Deploy()
	self:SendWeaponAnim( self.AnimDeploy or ACT_VM_DRAW )
	
	return true

end