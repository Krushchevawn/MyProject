
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel('models/props_junk/garbage_glassbottle003a.mdl');

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetAngles(Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360)));
	
	local Phys = self.Entity:GetPhysicsObject();
	
	if !Phys or !Phys:IsValid() then return; end
	
	self.Entity:GetPhysicsObject():Wake();
	
	self.What = CurTime();
end

function ENT:Explode ( pos )
	sound.Play("physics/glass/glass_cup_break" .. math.random(1, 2) .. ".wav", self:GetPos(), 150, 150);
		
	local Fire = ents.Create('ent_fire')
	Fire:SetPos(pos)
	Fire:Spawn()
	
	self:Remove();
end

function ENT:PhysicsCollide( data, physobj )
	self:Explode(self:GetPos())
end
