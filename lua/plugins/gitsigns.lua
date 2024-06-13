return {
	"lewis6991/gitsigns.nvim",
	opts = {
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
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 400,
			ignore_whitespace = false,
			virt_text_priority = 100,
		},
		current_line_blame_formatter = "<author>, <author_time:%d-%m-%Y> - <summary>",
		current_line_blame_formatter_opts = {
			relative_time = true,
		},
		on_attach = function(buffer)
			local gs = package.loaded.gitsigns

			local function map(mode, key, fn, desc)
				vim.keymap.set(mode, key, fn, { buffer = buffer, desc = desc })
			end

			map("n", "<leader>gT", gs.toggle_current_line_blame, "Toggle current line blame")
		end,
	},
}
