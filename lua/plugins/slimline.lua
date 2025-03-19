return {
	"sschleemilch/slimline.nvim",
	dependencies = {
		"echasnovski/mini.icons",
		"lewis6991/gitsigns.nvim",
	},
	config = function()
		require("slimline").setup({
			bold = false, -- makes primary parts and mode bold
			verbose_mode = false, -- Mode as single letter or as a word
			style = "fg", -- or "fg". Whether highlights should be applied to bg or fg of components
			mode_follow_style = true, -- Whether the mode color components should follow the style option
			workspace_diagnostics = false, -- Whether diagnostics should show workspace diagnostics instead of current buffer
			components = { -- Choose components and their location
				left = {
					"mode",
					"path",
					"git",
				},
				center = {},
				right = {
					"diagnostics",
					"filetype_lsp",
					"progress",
				},
			},
			spaces = {
				components = " ",
				left = " ",
				right = " ",
			},
			sep = {
				hide = {
					first = true,
					last = true,
				},
				left = "",
				right = "",
			},
			hl = {
				modes = {
					normal = "Type", -- highlight base of modes
					insert = "Function",
					pending = "Boolean",
					visual = "Keyword",
					command = "String",
				},
				base = "Comment", -- highlight of everything in in between components
				primary = "Normal", -- highlight of primary parts (e.g. filename)
				secondary = "Comment", -- highlight of secondary parts (e.g. filepath)
			},
			icons = {
				diagnostics = {
					ERROR = " ",
					WARN = " ",
					HINT = " ",
					INFO = " ",
				},
				git = {
					branch = "",
				},
				folder = " ",
				lines = " ",
				recording = " ",
				buffer = {
					modified = "",
					read_only = "",
				},
			},
		})
	end,
}
