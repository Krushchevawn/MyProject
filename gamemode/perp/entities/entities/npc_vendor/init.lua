


AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
 
include("shared.lua");

function ENT:Initialize ( )
	self:SetSolid(SOLID_BBOX);
	self:PhysicsInit(SOLID_BBOX);
	self:SetMoveType(MOVETYPE_NONE);
	self:DrawShadow(true);
	self:SetUseType(SIMPLE_USE);
end

function ENT:UseFake ( User )
	if (!IsValid(User) || !User:IsPlayer()) then return false; end
	
	GAMEMODE.NPCUsed(User, self.NPCID);
end
