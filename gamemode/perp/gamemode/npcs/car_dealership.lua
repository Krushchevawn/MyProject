


local NPC = {};

NPC.Name = "Dealership";
NPC.ID = 4;

//NPC.Model = Model("models/humans/suits2/male_04.mdl");
NPC.Model = Model(PERPGetModelPath(1, 4, 8))

NPC.Invisible = false; // Used for ATM Machines, Casino Tables, etc.

NPC.Location = Vector( 5130.3125, -3551.9155, 228.0313); 
NPC.Angles = Angle(0, 274.5375, 0);

NPC.ShowChatBubble = "Normal";

//NPC.Sequence = 1
NPC.Sequence = 8


// This is always local player.
function NPC.OnTalk ( )
	GAMEMODE.DialogPanel:SetDialog("Welcome to Big Bill Hell's car dealership! I'm Big Bill, how can I help you?");
	
	GAMEMODE.DialogPanel:AddDialog("Hey! I'm looking for a new car.", NPC.NewCar)
	GAMEMODE.DialogPanel:AddDialog("Hello. I'd like to sell a car.", NPC.SellCar)
	GAMEMODE.DialogPanel:AddDialog("How do I become a VIP or GOLD member?", NPC.HowVIP)
	GAMEMODE.DialogPanel:AddDialog("I seemed to lost my car. Have you seen it around?", NPC.LostCar)
	GAMEMODE.DialogPanel:AddDialog("You can't help me. Nobody can help me.", LEAVE_DIALOG)
	
	GAMEMODE.DialogPanel:Show();
end

function NPC.NewCar ( )
	GAMEMODE.DialogPanel:SetDialog("You've come to the right place! Let me show you around.");
	
	GAMEMODE.DialogPanel:AddDialog("Alright, show me your stock.", NPC.ShowCars)
	GAMEMODE.DialogPanel:AddDialog("Do you accept cash payments?", NPC.NoCash)
	GAMEMODE.DialogPanel:AddDialog("Ahh, I don't have time for this right now, sorry.", LEAVE_DIALOG)
end

function NPC.ShowCars ( )
	GAMEMODE.ShowDealershipView();
	LEAVE_DIALOG();
end

function NPC.HowVIP ( )
	GAMEMODE.DialogPanel:SetDialog("It's Easy! Simply open up your Help menu (F1) and visit the VIP tab.")

	GAMEMODE.DialogPanel:AddDialog("Sweet, I'll get right on that.", LEAVE_DIALOG)
end

function NPC.SellCar ( )
	GAMEMODE.DialogPanel:SetDialog("That's understandable, well I can assure a price for you.")
	
	GAMEMODE.DialogPanel:AddDialog("Alright, tell me what their're worth!", NPC.ShowSellCars)
	GAMEMODE.DialogPanel:AddDialog("Ahh, I don't have time for this right now, sorry.", LEAVE_DIALOG)
end

function NPC.ShowSellCars ( )
	GAMEMODE.ShowSellView();
	LEAVE_DIALOG()
end

function NPC.NoCash ( )
	GAMEMODE.DialogPanel:SetDialog("Sorry, we only accept direct bank transactions. Most people don't carry around enough money in their wallets, anyway.");

	GAMEMODE.DialogPanel:AddDialog("Alright, show me your stock.", NPC.ShowCars)
	GAMEMODE.DialogPanel:AddDialog("Ahh, I don't have time for this right now, sorry.", LEAVE_DIALOG)
end

function NPC.LostCar ( )
	GAMEMODE.DialogPanel:SetDialog("I haven't seen it, but have you checked the parking garage?\n\n(You can claim your previously purchased vehicles at the parking garage.)");

	GAMEMODE.DialogPanel:AddDialog("Oh yah, I remember now! Thanks!", LEAVE_DIALOG)
end

GAMEMODE:LoadNPC(NPC);