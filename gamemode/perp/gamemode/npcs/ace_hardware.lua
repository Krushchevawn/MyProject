


local NPC = {};

NPC.Name = "Ace Hardware";
NPC.ID = 17;

//NPC.Model = Model("models/players/PERP2/m_6_01.mdl");
NPC.Model = Model(PERPGetModelPath(1, 6, 1))

NPC.Invisible = false; // Used for ATM Machines, Casino Tables, etc.

NPC.Location = Vector(-6841.4838, -10456.2119, 71.0312);
NPC.Angles = Angle(0, 0, 0.000000);
NPC.ShowChatBubble = "Normal";

NPC.Sequence = 3;

// This is always local player.
function NPC.OnTalk ( )
	GAMEMODE.OpenShop(2);
end

GAMEMODE:LoadNPC(NPC);