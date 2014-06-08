local MIXTURE = {}

MIXTURE.ID = 20;

MIXTURE.Results = "drug_beer_box_full";
MIXTURE.Ingredients = {'drug_beer_box_empty', 'drug_beer', 'drug_beer', 'drug_beer', 'drug_beer', 'drug_beer', 'drug_beer'};
MIXTURE.Requires = 	{

					};
					
MIXTURE.Free = true;
MIXTURE.Category = "Drugs"

MIXTURE.RequiresHeatSource = false;
MIXTURE.RequiresWaterSource = false;
MIXTURE.RequiresSawHorse = false;
MIXTURE.MixInWorld = false

function MIXTURE.CanMix ( player, pos )
	return true;
end

GM:RegisterMixture(MIXTURE);