local ITEM 					= {}

ITEM.ID 					= 84
ITEM.Reference 				= "item_police_barrier"

ITEM.Name = 'Police Barricade'
ITEM.Description			= "Useful for blocking city roads.\n\nUSE the item to drop it as prop."

ITEM.Weight = 15
ITEM.Cost = 500

ITEM.MaxStack 				= 10

ITEM.InventoryModel 		= "models/props_wasteland/barricade002a.mdl"
ITEM.ModelCamPos = Vector(0, 80, -2)
ITEM.ModelLookAt = Vector(0, 0, 0)
ITEM.ModelFOV = 70
ITEM.WorldModel 			= "models/props_wasteland/barricade002a.mdl"

ITEM.RestrictedSelling	 	= false // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= false // If this isn't true, the server will tell the client when something happens to us based on the server's OnUse

if SERVER then

	function ITEM.OnUse ( Player )		
		local prop = Player:SpawnProp(ITEM);
		
		if (!prop || !IsValid(prop)) then return false; end
				
		return true;
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
