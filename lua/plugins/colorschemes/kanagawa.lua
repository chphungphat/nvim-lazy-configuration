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
			functionStyle = { bold = true },
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = { bold = true },
			transparent = false,
			dimInactive = false,
			terminalColors = true,
			colors = { --
				palette = {},
				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
			},
			overrides = function(colors)
				return {
					-- String = { fg = colors.palette.carpYellow, italic = true },
					-- SomePluginHl = { fg = colors.theme.syn.type, bold = true },
				}
			end,
			theme = "dragon",
			background = {
				dark = "dragon",
				light = "lotus",
			},
		})

		vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2a37" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fabd2f", bold = true })

		-- vim.cmd("colorscheme kanagawa")
	end,
}
