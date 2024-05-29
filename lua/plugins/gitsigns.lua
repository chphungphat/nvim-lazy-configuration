return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "🗙" },
			topdelete = { text = "🗙" },
			changedelete = { text = "▎" },
			untracked = { text = "┆" },
		},
		current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 500,
			ignore_whitespace = false,
			virt_text_priority = 100,
		},
		on_attach = function(buffer)
			local gs = package.loaded.gitsigns

			local function map(mode, key, fn, desc)
				vim.keymap.set(mode, key, fn, { buffer = buffer, desc = desc })
			end

			map("n", "<leader>gb", gs.blame_line({ full = true }), "Blame line")

			map("n", "<leader>gd", gs.diffthis, "Diff this")
		end,
	},
}
