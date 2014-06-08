local ITEM 					= {}

ITEM.ID 					= 54
ITEM.Reference 				= "furniture_fridge"

ITEM.Name 					= "Refrigerator"
ITEM.Description			= "Stands in the corner and looks good.\n\nUSE the item to drop it as prop."

ITEM.Weight 				= 10
ITEM.Cost					= 300

ITEM.MaxStack 				= 1

ITEM.InventoryModel 		= "models/props_c17/FurnitureFridge001a.mdl"
ITEM.ModelCamPos 				= Vector(72, -36, 0)
ITEM.ModelLookAt 				= Vector(0, 0, -9)
ITEM.ModelFOV 					= 70
ITEM.WorldModel 			= "models/props_c17/FurnitureFridge001a.mdl"

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