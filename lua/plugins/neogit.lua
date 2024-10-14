return {
	"NeogitOrg/neogit",
	event = { "ColorScheme" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"ibhagwan/fzf-lua",
	},
	config = function()
		local neogit = require("neogit")

		neogit.setup({
			integrations = {
				fzf_lua = true,
				diffview = true,
			},
		})

		vim.keymap.set("n", "<leader>gg", neogit.open, { silent = true, noremap = true })
	end,
}
