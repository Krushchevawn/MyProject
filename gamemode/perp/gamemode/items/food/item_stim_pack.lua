local ITEM 					= {}

ITEM.ID 					= 77
ITEM.Reference 				= "item_stim_pack"

ITEM.Name = 'Stim Pack'
ITEM.Description = "Heals your wounds."

ITEM.Weight = 5
ITEM.Cost = 300

ITEM.MaxStack 				= 10

ITEM.InventoryModel 		= "models/healthvial.mdl"
ITEM.ModelCamPos = Vector(12, -4, 6)
ITEM.ModelLookAt = Vector(0, 0, 5)
ITEM.ModelFOV = 70
ITEM.WorldModel 			= "models/healthvial.mdl"

ITEM.RestrictedSelling	 	= false // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= true // If this isn't true, the server will tell the client when something happens to us.

ITEM.Health = 20

if SERVER then

	function ITEM.OnUse ( objPl )
		objPl:SetHealth(math.Clamp(objPl:Health() + ITEM.Health, 0, 100))
		
		objPl:EmitSound("items/smallmedkit1.wav")
		
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
		surface.PlaySound('items/smallmedkit1.wav')
		
		return true
	end
	
	function ITEM.OnDrop ( )
		return true
	end
	
end

GM:RegisterItem(ITEM)
