local MIXTURE = {}

MIXTURE.ID = 21;

MIXTURE.Results = "furniture_chair_fancy";
MIXTURE.Ingredients = {'furniture_chair_wooden', 'item_chunk_plastic', 'item_chunk_plastic'};
MIXTURE.Requires = 	{
						{GENE_INTELLIGENCE, 1},
						{GENE_STRENGTH, 1},
						{SKILL_CRAFTINESS, 1},
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