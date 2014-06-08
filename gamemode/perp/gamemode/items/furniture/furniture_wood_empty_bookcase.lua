
local ITEM 					= {};

ITEM.ID 					= 95;
ITEM.Reference 				= "furniture_wood_empty_bookcase";

ITEM.Name 					= "Chest of Drawers";
ITEM.Description			= "Now you can stack your pointless, unread books with style.\n\nUSE the item to drop it as prop.";

ITEM.Weight 				= 30;
ITEM.Cost					= 300;

ITEM.MaxStack 				= 1;

ITEM.InventoryModel 		= "models/props_c17/shelfunit01a.mdl";
ITEM.ModelCamPos 				= Vector(72, 100, 49);
ITEM.ModelLookAt 				= Vector(0, 0, 45);
ITEM.ModelFOV 					= 70;
ITEM.WorldModel 			= "models/props_c17/shelfunit01a.mdl";

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