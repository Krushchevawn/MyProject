
include('shared.lua')

function ENT:Initialize ( )
	self.GrowthTime = POT_GROW_TIME
end

local SHeight = 5;
local SWidth = 2.5
local MaxHeight = 25;
local MaxWidth = 15;

function ENT:Draw()
	self:DrawModel();
end

function ENT:Think ()
	if ( !self.Leaf || !self.Leaf:IsValid() ) then		
		self.Leaf = ClientsideModel("models/props_foliage/spikeplant01.mdl", RENDERGROUP_OPAQUE);
		self.Leaf:PhysicsInit( SOLID_NONE )
		self.Leaf:SetMoveType( MOVETYPE_NONE )
		self.Leaf:SetSolid( SOLID_NONE )
	end

	if (LocalPlayer():GetEyeTrace().Entity == self.Entity and LocalPlayer():GetShootPos():Distance(self.Entity:GetPos()) < 512) and self.dt.SpawnTime + self.GrowthTime < CurTime() then
		self.Entity.ShouldDrawHalo = true
	else
		self.Entity.ShouldDrawHalo = nil
	end

	local GrowthPercent = (CurTime() - self.dt.SpawnTime) / self.GrowthTime;
	
	if (IsValid(self.Leaf)) then
		self.Leaf:SetAngles( self.Entity:GetAngles() )
		self.Leaf:SetPos( self.Entity:GetPos()+self.Entity:GetUp()*24 )
		self.Leaf:SetParent(self.Entity)
	end

	if GrowthPercent <= 1 and self.Leaf then
		local W = SWidth + (GrowthPercent * MaxWidth );

		local mat = Matrix()
		mat:Scale(.05 * Vector(W, W, SHeight + (GrowthPercent * MaxHeight)))
		self.Leaf:EnableMatrix("RenderMultiply", mat)
	end
end

function ENT:OnRemove( )
	if (IsValid(self.Leaf)) then
		self.Leaf:Remove();
	end
end