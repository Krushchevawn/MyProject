


include("shared.lua");

function ENT:Initialize ()
	self:InitializeAnimation();
end

function ENT:Draw()
	if(!self:GetSharedBool("Invisible", false)) then
		self:DrawModel()
	end
end

