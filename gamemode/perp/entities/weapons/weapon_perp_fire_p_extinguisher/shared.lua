


if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Personal Fire Extinguisher"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "HuntsKikBut and Hemirox"
SWEP.Instructions = "Left Click: Extinguish Fires"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.HoldType = "slam"
SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = 250
SWEP.Primary.DefaultClip = 250
SWEP.Primary.NumShots		= 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.CurrentShot = 1

SWEP.ViewModel = "models/weapons/v_fire_extinguisher.mdl";
SWEP.WorldModel = "models/weapons/w_fire_extinguisher.mdl";

SWEP.ShootSound = Sound("ambient/wind/wind_hit2.wav");


function SWEP:Initialize()
	//if SERVER then
		self:SetWeaponHoldType(self.HoldType)
	//end
end

function SWEP:CanPrimaryAttack ( ) return true; end
function SWEP:CanSecondaryAttack ( ) return false; end

function SWEP:PrimaryAttack()
	self:TakePrimaryAmmo(1)
	
	if self:GetTable().LastNoise == nil then self:GetTable().LastNoise = true; end
	if self:GetTable().LastNoise then
		self.Weapon:EmitSound(self.ShootSound)
		self:GetTable().LastNoise = false;
	else
		self:GetTable().LastNoise = true;
	end
	
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Weapon:SetNextPrimaryFire(CurTime() + .1)
	
	if CLIENT or (game.SinglePlayer() and SERVER) then		
		local ED = EffectData();
			ED:SetEntity(self.Owner);
		util.Effect('fire_extinguish', ED);
	end
	
	if SERVER then
		
		local Trace2 = {};
		Trace2.start = self.Owner:GetShootPos();
		Trace2.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 150;
		Trace2.filter = self.Owner;

		local Trace = util.TraceLine(Trace2);
				
		local CloseEnts = ents.FindInSphere(Trace.HitPos, 50)
		
		for k, v in pairs(CloseEnts) do
			if v:GetClass() == 'ent_fire' then
				v:HitByExtinguisher(self.Owner)
			end
			
			if v:IsOnFire() then v:Extinguish() end
			
			if self:GetTable().Removed == nil then self:GetTable().Removed = false end
			if self:GetTable().LastShoot == nil then self:GetTable().LastShoot = 1 end
							
			if(self.Weapon:Clip1() == 0 and !self:GetTable().Removed) then
				self.Owner:RemoveEquipped(EQUIP_MAIN);
				self:GetTable().Removed = true;
			end
		end
	end
end

function SWEP:SecondaryAttack() end

function SWEP:DrawWorldModel()
    if (IsValid(self.Owner)) then
        local att = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_RH"))
        if (att) then
            pos, ang = att.Pos, att.Ang 
            pos = pos + ang:Up() * -25 + ang:Forward() * -2
            ang:RotateAroundAxis(ang:Up(), 180)
        
            self.Weapon:SetRenderOrigin(pos)
            self.Weapon:SetRenderAngles(ang)
        end
    end

    self.Weapon:DrawModel()
end
