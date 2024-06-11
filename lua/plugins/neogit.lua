return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("neogit").setup({
			integrations = {
				telescope = true,
				diffview = true,
			},
		})

		local neogit = require("neogit")

		vim.keymap.set("n", "<leader>gg", neogit.open, { silent = true, noremap = true })
	end,
}
