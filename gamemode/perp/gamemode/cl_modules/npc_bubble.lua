hook.Add("Think", "NPCBubbleManager", function () 
	for k, npc in pairs(ents.FindByClass("npc_vendor")) do
		if(npc.dt.BubbleType == 0) then continue end
		if(!IsValid(npc.Bubble)) then
			npc.Bubble = ClientsideModel("models/extras/info_speech.mdl", RENDERGROUP_OPAQUE)
			npc.Bubble:SetMoveType( MOVETYPE_NONE )
			npc.Bubble:SetSolid( SOLID_NONE )
			if(npc.dt.BubbleType == 2) then
				npc.Bubble:SetSkin(1)
			end
			npc.Bubble.NextChangeAngle = CurTime();
			npc.Bubble:SetPos(npc:GetPos() + Vector(0, 0, 90))
			npc.Bubble:SetAngles(Angle(0, math.random(0, 90), 0))
		end
		
		npc.Bubble.OriginalPos = npc.Bubble.OriginalPos or npc.Bubble:GetPos();
		npc.Bubble:SetPos(npc.Bubble.OriginalPos + Vector(0, 0, math.sin(CurTime()) * 2.5));
		if (npc.Bubble.NextChangeAngle <= CurTime()) then
			npc.Bubble:SetAngles(npc.Bubble:GetAngles() + Angle(0, .25, 0))
			npc.Bubble.NextChangeAngle = npc.Bubble.NextChangeAngle + (1 / 60)
		end
	end
end)