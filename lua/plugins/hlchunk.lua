return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local colorscheme = vim.g.colors_name

		local style = {
			gruvbox = "#d47d26",
			bamboo = "#6ab78a",
		}
		local style_color = style[colorscheme]

		require("hlchunk").setup({
			indent = {
				enable = true,
				priority = 10,
				chars = {
					"┊",
				},
			},
			chunk = {
				enable = true,
				priority = 15,
				chars = {
					horizontal_line = "─",
					vertical_line = "│",
					left_top = "┌",
					left_bottom = "└",
					right_arrow = "─",
				},
				style = style_color,
				duration = 50,
				delay = 75,
			},
			exclude_filetypes = {
				aerial = true,
				dashboard = true,
				"oil",
				"oil_preview",
				"neo-tree",
				"neo-tree-popup",
				"notify",
				"copilot-chat",
				"telescope",
				"fidget",
			},
		})
	end,
}
