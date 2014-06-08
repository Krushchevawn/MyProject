hook.Add("PreDrawHalos", "EntityHalos", function()
	local tbl = {}
	for k,v in pairs(ents.GetAll()) do
		if(v.ShouldDrawHalo) then
			table.insert(tbl, v)
		end
	end
	effects.halo.Add(tbl, Color(255, 255, 255), 5, 5, 2)
end)