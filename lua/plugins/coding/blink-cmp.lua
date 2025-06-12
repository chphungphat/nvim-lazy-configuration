return {
	"saghen/blink.cmp",
	dependencies = {
		"folke/lazydev.nvim",
		-- "rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",
		"lspkind.nvim",
		"echasnovski/mini.icons",
	},
	-- Use latest stable version to avoid crashes
	version = "1.*", -- Use latest stable in 1.x series

	-- Force Lua implementation to avoid Rust-related crashes
	build = function()
		-- Disable prebuilt binaries for Ubuntu 25.04 compatibility
		return false
	end,

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
				-- "snippets",
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
					async = true, -- IMPORTANT: Enable async to prevent crashes

					-- Disable snippet support for TypeScript to prevent crashes
					-- Transform items to prevent TypeScript-related crashes
					transform_items = function(_, items)
						return vim.tbl_filter(function(item)
							-- Filter out problematic completion types that can cause crashes
							local kind = require("blink.cmp.types").CompletionItemKind

							-- Remove snippets and text completions
							if item.kind == kind.Text or item.kind == kind.Snippet then
								return false
							end

							-- Filter out problematic TypeScript completions
							if item.insertText then
								-- Remove completions with complex template strings
								if string.match(item.insertText, "%$%{") then
									return false
								end
								-- Remove completions with complex destructuring
								if string.match(item.insertText, "%{.*%}") and #item.insertText > 50 then
									return false
								end
							end

							-- Limit detail text length to prevent memory issues
							if item.detail and #item.detail > 200 then
								item.detail = string.sub(item.detail, 1, 200) .. "..."
							end

							return true
						end, items)
					end,

					opts = {
						tailwind_color_icon = "██",
						-- Reduce timeout to prevent hangs/crashes
						timeout_ms = 1000,
					},
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
					score_offset = 101,
					async = true, -- IMPORTANT: Enable async for copilot
					opts = {
						max_completions = 3,
						max_attempts = 4,
						kind_name = "Copilot",
						kind_icon = "",
						debounce = 200,
						auto_refresh = {
							backward = true,
							forward = true,
						},
					},
				},
			},
		},

		completion = {
			accept = {
				auto_brackets = { enabled = false }, -- Disable auto-brackets to prevent crashes
				resolve_timeout_ms = 50, -- Reduce timeout to prevent hangs
			},

			list = {
				selection = {
					preselect = false,
					auto_insert = false,
				},
			},

			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200, -- Increase delay to reduce crash frequency
			},

			ghost_text = { enabled = false }, -- Disable ghost text to prevent crashes

			menu = {
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", gap = 1, "kind" },
					},
					-- Disable treesitter highlighting to prevent crashes
					treesitter = {
						enabled = false,
					},
				},
			},

			keyword = {
				range = "full",
			},

			-- Reduce trigger sensitivity to prevent crashes
			trigger = {
				prefetch_on_insert = false, -- Disable prefetching to prevent crashes
				show_in_snippet = false,
				show_on_keyword = true,
				show_on_trigger_character = true,
				-- Reduce blocked characters that might cause issues
				show_on_x_blocked_trigger_characters = { " ", "\n", "\t" },
			},
		},

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "normal",

			kind_icons = {
				Copilot = "",
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

		-- Force Lua fuzzy matcher to avoid Rust-related crashes on Ubuntu 25.04
		fuzzy = {
			use_typo_resistance = true,
			use_frecency = true,
			use_proximity = true,
			-- Disable prebuilt binaries to force Lua implementation
			prebuilt_binaries = {
				download = false,
				force_version = nil,
			},
		},
	},
	opts_extend = { "sources.default" },
	config = function(_, opts)
		-- Add crash protection
		local ok, blink = pcall(require, "blink.cmp")
		if not ok then
			vim.notify("Failed to load blink.cmp: " .. tostring(blink), vim.log.levels.ERROR)
			return
		end

		blink.setup(opts)

		-- Crash protection for completion menu events
		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpCompletionMenuOpen",
			callback = function()
				local ok_menu = pcall(function()
					vim.b.copilot_suggestion_hidden = true
				end)
				if not ok_menu then
					vim.notify("Error in completion menu open", vim.log.levels.WARN)
				end
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpCompletionMenuClose",
			callback = function()
				local ok_menu = pcall(function()
					vim.b.copilot_suggestion_hidden = false
				end)
				if not ok_menu then
					vim.notify("Error in completion menu close", vim.log.levels.WARN)
				end
			end,
		})
	end,
}
