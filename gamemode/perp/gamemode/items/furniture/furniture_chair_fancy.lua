local ITEM 					= {}

ITEM.ID 					= 47
ITEM.Reference 				= "furniture_chair_fancy"

ITEM.Name 					= "Office Chair"
ITEM.Description			= "Take a load off.\n\nUSE the item to drop it as prop."

ITEM.Weight 				= 35
ITEM.Cost					= 1000

ITEM.MaxStack 				= 5

ITEM.InventoryModel 		= "models/nova/chair_office02.mdl"
ITEM.ModelCamPos 				= Vector(-41, 61, 33)
ITEM.ModelLookAt 				= Vector(0, 0, 28)
ITEM.ModelFOV 					= 70
ITEM.WorldModel 			= "models/nova/chair_office02.mdl"

ITEM.RestrictedSelling	 	= false // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= false // If this isn't true, the server will tell the client when something happens to us.

if SERVER then

	function ITEM.OnUse ( Player )
		local prop = Player:SpawnProp(ITEM, "prop_vehicle_prisoner_pod")
		
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