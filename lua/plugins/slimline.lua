return {
	"sschleemilch/slimline.nvim",
	dependencies = {
		"echasnovski/mini.icons",
		"lewis6991/gitsigns.nvim",
	},
	config = function()
		-- Your current background is #121212
		local statusline_bg = "#1a1a1a" -- Subtle difference from #121212
		local statusline_bg_inactive = "#151515" -- Even more subtle for inactive statuslines

		-- First create our custom highlight groups
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				-- Create basic highlight groups

				-- Base statusline
				vim.api.nvim_set_hl(0, "StatusLine", { bg = statusline_bg })
				vim.api.nvim_set_hl(0, "StatusLineNC", { bg = statusline_bg_inactive })

				-- Mode highlights
				vim.api.nvim_set_hl(0, "SlimlineModeNormal", { fg = "#a9b665", bg = statusline_bg, bold = true })
				vim.api.nvim_set_hl(0, "SlimlineModeInsert", { fg = "#7daea3", bg = statusline_bg, bold = true })
				vim.api.nvim_set_hl(0, "SlimlineModeVisual", { fg = "#d3869b", bg = statusline_bg, bold = true })
				vim.api.nvim_set_hl(0, "SlimlineModeCommand", { fg = "#d8a657", bg = statusline_bg, bold = true })
			end,
		})

		-- Setup slimline
		vim.defer_fn(function()
			require("slimline").setup({
				bold = true, -- Enable bold for primary parts

				-- Use foreground style for contrast
				style = "fg",

				-- Component placement
				components = {
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

				-- Component configuration
				configs = {
					mode = {
						verbose = false, -- Mode as single letter
						hl = {
							-- String highlight group names
							normal = "SlimlineModeNormal",
							insert = "SlimlineModeInsert",
							pending = "SlimlineModeCommand",
							visual = "SlimlineModeVisual",
							command = "SlimlineModeCommand",
						},
					},
					path = {
						directory = true, -- Show directory
						icons = {
							folder = " ", -- Folder icon
							modified = "●", -- Modified indicator
							read_only = "", -- Read-only indicator
						},
					},
					git = {
						-- Using default colors but with more descriptive icons
						icons = {
							branch = "󰘬 ", -- or " " or " "
							added = "󰐕 ", -- or " " or "󰜄 "
							modified = "󰏫 ", -- or " " or "󱗝 "
							removed = "󰍴 ", -- or " " or "󰛲
						},
					},
					diagnostics = {
						workspace = false, -- Use buffer diagnostics for clarity
						-- Using default colors but with more descriptive icons
						icons = {
							ERROR = "󰅚 ", -- or "󰅙 " or " "
							WARN = "󰀪 ", -- or " " or " "
							INFO = "󰋽 ", -- or " " or " "
							HINT = "󰌶 ", -- or "󰛩 " or " "
						},
					},
					filetype_lsp = {},
					progress = {
						column = false,
						icon = "󰦪 ", -- Line number (alternative: "󰳧 " or "󰉶 ")
					},
					recording = {
						icon = "󰑊 ", -- Recording (alternative: "󰻃 " or "󰦜 ")
					},
				},

				-- Spacing for readability
				spaces = {
					components = " ",
					left = " ",
					right = " ",
				},

				-- Subtle separators
				sep = {
					hide = {
						first = false,
						last = false,
					},
					left = "", -- Left separator
					right = "", -- Right separator
				},

				-- Base highlights
				hl = {
					base = "StatusLine",
				},
			})
		end, 100) -- Small delay to ensure highlights are created first
	end,
}
