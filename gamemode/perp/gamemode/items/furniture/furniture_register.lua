local ITEM 					= {}

ITEM.ID 					= 50
ITEM.Reference 				= "furniture_register"

ITEM.Name 					= "Cash Register"
ITEM.Description			= "Useful for store managers.\n\nUSE the item to drop it as prop."

ITEM.Weight 				= 5
ITEM.Cost					= 100

ITEM.MaxStack 				= 10

ITEM.InventoryModel 		= "models/props_c17/cashregister01a.mdl"
ITEM.ModelCamPos 				= Vector(2, 38, 8)
ITEM.ModelLookAt 				= Vector(2, 0, 0)
ITEM.ModelFOV 					= 70
ITEM.WorldModel 			= "models/props_c17/cashregister01a.mdl"

ITEM.RestrictedSelling	 	= false // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= false // If this isn't true, the server will tell the client when something happens to us.

if SERVER then

	function ITEM.OnUse ( Player )
		local prop = Player:SpawnProp(ITEM)
		
		if (!prop || !IsValid(prop)) then return false end
				
		return true
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
		return true
	end
	
	function ITEM.OnDrop ( )
		return true
	end
	
end

GM:RegisterItem(ITEM)