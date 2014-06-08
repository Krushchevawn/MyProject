
hook.Add("InitPostEntity", "EngineSpam", function()
	RunConsoleCommand("con_filter_enable", "1")
	RunConsoleCommand("con_filter_text_out", "vertex format")
end)