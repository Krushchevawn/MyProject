local MIXTURE = {}

MIXTURE.ID = 40;

MIXTURE.Results = "furniture_metal_fence";
MIXTURE.Ingredients = {'item_chunk_metal', 'item_chunk_metal', 'item_metal_rod', 'item_metal_rod', 'item_metal_rod', 'item_metal_rod', 'item_metal_rod'};
MIXTURE.Requires = 	{
						{GENE_INTELLIGENCE, 1},
						{GENE_STRENGTH, 2},
						{SKILL_CRAFTINESS, 2},
					};
					
MIXTURE.Free = true;
MIXTURE.Category = "Furniture"

MIXTURE.RequiresHeatSource = false;
MIXTURE.RequiresWaterSource = false;
MIXTURE.RequiresSawHorse = false;
MIXTURE.MixInWorld = false


function MIXTURE.CanMix ( player, pos )
	return true;
end

GM:RegisterMixture(MIXTURE);