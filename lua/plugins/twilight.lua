return {
	"folke/twilight.nvim",
	opts = {
		dimming = {
			alpha = 0.25,
			color = { "Normal", "#afaf5f" },
			term_bg = "#000000",
			inactive = true,
		},
		context = 10,
		exclude = {
			"neo-tree",
			"neo-tree-popup",
			"notify",
			"oil_preview",
		},
	},
}
