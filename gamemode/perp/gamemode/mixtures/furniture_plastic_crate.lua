local MIXTURE = {}

MIXTURE.ID = 38;

MIXTURE.Results = "furniture_plastic_crate";
MIXTURE.Ingredients = {'item_chunk_plastic','item_chunk_plastic','item_chunk_plastic', 'item_nail', 'item_nail', 'item_nail', 'item_nail'};
MIXTURE.Requires = 	{
						{SKILL_CRAFTING, 2},
						{GENE_DEXTERITY, 2},
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