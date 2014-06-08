local ITEM 					= {}

ITEM.ID 					= 114
ITEM.Reference 				= "item_vest"

ITEM.Name = 'Ballistic vest'
ITEM.Description = "Grants 50 Armor."

ITEM.Weight = 15
ITEM.Cost = 600

ITEM.MaxStack 				= 1

ITEM.InventoryModel 		= "models/combine vests/Obseletevest.mdl"
ITEM.ModelCamPos = Vector(-50, 2, 17)
ITEM.ModelLookAt = Vector(100, -1, 21)
ITEM.ModelFOV = 70
ITEM.WorldModel 			= "models/combine vests/obseletevest.mdl"

ITEM.RestrictedSelling	 	= false

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= true

ITEM.Armor = 50

if SERVER then

	function ITEM.OnUse ( objPl )
		if(objPl:Team() != TEAM_CITIZEN) then return false end
		if(objPl:Armor() >= 100) then
			return false 
		end
		objPl:SetArmor(math.Clamp(objPl:Armor() + ITEM.Armor, 0, 100))
		objPl:EmitSound("perp3.0/zipup.wav", 300, 100)
		
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
		if(LocalPlayer():Team() != TEAM_CITIZEN) then return false end
		if(LocalPlayer():Armor() >= 100) then 
			LocalPlayer():Notify("You have the max amount of armor you can get!")  
			return false 
		end
		
		return true
	end
	
	function ITEM.OnDrop ( )
		return true
	end
	
end

GM:RegisterItem(ITEM)
