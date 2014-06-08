



include('shared.lua')

function ENT:Initialize ()
	self.aps = 5
	self.lastRot = CurTime()
	self.curRot = 0
end

function ENT:Draw()
	if (self:GetSharedBool("smoking", false)) then
		local effect = EffectData();
			effect:SetOrigin(self:GetPos());
		util.Effect("meth_smoke", effect);
	end
	
	if (self:GetSharedString("title", "") != "") then		
		self.curRot = self.curRot + (self.aps * (CurTime() - self.lastRot))
		if (self.curRot > 360) then self.curRot = self.curRot - 360 end
		self.lastRot = CurTime()
		
		local priceText = "$" .. self:GetSharedInt("price", -1)
		local priceColor = Color(255, 255, 255, 255)
		if (self:GetSharedInt("price", -1) == -1) then
			priceText = "Not For Sale"
			priceColor = Color(255, 150, 150, 255)
		elseif (LocalPlayer():GetCash() < self:GetSharedInt("price", -1)) then
			priceColor = Color(255, 150, 150, 255)
		end
		
		cam.Start3D2D(self:LocalToWorld(self:GetSharedVector("maxs", Vector(0, 0, 0))) + Vector(0, 0, 5), Angle(180, self.curRot, -90), .5)
                draw.DrawText(self:GetSharedString("title", ""), "ScoreboardText", 0, -25, Color(255, 255, 255, 255), 1, 1)
                draw.DrawText(priceText, "ScoreboardText", 0, -15, priceColor, 1, 1)
        cam.End3D2D()
		
		cam.Start3D2D(self:LocalToWorld(self:GetSharedVector("maxs", Vector(0, 0, 0))) + Vector(0, 0, 10), Angle(180, self.curRot + 180, -90), .5)
                draw.DrawText(self:GetSharedString("title", ""), "ScoreboardText", 0, -25, Color(255, 255, 255, 255), 1, 1)
                draw.DrawText(priceText, "ScoreboardText", 0, -15, priceColor, 1, 1)
        cam.End3D2D()
	else
		
	end
	self:DrawModel()
end

function ENT:Think()
	if ( LocalPlayer():GetEyeTrace().Entity == self.Entity && EyePos():Distance( self.Entity:GetPos() ) < 512 ) then
		self.Entity.ShouldDrawHalo = true
	else
		self.Entity.ShouldDrawHalo = nil
	end
end
