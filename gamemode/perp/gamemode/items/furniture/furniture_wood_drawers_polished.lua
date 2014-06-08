
local ITEM 					= {};

ITEM.ID 					= 94;
ITEM.Reference 				= "furniture_wood_drawers_polished";

ITEM.Name 					= "Polished Drawers with Mirror";
ITEM.Description			= "Now you can be an egocentric fool at home!\n\nUSE the item to drop it as prop..";

ITEM.Weight 				= 30;
ITEM.Cost					= 500;

ITEM.MaxStack 				= 1;

ITEM.InventoryModel 		= "models/props_interiors/furniture_vanity01a.mdl";
ITEM.ModelCamPos 				= Vector(73, 50, 33);	
ITEM.ModelLookAt 				= Vector(0, 0, 0);
ITEM.ModelFOV 					= 70;
ITEM.WorldModel 			= "models/props_interiors/furniture_vanity01a.mdl";

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