local MIXTURE = {}

MIXTURE.ID = 17

MIXTURE.Results = "drug_pot"
MIXTURE.Ingredients = {"drug_pot_seeds", "item_pot"}
MIXTURE.Requires = 	{
						{GENE_INTELLIGENCE, 1},
						{GENE_DEXTERITY, 1},
					}
					
MIXTURE.Free = true
MIXTURE.Category = "Drugs"

MIXTURE.RequiresHeatSource = false
MIXTURE.RequiresWaterSource = false
MIXTURE.MixInWorld = true

function MIXTURE.CanMix ( player, pos )
	if (player:IsGovernmentOfficial()) then
		player:Notify("You cannot do this as a government official.")
		return false
	end
	
	local NumDrugs = 0
	for k, v in pairs(ents.FindByClass('ent_pot')) do
		if v:GetTable().maker == player:SteamID() then
			NumDrugs = NumDrugs + 1
		end
	end
	
	local iCanHave = MAX_POT
	if(player:IsGoldMember() or player:IsVIP()) then
		iCanHave = iCanHave * 2
	end
	
	if NumDrugs >= iCanHave then
		player:Notify('You have hit the maximum number of pot plants allowed.')
		return false
	end

	return true
end

GM:RegisterMixture(MIXTURE)