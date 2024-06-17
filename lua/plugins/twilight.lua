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
			treesitter = true,
			exclude = {
				"neo-tree",
				"neo-tree-popup",
				"notify",
				"oil",
				"oil_preview",
				"copliot-chat",
				"telescope",
			},
			expand = {
				"function",
				"method",
				"table",
				"if_statement",
			},
		})

		vim.keymap.set(
			"n",
			"<leader>t",
			"<cmd>Twilight<CR>",
			{ desc = "Toggle Twilight", noremap = true, silent = true }
		)
	end,
}
