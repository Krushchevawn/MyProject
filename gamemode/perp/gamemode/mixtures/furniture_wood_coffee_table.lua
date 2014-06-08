local MIXTURE = {}

MIXTURE.ID = 29;

MIXTURE.Results = "furniture_wood_coffee_table";
MIXTURE.Ingredients = {'item_board', 'item_board', 'item_board', 'item_board', 'item_board', 'item_board', 'item_nail', 'item_nail', 'item_nail', 'item_nail', 'item_nail', 'item_nail', 'item_nail', 'item_nail', 'item_nail', 'item_nail', 'item_polish', 'item_polish'};
MIXTURE.Requires = 	{
						{SKILL_WOODWORKING, 4},
						{SKILL_CRAFTING, 4},
						{GENE_DEXTERITY, 2},
					};
					
MIXTURE.Free = true;
MIXTURE.Category = "Furniture"

MIXTURE.RequiresHeatSource = false;
MIXTURE.RequiresWaterSource = false;
MIXTURE.RequiresSawHorse = true;
MIXTURE.MixInWorld = false


function MIXTURE.CanMix ( player, pos )
	return true;
end

GM:RegisterMixture(MIXTURE);