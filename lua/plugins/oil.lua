return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		win_options = {
			wrap = false,
			signcolumn = "yes",
			cursorcolumn = false,
			foldcolumn = "0",
			spell = false,
			list = false,
			conceallevel = 3,
			concealcursor = "nvic",
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
		view_options = {
			show_hidden = false,
			natural_order = true,
			sort = {
				{ "type", "asc" },
				{ "name", "asc" },
			},
		},
	},
	config = function(_, opts)
		require("oil").setup(opts)
		vim.keymap.set("n", "<leader>op", "<cmd>Oil<CR>", { desc = "Open Oil" })
	end,
}
