local ITEM 					= {}

ITEM.ID 					= 48
ITEM.Reference 				= "furniture_chair_computer"

ITEM.Name 					= "Computer Chair"
ITEM.Description			= "Take a load off.\n\nUSE the item to drop it as prop."

ITEM.Weight 				= 35
ITEM.Cost					= 500

ITEM.MaxStack 				= 5

ITEM.InventoryModel 		= "models/nova/chair_office01.mdl"
ITEM.ModelCamPos 				= Vector(-25, 46, 29)
ITEM.ModelLookAt 				= Vector(0, 0, 20)
ITEM.ModelFOV 					= 70
ITEM.WorldModel 			= "models/nova/chair_office01.mdl"

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