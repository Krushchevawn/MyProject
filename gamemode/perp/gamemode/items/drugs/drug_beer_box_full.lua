local ITEM 					= {};

ITEM.ID 					= 86;
ITEM.Reference 				= "drug_beer_box_full";

ITEM.Name 					= "Box o' Beer (6 Beers)";
ITEM.Description			= "Allows your guests to grab beers at their leisure.";

ITEM.Weight 				= 10;
ITEM.Cost					= 200;

ITEM.MaxStack 				= 5;

ITEM.InventoryModel 		= "models/props/cs_militia/caseofbeer01.mdl";
ITEM.ModelCamPos 				= Vector(0, -16, 25);
ITEM.ModelLookAt 				= Vector(0, 0, 5);
ITEM.ModelFOV 					= 70;
ITEM.WorldModel 			= "models/props/cs_militia/caseofbeer01.mdl";

ITEM.RestrictedSelling	 	= false; // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil;											
ITEM.PredictUseDrop			= false; // If this isn't true, the server will tell the client when something happens to us.

if SERVER then

	function ITEM.OnUse ( Player )
		local prop = Player:SpawnProp(ITEM, "prop_case_beer");
		
		if (!prop || !IsValid(prop)) then return false; end
		
		prop:SetNumBeers(6, Player)
				
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