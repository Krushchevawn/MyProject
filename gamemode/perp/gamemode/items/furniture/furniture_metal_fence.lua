local ITEM 					= {}

ITEM.ID 					= 108
ITEM.Reference 				= "furniture_metal_fence"

ITEM.Name 					= "Metal Fence"
ITEM.Description			= "Designed for both privacy and protection.\n\nUSE the item to drop it as prop."

ITEM.Weight 				= 10
ITEM.Cost					= 400

ITEM.MaxStack 				= 5

ITEM.InventoryModel 		= "models/props_c17/fence01a.mdl"
ITEM.ModelCamPos 				= Vector(132, 0, 0)
ITEM.ModelLookAt 				= Vector(0, 0, 0)
ITEM.ModelFOV 					= 70
ITEM.WorldModel 			= "models/props_c17/fence01a.mdl"

ITEM.RestrictedSelling	 	= false // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= false // If this isn't true, the server will tell the client when something happens to us.

if SERVER then

	function ITEM.OnUse ( Player )
		local prop = Player:SpawnProp(ITEM)
		
		if (!prop || !IsValid(prop)) then return false end
		prop.UnBurnable = true
		
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