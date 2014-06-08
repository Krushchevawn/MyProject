local MIXTURE = {}

MIXTURE.ID = 25;

MIXTURE.Results = "furniture_thermometer";
MIXTURE.Ingredients = {'furniture_clock', 'item_chunk_metal', 'item_metal_rod'};
MIXTURE.Requires = 	{
						{GENE_INTELLIGENCE, 3},
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