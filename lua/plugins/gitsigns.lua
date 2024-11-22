return {
	"lewis6991/gitsigns.nvim",
	config = function()
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
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 400,
				ignore_whitespace = false,
				virt_text_priority = 100,
				virt_text_hl_group = "GitSignsCurrentLineBlame",
			},
			current_line_blame_formatter = "<author>, <author_time:%d-%m-%Y> - <summary>",

			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, key, cmd, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, key, cmd, opts)
				end

				map("n", "]h", function()
					if vim.wo.diff then
						return "]h"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "[h", function()
					if vim.wo.diff then
						return "[h"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "<leader>hr", gs.reset_hunk)
				map("n", "<leader>hR", gs.reset_buffer)
				map("n", "<leader>gb", gs.toggle_current_line_blame)
			end,
		})

		vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#d65d0e", italic = true })

		-- Apply the custom highlight to the virtual text
		vim.cmd([[
     augroup GitSignsCustomHighlight
        autocmd!
        autocmd ColorScheme * highlight GitSignsCurrentLineBlame guifg=#d65d0e gui=italic
      augroup END
    ]])
	end,
}
