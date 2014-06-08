local NPC = {}

NPC.Name = "Kane's Crazy Warehouse"
NPC.ID = 21

//NPC.Model = Model("models/players/perp2/m_2_03.mdl")
NPC.Model = Model(PERPGetModelPath(1, 2, 3))

NPC.Location = Vector(-7580.031250, -7632.003418 , 72.0313)
NPC.Angles = Angle(0, 0, 0)
NPC.ShowChatBubble = "Normal";

NPC.Sequence = 3;


// This is always local player.
function NPC.OnTalk ( )
	GAMEMODE.DialogPanel:SetDialog("Hello, welcome to my warehouse, how can I help you?")
		
	GAMEMODE.DialogPanel:AddDialog("I'd like to see my stored items please.", NPC.DoIt)
	GAMEMODE.DialogPanel:AddDialog("Whoops wrong person..", LEAVE_DIALOG)
	
	GAMEMODE.DialogPanel:Show() 
end

function NPC.DoIt ( )
	GAMEMODE.WarehousePanel:Show()
	
	LEAVE_DIALOG()
end

GAMEMODE:LoadNPC(NPC)