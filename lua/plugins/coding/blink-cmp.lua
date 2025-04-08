return {
	"saghen/blink.cmp",
	dependencies = {
		"folke/lazydev.nvim",
		"rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",
		"onsails/lspkind.nvim",
		"echasnovski/mini.icons",
		-- "mikavilpas/blink-ripgrep.nvim",
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
		},

		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
				"lazydev",
				"copilot",
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
					name = "copilot",
					module = "blink-copilot",
					score_offset = 99,
					async = true,
					opts = {
						-- max_completions = 2,
						max_attempts = 2,
						kind = "Copilot",
						debounce = 1000,
					},

					-- transform_items = function(_, items)
					-- 	local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
					-- 	local kind_idx = #CompletionItemKind + 1
					-- 	CompletionItemKind[kind_idx] = "Copilot"
					-- 	for _, item in ipairs(items) do
					-- 		item.kind = kind_idx
					-- 	end
					-- 	return items
					-- end,
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
