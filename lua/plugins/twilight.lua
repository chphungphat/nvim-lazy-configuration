return {
	"folke/twilight.nvim",
	opts = {
		dimming = {
			alpha = 0.25,
			color = { "Normal", "#ffffff" },
			term_bg = "#000000",
			inactive = true,
		},
		context = 10,
		exclude = {
			"neo-tree",
			"neo-tree-popup",
			"notify",
		},
	},
}
