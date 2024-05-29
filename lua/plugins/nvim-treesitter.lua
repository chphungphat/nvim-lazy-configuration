return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"javascript",
			"jsx",
			"typescript",
			"tsx",
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"vim",
			"vimdoc",
		},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = { "ruby" } },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},
		textobjects = {
			select = {
				enable = false, -- Not frequently used
				lookahead = true,
				keymaps = {
					["of"] = "@function.outer",
					["if"] = "@function.inner",
					["oc"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
				goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
				goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
				goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
			},
		},
		context = {
			enable = true,
			max_lines = 0,
			min_window_height = 10,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "inner",
			mode = "cursor",
			separator = nil,
			zindex = 20,
			on_attach = nil,
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.install").prefer_git = true
		require("nvim-treesitter.configs").setup(opts)
	end,
}
