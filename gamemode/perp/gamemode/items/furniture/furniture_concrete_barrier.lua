local ITEM 					= {}

ITEM.ID 					= 82
ITEM.Reference 				= "furniture_concrete_barrier"

ITEM.Name = 'Concrete Barrier'
ITEM.Description = "Useful for blocking off roads.\n\nUSE the item to drop it as prop."

ITEM.Weight = 50
ITEM.Cost = 300

ITEM.MaxStack 				= 5

ITEM.InventoryModel 		= "models/props_c17/concrete_barrier001a.mdl"
ITEM.ModelCamPos = Vector(-78, -68, 20)
ITEM.ModelLookAt = Vector(15, -5, 20)
ITEM.ModelFOV = 70
ITEM.WorldModel 			= "models/props_c17/concrete_barrier001a.mdl"

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