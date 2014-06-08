local ITEM 					= {}

ITEM.ID 					= 106
ITEM.Reference 				= "furniture_plastic_crate"

ITEM.Name 					= "Plastic Crate"
ITEM.Description			= "Easy to keep shop items on.\n\nUSE the item to drop it as prop."

ITEM.Weight 				= 5
ITEM.Cost					= 100

ITEM.MaxStack 				= 5

ITEM.InventoryModel 		= "models/props_junk/PlasticCrate01a.mdl"
ITEM.ModelCamPos = Vector(32, -33, 21)
ITEM.ModelLookAt = Vector(-8, 10, 0)
ITEM.ModelFOV 					= 90
ITEM.WorldModel 			= "models/props_junk/PlasticCrate01a.mdl"

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
		return false
	end
	
	function ITEM.OnDrop ( )
		return true
	end
	
end

GM:RegisterItem(ITEM)