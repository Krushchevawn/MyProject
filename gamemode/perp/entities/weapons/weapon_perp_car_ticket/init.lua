include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.HoldType			= "normal"

function SWEP:Initialize()
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:Reload()
end

SWEP.LastDone = CurTime()
function SWEP:PrimaryAttack()
	if(not self.Owner:Team() == TEAM_POLICE) then return end
	if( CurTime() <= self.LastDone ) then 
		self.Owner:ChatPrint("Please wait before you give another traffic ticket")
		return 
	end
	
	local trEntity = self.Owner:GetEyeTrace().Entity
	if(IsValid(trEntity) and trEntity:IsVehicle() and trEntity:GetPos():Distance(self.Owner:GetPos()) < 200 and trEntity.owner) then
		if(trEntity.owner:IsGovernmentOfficial()) then
			self.Owner:ChatPrint("Can't ticket government or job workers.")
			return
		end
		if(trEntity.Disabled) then
			self.Owner:ChatPrint("This car and its owner have just experienced a terrible accident. Why would you give the owner a ticket?")
			return
		end
		
		if(not trEntity.owner:HasItem("item_parkingticket")) then
			self:EmitSound("ambient/materials/footsteps_glass2.wav")
			self.Owner:ChatPrint("Traffic ticket given to " .. trEntity.owner:Nick())
			self.LastDone = CurTime() + 300
			
			trEntity.owner:GiveItem(103, 1, true)
			trEntity.owner:EmitSound("ambient/materials/footsteps_glass2.wav")
			trEntity.owner:SendLua([[Derma_Message("You have received a traffic ticket from ]] .. self.Owner:Nick() .. [[ (]] .. self.Owner:SteamID() .. [[).", "Traffic Ticket", "I'll pay it.")]])
		else
			self.Owner:ChatPrint("This person has already recieved a ticket.")
		end
	end
	
	self:SetNextPrimaryFire(CurTime() + 6)
end

function SWEP:SecondaryAttack()

end

function SWEP:Think()
end
