local NPC = {}

NPC.Name = "Vending Machine"
NPC.ID = 30

NPC.Model = Model("models/props_equipment/snack_machine.mdl")
NPC.Invisible = false;

NPC.Location = {
	}
NPC.Angles = {
	
}
NPC.ShowChatBubble = false;

NPC.Sequence = -1

// This is always local player.
function NPC.OnTalk ( )
	GAMEMODE.OpenShop(4)
end

GAMEMODE:LoadNPC(NPC)