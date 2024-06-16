if true then
	return {}
end
return {
	"simonmclean/triptych.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("triptych").setup({
			mappings = {
				show_help = "g?",
				jump_to_cwd = ".", -- Pressing again will toggle back
				nav_left = "h",
				nav_right = { "l", "<CR>" }, -- If target is a file, opens the file in-place
				open_hsplit = { "-" },
				open_vsplit = { "|" },
				open_tab = { "<C-t>" },
				cd = "<leader>cd",
				delete = "d",
				add = "a",
				copy = "c",
				rename = "r",
				cut = "x",
				paste = "p",
				quit = "q",
				toggle_hidden = "<leader>.",
			},
			extension_mappings = {
				["<C-f>"] = {
					mode = "n",
					fn = function(target, _)
						require("telescope.builtin").live_grep({ search_dirs = { target.path } })
					end,
				},
			},
		})

		vim.keymap.set("n", "<leader>t", "<cmd>Triptych<CR>", { desc = "Toggle Triptych", silent = true })
	end,
}
