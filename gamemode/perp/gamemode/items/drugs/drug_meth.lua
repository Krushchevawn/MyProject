local ITEM 					= {}

ITEM.ID 					= 10
ITEM.Reference 				= "drug_meth"

ITEM.Name 					= "Meth"
ITEM.Description			= "Completely dried and cooked methamphetamine."

ITEM.Weight 				= 5
ITEM.Cost					= 1500

ITEM.MaxStack 				= 5

ITEM.InventoryModel 		= "models/props/water_bottle/perp2_bottle.mdl"
ITEM.ModelCamPos 				= Vector(36, -6, 5)
ITEM.ModelLookAt 				= Vector(0, 0, 5)
ITEM.ModelFOV 					= 70
ITEM.WorldModel 			= "models/props/water_bottle/perp2_bottle.mdl"

ITEM.RestrictedSelling	 	= true // Used for drugs and the like. So we can't sell it.

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