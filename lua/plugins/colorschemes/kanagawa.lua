return {
	"rebelot/kanagawa.nvim",
	event = { "VimEnter", "ColorScheme" },
	lazy = false,
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			compile = false,
			undercurl = true,
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = false,
			dimInactive = false,
			terminalColors = true,
			colors = { --
				palette = {},
				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
			},
			overrides = function(colors)
				return {}
			end,
			theme = "dragon",
			background = {
				dark = "dragon",
				light = "lotus",
			},
		})

		-- vim.cmd("colorscheme kanagawa")
	end,
}
