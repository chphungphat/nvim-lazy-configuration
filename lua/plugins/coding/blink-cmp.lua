return {
	"saghen/blink.cmp",
	dependencies = {
		"folke/lazydev.nvim",
		"rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",
		"lspkind.nvim",
		"echasnovski/mini.icons",
		"mikavilpas/blink-ripgrep.nvim",
	},
	version = "1.*",
	opts = {
		keymap = {
			preset = "none",
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-Space>"] = { "show", "fallback" },
		},

		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
				"lazydev",
				"copilot",
				"ripgrep",
			},

			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 98,
				},

				lsp = {
					name = "LSP",
					module = "blink.cmp.sources.lsp",
					fallbacks = { "buffer" },
					async = true,

					transform_items = function(_, items)
						return vim.tbl_filter(function(item)
							return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
						end, items)
					end,

					opts = { tailwind_color_icon = "██" },
					score_offset = 100,
				},

				path = {
					module = "blink.cmp.sources.path",
					fallbacks = { "buffer" },
					opts = {
						trailing_slash = true,
						label_trailing_slash = true,
						get_cwd = function(context)
							return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
						end,
						show_hidden_files_by_default = false,
					},
					score_offset = 90,
				},

				copilot = {
					name = "Copilot",
					module = "blink-copilot",
					score_offset = 99,
					async = true,
					opts = {
						max_completions = 3,
						max_attempts = 4,
						kind_name = "Copilot",
						kind_icon = "",
						debounce = 200,
						auto_refresh = {
							backward = true,
							forward = true,
						},
					},
				},

				ripgrep = {
					module = "blink-ripgrep",
					name = "Ripgrep",
					score_offset = 99,
					opts = {
						prefix_min_len = 3,
						context_size = 5,
						max_filesize = "1M",
						project_root_marker = ".git",
						search_casing = "--ignore-case",
						fallback_to_regex_highlighting = true,
						debug = false,
					},
					transform_items = function(_, items)
						for _, item in ipairs(items) do
							item.labelDetails = { description = "(rg)" }
						end
						return items
					end,
				},
			},
		},

		completion = {
			accept = { auto_brackets = { enabled = false } },

			list = { selection = { preselect = false, auto_insert = false } },

			documentation = {
				auto_show = true,
				auto_show_delay_ms = 100,
			},

			ghost_text = { enabled = true },

			menu = {
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", gap = 1, "kind" },
					},
					treesitter = {
						enabled = true,
						sources = { "lsp", "buffer", "path" },
					},
				},
			},

			keyword = {
				range = "full",
			},
		},

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "normal",

			kind_icons = {
				Copilot = "",
				Text = "󰉿",
				Method = "󰊕",
				Function = "󰊕",
				Constructor = "󰒓",
				Field = "󰜢",
				Variable = "󰆦",
				Property = "󰖷",
				Class = "󱡠",
				Interface = "󱡠",
				Struct = "󱡠",
				Module = "󰅩",
				Unit = "󰪚",
				Value = "󰦨",
				Enum = "󰦨",
				EnumMember = "󰦨",
				Keyword = "󰻾",
				Constant = "󰏿",
				Snippet = "󱄽",
				Color = "󰏘",
				File = "󰈔",
				Reference = "󰬲",
				Folder = "󰉋",
				Event = "󱐋",
				Operator = "󰪚",
				TypeParameter = "󰬛",
			},
		},
	},
	opts_extend = { "sources.default" },
	config = function(_, opts)
		require("blink.cmp").setup(opts)

		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpCompletionMenuOpen",
			callback = function()
				vim.b.copilot_suggestion_hidden = true
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpCompletionMenuClose",
			callback = function()
				vim.b.copilot_suggestion_hidden = false
			end,
		})
	end,
}
