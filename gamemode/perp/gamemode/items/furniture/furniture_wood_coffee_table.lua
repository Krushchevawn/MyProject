
local ITEM 					= {};

ITEM.ID 					= 92;
ITEM.Reference 				= "furniture_wood_coffee_table";

ITEM.Name 					= "Rounded Coffee Table";
ITEM.Description			= "A table for putting coffee on. Isn't that obvious?\n\nUSE the item to drop it as prop.";

ITEM.Weight 				= 30;
ITEM.Cost					= 300;

ITEM.MaxStack 				= 1;

ITEM.InventoryModel 		= "models/props/cs_office/table_coffee.mdl";
ITEM.ModelCamPos 				= Vector(69, 34, 52);
ITEM.ModelLookAt 				= Vector(0, 0, 0);
ITEM.ModelFOV 					= 70;
ITEM.WorldModel 			= "models/props/cs_office/table_coffee.mdl";

ITEM.RestrictedSelling	 	= false; // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil;											
ITEM.PredictUseDrop			= false; // If this isn't true, the server will tell the client when something happens to us.

if SERVER then

	function ITEM.OnUse ( Player )
		local prop = Player:SpawnProp(ITEM);
		
		if (!prop || !IsValid(prop)) then return false; end
				
		return true;
	end
	
	function ITEM.OnDrop ( Player )
		return true;
	end
	
	function ITEM.Equip ( Player )

	end
	
	function ITEM.Holster ( Player )

	end
	
else

	function ITEM.OnUse ( slotID )		
		return true;
	end
	
	function ITEM.OnDrop ( )
		return true;
	end
	
end

GM:RegisterItem(ITEM);