local MIXTURE = {}

MIXTURE.ID = 23;

MIXTURE.Results = "furniture_lamp";
MIXTURE.Ingredients = {'furniture_lamp_spot', 'item_chunk_metal', 'item_metal_rod', 'item_metal_rod', 'item_paint'};
MIXTURE.Requires = 	{
						{GENE_INTELLIGENCE, 2},
						{GENE_DEXTERITY, 1},
						{SKILL_CRAFTINESS, 3},
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