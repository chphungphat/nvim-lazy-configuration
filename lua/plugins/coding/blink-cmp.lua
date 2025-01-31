return {
	"saghen/blink.cmp",
	dependencies = {
		"folke/lazydev.nvim",
		"rafamadriz/friendly-snippets",
		"mikavilpas/blink-ripgrep.nvim",
		"giuxtaposition/blink-cmp-copilot",
		"onsails/lspkind.nvim",
		"echasnovski/mini.icons",
	},
	version = "*",
	opts = {
		keymap = {
			preset = "none",
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },

			["<C-Space>"] = { "show", "fallback" },

			["<C-g>"] = {
				function()
					require("blink-cmp").show({ providers = { "ripgrep" } })
				end,
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer", "lazydev", "ripgrep", "copilot" },

			providers = {

				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 98,
				},

				lsp = {
					name = "LSP",
					module = "blink.cmp.sources.lsp",
					score_offset = 100,
				},

				copilot = {
					name = "copilot",
					module = "blink-cmp-copilot",
					score_offset = 99,
					async = true,

					transform_items = function(_, items)
						local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
						local kind_idx = #CompletionItemKind + 1
						CompletionItemKind[kind_idx] = "Copilot"
						for _, item in ipairs(items) do
							item.kind = kind_idx
						end
						return items
					end,
				},

				ripgrep = {
					module = "blink-ripgrep",
					name = "Ripgrep",
					opts = {
						prefix_min_len = 3,

						context_size = 5,

						max_filesize = "1M",

						-- Specifies how to find the root of the project where the ripgrep
						-- search will start from.
						project_root_marker = ".git",

						-- The casing to use for the search in a format that ripgrep
						-- accepts. Defaults to "--ignore-case". See `rg --help` for all the
						-- available options ripgrep supports
						search_casing = "--ignore-case",

						additional_rg_options = {},

						-- When a result is found for a file whose filetype does not have a
						-- treesitter parser installed, fall back to regex based highlighting
						-- that is bundled in Neovim.
						fallback_to_regex_highlighting = true,

						-- Show debug information in `:messages` that can help in
						-- diagnosing issues with the plugin.
						debug = false,
					},

					transform_items = function(_, items)
						for _, item in ipairs(items) do
							item.labelDetails = {
								description = "(rg)",
							}
						end
						return items
					end,
				},
			},
		},

		completion = {
			-- Disable auto brackets
			accept = { auto_brackets = { enabled = false } },

			list = { selection = { preselect = false, auto_insert = false } },

			-- Show documentation when selecting a completion item
			documentation = { auto_show = true, auto_show_delay_ms = 100 },

			-- Display a preview of the selected item on the current line
			ghost_text = { enabled = true },

			menu = {
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", gap = 1, "kind" },
					},
					-- components = {
					-- 	kind_icon = {
					-- 		ellipsis = false,
					-- 		text = function(ctx)
					-- 			local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
					-- 			return kind_icon
					-- 		end,
					-- 		highlight = function(ctx)
					-- 			local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
					-- 			return hl
					-- 		end,
					-- 	},
					-- },
				},
			},
		},

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "normal",

			kind_icons = {
				Copilot = "",
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
	end,
}
