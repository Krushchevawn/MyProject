include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	self.Entity.ShouldDrawHalo = true
end
