local ITEM 					= {}

ITEM.ID 					= 79
ITEM.Reference 				= "furniture_sink"

ITEM.Name = 'Sink'
ITEM.Description = "Supplies ample amounts of water.\n\nUSE the item to drop it as prop."

ITEM.Weight = 50
ITEM.Cost = 500

ITEM.MaxStack 				= 3

ITEM.InventoryModel 		= "models/props_c17/furnituresink001a.mdl"
ITEM.ModelCamPos = Vector(18, 0, 30)
ITEM.ModelLookAt = Vector(-14, 0, -1)
ITEM.ModelFOV = 70
ITEM.WorldModel 			= "models/props_c17/furnituresink001a.mdl"

ITEM.RestrictedSelling	 	= false // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= false // If this isn't true, the server will tell the client when something happens to us.

if SERVER then

	function ITEM.OnUse ( Player )
		local prop = Player:SpawnProp(ITEM)
		
		if (!prop || !IsValid(prop)) then return false end
		
		prop:GetTable().WaterSource = true
		
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