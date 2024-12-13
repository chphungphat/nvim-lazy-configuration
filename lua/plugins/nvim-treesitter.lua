return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"javascript",
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
					node_decremental = "<C-/>",
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.install").prefer_git = true
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			textobjects = {
				select = {
					enable = true,
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
					goto_next_end = { ["]]f"] = "@function.outer", ["]]c"] = "@class.outer" },
					goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
					goto_previous_end = { ["[[f"] = "@function.outer", ["[[c"] = "@class.outer" },
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
			multiwindow = true, -- Enable multiwindow support.
			max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
			min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
			line_numbers = true,
			multiline_threshold = 20, -- Maximum number of lines to show for a single context
			trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
			mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
			-- Separator between context and content. Should be a single character string, like '-'.
			-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
			separator = nil,
			zindex = 20, -- The Z-index of the context window
			on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
		},
		config = function(_, opts)
			require("treesitter-context").setup(opts)

			vim.keymap.set("n", "<leader>tc", "<cmd>TSContextToggle<CR>", { noremap = true, silent = true })
		end,
	},
}
