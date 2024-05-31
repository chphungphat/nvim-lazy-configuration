return {
	"stevearc/dressing.nvim",
	opts = {
		input = {
			default_prompt = "Input",
			border = "rounded",
			relative = "win",

			prefer_width = 40,
			width = nil,
			max_width = { 140, 0.9 },
			min_width = { 20, 0.2 },

			buf_options = {},
			win_options = {
				wrap = false,
				list = true,
				listchars = "precedes:…,extends:…",
				sidescrolloff = 0,
			},

			mappings = {
				n = {
					["<Esc>"] = "Close",
					["<CR>"] = "Confirm",
				},
				i = {
					["<C-c>"] = "Close",
					["<CR>"] = "Confirm",
					["<Up>"] = "HistoryPrev",
					["<Down>"] = "HistoryNext",
				},
			},

			-- see :help dressing_get_config
			get_config = nil,
		},
		select = {
			backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

			fzf = {
				window = {
					width = 0.5,
					height = 0.4,
				},
			},

			fzf_lua = {
				-- winopts = {
				--   height = 0.5,
				--   width = 0.5,
				-- },
			},

			nui = {
				position = "50%",
				size = nil,
				relative = "editor",
				border = {
					style = "rounded",
				},
				buf_options = {
					swapfile = false,
					filetype = "DressingSelect",
				},
				win_options = {
					winblend = 0,
				},
				max_width = 80,
				max_height = 40,
				min_width = 40,
				min_height = 10,
			},

			builtin = {
				show_numbers = true,
				border = "rounded",
				relative = "editor",

				buf_options = {},
				win_options = {
					cursorline = true,
					cursorlineopt = "both",
				},

				width = nil,
				max_width = { 140, 0.8 },
				min_width = { 40, 0.2 },
				height = nil,
				max_height = 0.9,
				min_height = { 10, 0.2 },

				mappings = {
					["<Esc>"] = "Close",
					["<C-c>"] = "Close",
					["<CR>"] = "Confirm",
				},
			},

			-- Used to override format_item. See :help dressing-format
			format_item_override = {},

			-- see :help dressing_get_config
			get_config = nil,
		},
	},
	config = function(_, opts)
		require("dressing").setup(opts)
	end,
}
