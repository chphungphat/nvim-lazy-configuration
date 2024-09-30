if true then
	return {}
end
return {
	"folke/twilight.nvim",
	config = function()
		require("twilight").setup({
			dimming = {
				alpha = 0.25,
				color = { "Normal", "#afaf5f" },
				term_bg = "#000000",
				inactive = false,
			},
			context = 20,
			treesitter = false,
			exclude = {
				"notify",
				"oil",
				"oil_preview",
				"copliot-chat",
				"fidget",
				"TelescopePrompt",
				"NvimTree",
			},
			expand = {
				"function",
				"method",
				"table",
				"if_statement",
			},
		})
	end,
}
