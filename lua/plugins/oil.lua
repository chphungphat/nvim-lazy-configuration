return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			win_options = {
				wrap = false,
				signcolumn = "yes",
			},
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-s>"] = false,
				["<C-h>"] = false,
				["<C-t>"] = false,
				["<C-p>"] = "actions.preview",
				["<C-c>"] = "actions.close",
				["<C-l>"] = false,
				["<F5>"] = "actions.refresh",
				["-"] = false,
				["<BS>"] = "actions.parent",
				["_"] = false,
				["`"] = false,
				["~"] = false,
				["gs"] = false,
				["gx"] = false,
				["g."] = false,
				["g\\"] = false,
			},
			use_default_keymaps = true,
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
				natural_order = true,
				is_always_hidden = function(name, _)
					return name == ".." or name == ".git"
				end,
			},
		})

		vim.keymap.set("n", "<leader>op", "<cmd>Oil<CR>", { desc = "Open Oil" })
	end,
}
