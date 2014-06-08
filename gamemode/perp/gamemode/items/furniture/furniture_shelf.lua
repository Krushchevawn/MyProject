
local ITEM 					= {};

ITEM.ID 					= 105;
ITEM.Reference 				= "furniture_shelf";

ITEM.Name 					= "Metal Shelf";
ITEM.Description			= "Useful to show your shop items on.\n\nUSE the item to drop it as prop.";

ITEM.Weight 				= 25;
ITEM.Cost					= 500;

ITEM.MaxStack 				= 10;

ITEM.InventoryModel 		= "models/props_wasteland/kitchen_shelf001a.mdl";
ITEM.ModelCamPos = Vector(100, 100, 56)
ITEM.ModelLookAt = Vector(-10, -5, 45)
ITEM.ModelFOV 					= 70;
ITEM.WorldModel 			= "models/props_wasteland/kitchen_shelf001a.mdl";

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