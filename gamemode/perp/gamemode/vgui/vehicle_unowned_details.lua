local PANEL = {}

function PANEL:Init ( )
	self:SetTall(76)
	
	self.Button = vgui.Create('DButton', self)
	self.Button:SizeToContents()
	self.Button:SetTall(20)
	self.Button:SetWide(60)
	self.Button:SetText('Purchase')
	
	self.Button2 = vgui.Create('DButton', self)
	self.Button2:SizeToContents()
	self.Button2:SetTall(20)
	self.Button2:SetWide(60)
	self.Button2:SetText('Demo')
	
	self:SetSkin("perpx")
end

function PANEL:PerformLayout ( )
	self.Button:SetPos(self:GetWide() - 4 - self.Button:GetWide(), self:GetTall() - 4 - self.Button:GetTall())
	self.Button2:SetPos(self:GetWide() - 4 - self.Button2:GetWide(), self:GetTall() - 4 - self.Button2:GetTall() * 2)
end

function PANEL:Paint ( w, h )
	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(150, 150, 150, 255))
	
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(5, 5, 66, 66)
	surface.SetTexture(self.ourMat)
	if(self.ourTable.VipOnly == true and LocalPlayer():IsVIPOrAdmin()) then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(6, 6, 64, 64)
	elseif(self.ourTable.VipOnly == true and not LocalPlayer():IsVIPOrAdmin()) then
		surface.SetDrawColor(255, 150, 150, 255)
		surface.DrawTexturedRect(6, 6, 64, 64)
	else
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(6, 6, 64, 64)
	end
	
	draw.SimpleText(self.ourName or 'ERROR', "RealtorFont", 75, 0, Color(255, 255, 255, 255))
	
	if self.ourCost > LocalPlayer():GetBank() then
		draw.SimpleText(DollarSign() .. self.ourCost, "RealtorFont", self:GetWide() - 4, 0, Color(200, 0, 0, 255), 2)
	else
		draw.SimpleText(DollarSign() .. self.ourCost, "RealtorFont", self:GetWide() - 4, 0, Color(255, 255, 255, 255), 2)
	end
	
	draw.SimpleText("Make: " .. self.ourTable.Make or 'ERROR', "Default", 75, self:GetTall() * .5, Color(255, 255, 255, 255))
	draw.SimpleText("Model: " .. self.ourTable.Model, "Default", 75, self:GetTall() * .7, Color(255, 255, 255, 255))
end

function PANEL:SetVehicle ( Table )
	self.ourTable = Table
	self.ourName = Table.Name
	self.ourCost = Table.Cost
	self.ourID = Table.ID
	self.ourMat = Table.Texture
	
	if LocalPlayer():GetBank() < self.ourCost then
		self.Button:SetEnabled(false)
	end
	
	function self.Button.DoClick ( )
		if LocalPlayer():GetBank() >= self.ourCost then
			if(self.ourTable.VipOnly == true and not LocalPlayer():IsVIPOrAdmin()) then
				LocalPlayer():ChatPrint("This vehicle requires VIP status.")
			else
				RunConsoleCommand('perp_v_p', self.ourID)
				
				self:GetParent():GetParent():GetParent():Remove()
			end
		end
	end
	
	self.Button:SetEnabled(true)
	function self.Button2.DoClick ( )
		RunConsoleCommand('perp_v_demo', self.ourID)
		
		self:GetParent():GetParent():GetParent():Remove()
	end
end

vgui.Register('perp2_vehicle_unowned_details', PANEL)