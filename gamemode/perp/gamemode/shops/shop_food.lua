local SHOP = {}

SHOP.ID 				= 4
SHOP.NPCAssociation 	= 30
SHOP.Name				= "Vending Machine"

SHOP.Items	=	{
					'food_chinese_takeout',
					'food_coffee',
					'food_melon',
					'food_orangejuice',
					'item_waterbottle',
					'item_stim_pack',
				}
				
GM:RegisterShop(SHOP)