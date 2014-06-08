if !SERVER then return end

local asscmds = {}
asscmds["decals"] = "ASS_Cleardecals"
asscmds["explode"] = "ASS_ExplodePlayer"
asscmds["freeze"] = "ASS_Freeze"
asscmds["unfreeze"] = "ASS_UnFreeze"
asscmds["givehp"] = "ASS_GiveTakeHealth"
asscmds["slay"] = "ASS_KillPlayer"
asscmds["givecash"] = "ASS_GrantCash"
asscmds["revive"] = "ASS_RevivePlayer"
asscmds["respawn"] = "ASS_RespawnPlayer"
asscmds["tp"] = "ASS_TeleportPlayer"
asscmds["bring"] = "ASS_BringPlayer"
asscmds["goto"] = "ASS_GotoPlayer"
asscmds["togooc"] = "perp_a_ooct"
asscmds["kick"] = "ASS_KickPlayer"
asscmds["ban"] = "ASS_BanPlayer"
asscmds["unban"] = "ASS_UnBanPlayer"


hook.Add( "PlayerSay", "ASS_ChatCommands", function(ply, txt)

    if((string.Left(txt, 1) == "/" or string.Left(txt, 1) == "!") and string.Left(txt, 2) != "//") then
		local tbl = string.Explode(" ", txt)
		local cmd = string.Right(tbl[1], string.len(tbl[1]) - 1)
		cmd = string.lower(cmd)
		if(asscmds[cmd]) then
			local str =  ""
			if(string.len(txt) > string.len(tbl[1])) then
				str = string.Right( txt, string.len( txt ) - ( string.len( tbl[1] ) ) )
			end
			ply:ConCommand(asscmds[cmd] .. str)
			return ""
		end
	end
        
end )
