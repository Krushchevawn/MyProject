


ENT.Type 				= "anim";
ENT.Base 				= "base_anim";
ENT.PrintName			= "NPC";
ENT.Author				= "huntskikbut";
ENT.Purpose				= "Fun & Games";

ENT.Spawnable			= false;
ENT.AdminSpawnable		= false;

function ENT:OnRemove ( )

end

function ENT:InitializeAnimation ( animID )
	if SERVER then
		if animID then
			if animID != -1 then
				self:ResetSequence(animID);
			end
		else
			self:ResetSequence(4);
		end
	end
	
	self.AutomaticFrameAdvance = true;
end

function ENT:SetupDataTables()
	//self:DTVar("Int", 0, "Invisible")
	self:DTVar("Int", 0, "BubbleType")
end
