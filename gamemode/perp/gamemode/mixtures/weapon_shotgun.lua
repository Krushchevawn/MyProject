local MIXTURE = {}

MIXTURE.ID = 9

MIXTURE.Results = "weapon_shotgun"
MIXTURE.Ingredients = {'item_chunk_metal', 'item_chunk_metal', 'item_chunk_metal', 'item_chunk_metal', 'item_metal_rod'}
MIXTURE.Requires = 	{
						{GENE_INTELLIGENCE, 4},
						{GENE_PERCEPTION, 2},
						{GENE_DEXTERITY, 2},
						{SKILL_CRAFTINESS, 3},
					}
					
MIXTURE.Free = false
MIXTURE.Category = "Weapons"

MIXTURE.RequiresHeatSource = false
MIXTURE.RequiresWaterSource = false
MIXTURE.MixInWorld = false


function MIXTURE.CanMix ( player, pos )
	player:UnlockMixture(7)

	return true
end

GM:RegisterMixture(MIXTURE)