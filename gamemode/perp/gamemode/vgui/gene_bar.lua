
local PANEL = {};

surface.CreateFont("GeneFont", {
	size = ScreenScale(10), 
	weight = 1000, 
	antialias = true,
	shadow = false, 
	font = "Tahoma"
})

function PANEL:Init ( )
	self.MonitorSkill = 'ERROR'
	self:SetSkin("perp2")
	
	self.myButton = vgui.Create("DImageButton", self)
	self.myButton:SetMaterial("PERP2/silk/add")
	self.myButton:SetSize(16, 16);
	
	function self.myButton.DoClick ( )
		GAMEMODE.UpgradeGene(self.RealSkill);
	end
end

function PANEL:PerformLayout ( )
	surface.SetFont("GeneFont");
	local x, y = surface.GetTextSize("whatever.");
	self:SetHeight(y * 1.5);
	
	self.myButton:SetPos(self:GetWide() - 16, self:GetTall() * .5 - 8);
end

function PANEL:Paint ( )
	surface.SetDrawColor(0, 0, 0, 255);
	surface.DrawRect(0, 0, self:GetWide() - 18, self:GetTall());
	surface.SetDrawColor(255, 255, 255, 255);
	surface.DrawRect(1, 1, self:GetWide() - 20, self:GetTall() - 2);
	
	local skillLevel = LocalPlayer():GetPERPLevel(self.RealSkill);
	
	if skillLevel != 0 then
		surface.SetDrawColor(200, 50, 50, 200);
		surface.DrawRect(1, 1, (self:GetWide() - 20) * (skillLevel / 5), self:GetTall() - 2);
	end
	
	draw.SimpleText(GENES_DATABASE[self.MonitorSkill][2], 'GeneFont', (self:GetWide() - 18) * .025, self:GetTall() * .5, Color(0, 0, 0, 255), 0, 1);
	draw.SimpleText("Level " .. skillLevel .. "/5", 'GeneFont', (self:GetWide() - 18) * .975, self:GetTall() * .5, Color(0, 0, 0, 255), 2, 1);
end

function PANEL:SetSkill ( SkillID )
	self.RealSkill = SkillID;
	self.MonitorSkill = GAMEMODE.GetRealGeneID(SkillID);
	self:PerformLayout();
	return self;
end

vgui.Register('perp2_gene_bar', PANEL);