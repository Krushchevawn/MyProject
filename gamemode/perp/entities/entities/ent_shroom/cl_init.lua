
include('shared.lua')

/*---------------------------------------------------------
   Name: DrawTranslucent
   Desc: Draw translucent
---------------------------------------------------------*/

local FullGrowthTime = 360
local MakeBrown = 720;
local StartFade = 780;
local FullDeath = 840;

function ENT:Draw()
	local SinceSpawn = CurTime() - self.SpawnTime;
	local BrownPerc = (SinceSpawn - MakeBrown) / (StartFade - MakeBrown);
	local FullGrowthPerc = SinceSpawn / FullGrowthTime;
	
	if self.Go then
		self:DrawModel();
	end
end

function ENT:Think ( )	
	local SinceSpawn = CurTime() - self.SpawnTime;
	local FullGrowthPerc = SinceSpawn / FullGrowthTime;
	local BrownPerc = (SinceSpawn - MakeBrown) / (StartFade - MakeBrown);
	local FadePerc = (SinceSpawn - StartFade) / (FullDeath - StartFade);
	
	if FullGrowthPerc > 0 and FullGrowthPerc < 1 then		
		self:SetPos(self.Position - Vector(0, 0, (1 - FullGrowthPerc) * self.Height));
	elseif BrownPerc > 0 and BrownPerc < 1 then	
		self:SetColor(Color(255 - (BrownPerc * (255 - 139)), 255 - (BrownPerc * (255 - 69)), 255 - (BrownPerc * (255 - 19)), 255));
	elseif FadePerc > 0 and FadePerc < 1 then	
		self:SetColor(Color(139, 69, 19, (1 - FadePerc) * 255))		
	end
	
	self.Go = true;
	
	if (LocalPlayer():GetEyeTrace().Entity == self.Entity and LocalPlayer():GetShootPos():Distance(self.Entity:GetPos()) < 512) and BrownPerc < 0 and FullGrowthPerc > 1 then
		self.Entity.ShouldDrawHalo = true
	else
		self.Entity.ShouldDrawHalo = nil
	end
end

function ENT:Initialize ( )	
	self.SpawnTime = CurTime();
	self.Position = self:GetPos();
	self.Brownified = false;
	
	self.Height = (self:OBBMaxs() - self:OBBMins()).z;
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
end
