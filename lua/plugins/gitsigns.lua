return {
	"lewis6991/gitsigns.nvim",
	config = function()
		local scheme = vim.g.colors_name or "gruvbox-material"

		local palette = {
			["gruvbox-material"] = {
				add = "#a9b665",
				change = "#89b482",
				delete = "#ea6962",
				blame = "#d65d0e",
			},
			["kanagawa"] = {
				add = "#98BB6C",
				change = "#7AA89F",
				delete = "#FF5D62",
				blame = "#FFA066",
			},
		}

		local c = palette[scheme] or palette["gruvbox-material"]

		require("gitsigns").setup({
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 400,
				ignore_whitespace = false,
				virt_text_priority = 100,
				virt_text_hl_group = "GitSignsCurrentLineBlame",
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local map = function(mode, key, cmd, desc)
					vim.keymap.set(mode, key, cmd, { buffer = bufnr, silent = true, desc = desc })
				end

				-- Navigation
				map("n", "]h", function()
					if vim.wo.diff then
						return "]h"
					end
					vim.schedule(gs.next_hunk)
					return "<Ignore>"
				end, "Next Git Hunk")

				map("n", "[h", function()
					if vim.wo.diff then
						return "[h"
					end
					vim.schedule(gs.prev_hunk)
					return "<Ignore>"
				end, "Previous Git Hunk")

				-- GitSigns actions with "gs" prefix
				map("n", "gsb", gs.toggle_current_line_blame, "Toggle Line Blame")
				map("n", "gsB", gs.blame_line, "Blame Line (Full)")
				map("n", "gsr", gs.reset_hunk, "Reset Hunk")
				map("n", "gsR", gs.reset_buffer, "Reset Buffer")
				map("n", "gss", gs.stage_hunk, "Stage Hunk")
				map("n", "gsS", gs.stage_buffer, "Stage Buffer")
				map("n", "gsu", gs.undo_stage_hunk, "Undo Stage Hunk")
				map("n", "gsd", gs.diffthis, "Diff This")
				map("n", "gsD", function()
					gs.diffthis("~")
				end, "Diff Base")

				-- Visual mode selection
				map("v", "gss", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage Selection")
				map("v", "gsr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset Selection")
			end,
		})

		-- Apply theme highlights
		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = c.add })
		vim.api.nvim_set_hl(0, "GitSignsChange", { fg = c.change })
		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = c.delete })
		vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = c.blame, italic = true })

		-- Sync colors with colorscheme changes
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.schedule(function()
					local scheme = vim.g.colors_name or "gruvbox-material"
					local c = palette[scheme] or palette["gruvbox-material"]
					vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = c.add })
					vim.api.nvim_set_hl(0, "GitSignsChange", { fg = c.change })
					vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = c.delete })
					vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = c.blame, italic = true })
				end)
			end,
		})
	end,
}
