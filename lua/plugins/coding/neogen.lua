return {
	"danymat/neogen",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"L3MON4D3/LuaSnip",
	},
	keys = {
		{
			"<leader>nf",
			function()
				require("neogen").generate({ type = "func" })
			end,
			desc = "Generate function documentation",
		},
		{
			"<leader>nc",
			function()
				require("neogen").generate({ type = "class" })
			end,
			desc = "Generate class documentation",
		},
		{
			"<leader>nt",
			function()
				require("neogen").generate({ type = "type" })
			end,
			desc = "Generate type documentation",
		},
		{
			"<leader>nF",
			function()
				require("neogen").generate({ type = "file" })
			end,
			desc = "Generate file documentation",
		},
	},
	opts = {
		enabled = true,
		input_after_comment = true, -- Keep your cursor ready to write inside the comment
		snippet_engine = "luasnip",
		languages = {
			lua = {
				template = {
					annotation_convention = "ldoc",
				},
			},
			python = {
				template = {
					annotation_convention = "google_docstrings",
				},
			},
			typescript = {
				template = {
					annotation_convention = "tsdoc",
				},
			},
			javascript = {
				template = {
					annotation_convention = "jsdoc",
				},
			},
			java = {
				template = {
					annotation_convention = "javadoc",
				},
			},
			php = {
				template = {
					annotation_convention = "phpdoc",
				},
			},
			rust = {
				template = {
					annotation_convention = "rustdoc",
				},
			},
		},
		placeholders_text = {
			["description"] = "[TODO:description]",
			["tparam"] = "[TODO:param]",
			["parameter"] = "[TODO:param]",
			["return"] = "[TODO:return]",
			["class"] = "[TODO:class]",
			["throw"] = "[TODO:throw]",
		},
	},
}
