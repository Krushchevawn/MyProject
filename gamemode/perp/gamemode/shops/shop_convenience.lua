


local SHOP = {};

SHOP.ID 				= 3;
SHOP.NPCAssociation 	= 18;
SHOP.Name				= "Ching's Convenience Store";

SHOP.Items	=	{
					'drug_beer',
					'item_phone',
					'furniture_radio',
					'item_paper_towels',
					'furniture_cone',
					'item_lifealert',
					'item_salt',
					'item_kittylitter',
					'item_waterbottle',
					'weapon_bat',
					'weapon_binoculars',
					'drug_cig',
					'item_coke',
					'drug_bong', 
					'item_lawbook',
					'item_gascan',
				};
				
GM:RegisterShop(SHOP);