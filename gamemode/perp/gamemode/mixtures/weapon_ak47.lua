local MIXTURE = {}

MIXTURE.ID = 4

MIXTURE.Results = "weapon_ak47"
MIXTURE.Ingredients = {'item_chunk_metal', 'item_chunk_metal', 'item_chunk_metal', 'item_chunk_metal', 'item_chunk_metal', 'item_board', 'item_board', 'item_paint'}
MIXTURE.Requires = 	{
						{GENE_INTELLIGENCE, 4},
						{GENE_PERCEPTION, 2},
						{GENE_DEXTERITY, 2},
						{SKILL_CRAFTINESS, 6},
					}
					
MIXTURE.Free = false
MIXTURE.Category = "Weapons"

MIXTURE.RequiresHeatSource = false
MIXTURE.RequiresWaterSource = false
MIXTURE.MixInWorld = false


function MIXTURE.CanMix ( player, pos )
	player:UnlockMixture(6)
	player:UnlockMixture(43)

	return true
end

GM:RegisterMixture(MIXTURE)