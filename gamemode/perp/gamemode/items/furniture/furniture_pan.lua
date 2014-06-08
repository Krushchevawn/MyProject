local ITEM 					= {}

ITEM.ID 					= 81
ITEM.Reference 				= "furniture_pan"

ITEM.Name 					= "Frying Pan"
ITEM.Description			= "Useful for frying things.\n\nUSE the item to drop it as prop."

ITEM.Weight = 5
ITEM.Cost = 100

ITEM.MaxStack 				= 10

ITEM.InventoryModel 		= "models/props_interiors/pot02a.mdl"
ITEM.ModelCamPos = Vector(2, -4, 18)
ITEM.ModelLookAt = Vector(0, -1, 0)
ITEM.ModelFOV = 70
ITEM.WorldModel 			= "models/props_interiors/pot02a.mdl"

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