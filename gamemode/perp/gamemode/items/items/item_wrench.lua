local ITEM 					= {}

ITEM.ID 					= 44
ITEM.Reference 				= "item_wrench"

ITEM.Name 					= "Wrench"
ITEM.Description			= "Tightens things."

ITEM.Weight 				= 5
ITEM.Cost					= 200

ITEM.MaxStack 				= 5

ITEM.InventoryModel 		= "models/props_c17/tools_wrench01a.mdl"
ITEM.ModelCamPos 				= Vector(4, -4, 14)
ITEM.ModelLookAt 				= Vector(-2, 2, -6)
ITEM.ModelFOV 					= 70
ITEM.WorldModel 			= "models/props_c17/tools_wrench01a.mdl"

ITEM.RestrictedSelling	 	= false // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= true // If this isn't true, the server will tell the client when something happens to us based on the server's OnUse

if SERVER then

	function ITEM.OnUse ( Player )	
		if (Player:GetSharedBool("warrent", false)) then
			Player:Notify("You cannot use this while warranted.")
			return false
		end
	
		local tr = Player:GetEyeTrace()
		local eyeTrace = tr.Entity
		
		if (!eyeTrace || !eyeTrace:IsValid() || tr.HitWorld || !eyeTrace:IsVehicle()) then 
			Player:Notify("You must be facing a vehicle to use this item.")
			return false
		end
		
		if (!eyeTrace:GetTable().Disabled) then
			Player:Notify("That vehicle is not broken!")
			return false
		end
		
		local col = eyeTrace:GetColor()
		eyeTrace:SetColor(Color(col.r*1.4, col.g*1.4, col.b*1.4))
		//eyeTrace:SetColor(Color(255, 255, 255, 255))
		eyeTrace:GetTable().Disabled = nil;
		eyeTrace:GetTable().DisabledTime = nil;
		
		return true;
	end
	
	function ITEM.OnDrop ( Player )
		return true
	end
	
	function ITEM.Equip ( Player )

	end
	
	function ITEM.Holster ( Player )

	end
	
else

	function ITEM.OnUse ( slotID )		
		return false
	end
	
	function ITEM.OnDrop ( )
		return true
	end
	
end

GM:RegisterItem(ITEM)