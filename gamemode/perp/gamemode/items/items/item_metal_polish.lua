local ITEM 					= {}

ITEM.ID 					= 23
ITEM.Reference 				= "item_metal_polish"

ITEM.Name 					= "Metal Polish"
ITEM.Description			= "Polishes metal to a nice shine."

ITEM.Weight 				= 5
ITEM.Cost					= 300

ITEM.MaxStack 				= 5

ITEM.InventoryModel 		= "models/props_junk/garbage_plasticbottle003a.mdl"
ITEM.ModelCamPos 				= Vector(24, 0, 0)
ITEM.ModelLookAt 				= Vector(0, 0, 0)
ITEM.ModelFOV 					= 70
ITEM.WorldModel 			= "models/props_junk/garbage_plasticbottle003a.mdl"

ITEM.RestrictedSelling	 	= false // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= true // If this isn't true, the server will tell the client when something happens to us based on the server's OnUse

if SERVER then

	function ITEM.OnUse ( Player )		
		return false
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