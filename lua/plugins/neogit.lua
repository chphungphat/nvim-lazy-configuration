return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"ibhagwan/fzf-lua",
	},
	config = function()
		require("neogit").setup({
			integrations = {
				fzf_lua = true,
				diffview = true,
			},
		})

		local neogit = require("neogit")

		vim.keymap.set("n", "<leader>gg", neogit.open, { silent = true, noremap = true })
	end,
}
