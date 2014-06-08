


local static_Start = Sound("PERP2.5/cradio_start.mp3");
local static_Stop = Sound("PERP2.5/cradio_close.mp3");

local function thinkRadioStatic ( )
	if (GAMEMODE.PlayStatic) then
		if (!GAMEMODE.StaticNoise) then
			GAMEMODE.StaticNoise = CreateSound(LocalPlayer(), Sound("PERP2.5/cradio_static.mp3"));
		end
		
		if (!GAMEMODE.NextStaticPlay || GAMEMODE.NextStaticPlay < CurTime()) then
			GAMEMODE.NextStaticPlay = CurTime() + SoundDuration("PERP2.5/cradio_static.mp3") - .1;
			GAMEMODE.StaticNoise:Stop();
			GAMEMODE.StaticNoise:Play();
		end
	elseif (GAMEMODE.NextStaticPlay) then
		GAMEMODE.NextStaticPlay = nil;
		GAMEMODE.StaticNoise:Stop();
	end
end
hook.Add("Think", "thinkRadioStatic", thinkRadioStatic);

function GM:PlayerStartVoice ( ply ) 
	if (ply == LocalPlayer()) then GAMEMODE.CurrentlyTalking = true; return; end
	
	if (ply:GetPos():Distance(LocalPlayer():GetPos()) > (ChatRadius_Local + 50) && ply:Team() != TEAM_CITIZEN && ply:GetRPName() != GAMEMODE.Call_Player) then
		GAMEMODE.PlayStatic = true;
		ply.PlayingStaticFor = true;
		
		surface.PlaySound(static_Start);
	end
end
	
function GM:PlayerEndVoice ( ply ) 
	if (ply == LocalPlayer()) then GAMEMODE.CurrentlyTalking = nil; return ;end
	
	if (ply.PlayingStaticFor) then
		ply.PlayingStaticFor = nil;
		surface.PlaySound(static_Stop);
	end
	
	if (!GAMEMODE.PlayStatic) then return; end
	
	local shouldPlayStatic = false;
	for k, v in pairs(player.GetAll()) do
		if (v.PlayingStaticFor) then
			shouldPlayStatic = true;
		end
	end
	
	GAMEMODE.PlayStatic = shouldPlayStatic;
end

local function monitorKeyPress_WalkieTalkie ( )
	if (GAMEMODE.ChatBoxOpen) then return; end
	if (GAMEMODE.MayorPanel && GAMEMODE.MayorPanel.IsVisible && GAMEMODE.MayorPanel:IsVisible()) then return; end
	if (GAMEMODE.OrgPanel && GAMEMODE.OrgPanel.IsVisible && GAMEMODE.OrgPanel:IsVisible()) then return; end
	if (GAMEMODE.HelpPanel && GAMEMODE.HelpPanel.IsVisible && GAMEMODE.HelpPanel:IsVisible()) then return; end
	
	if (input.IsKeyDown(KEY_T)) then
		if (!GAMEMODE.lastTDown) then
			GAMEMODE.lastTDown = true;
			
			if (LocalPlayer():GetSharedBool("tradio", false)) then
				RunConsoleCommand("perp_tr", "0")
			else
				RunConsoleCommand("perp_tr", "1");
			end
		end
	else GAMEMODE.lastTDown = nil; end
end
hook.Add("Think", "monitorKeyPress_WalkieTalkie", monitorKeyPress_WalkieTalkie);