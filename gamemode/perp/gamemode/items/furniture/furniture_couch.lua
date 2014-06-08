local ITEM 					= {}

ITEM.ID 					= 80
ITEM.Reference 				= "furniture_couch"

ITEM.Name = 'Large Sofa'
ITEM.Description = "Perfect for relaxation after a long day.\n\nUSE the item to drop it as prop."

ITEM.Weight = 25
ITEM.Cost = 750

ITEM.MaxStack 				= 5

ITEM.InventoryModel 		= "models/props_c17/furniturecouch001a.mdl"
ITEM.ModelCamPos = Vector(92, 0, 26)
ITEM.ModelLookAt = Vector(0, 0, 0)
ITEM.ModelFOV = 70
ITEM.WorldModel 			= "models/props_c17/furniturecouch001a.mdl"

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