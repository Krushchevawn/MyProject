local MIXTURE = {}

MIXTURE.ID = 39;

MIXTURE.Results = "furniture_shelf";
MIXTURE.Ingredients = {'item_chunk_metal','item_chunk_metal','item_chunk_metal','item_chunk_metal', 'item_board', 'item_nail', 'item_nail', 'item_nail', 'item_nail', 'item_nail', 'item_nail', 'item_nail', 'item_nail', 'item_nail', 'item_nail'};
MIXTURE.Requires = 	{
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