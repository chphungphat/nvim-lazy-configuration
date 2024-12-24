return {
	"OXY2DEV/markview.nvim",
	event = { "BufReadPost", "BufNewFile" },
	ft = "markdown",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("markview").setup({
			initial_state = false,
		})
		vim.keymap.set("n", "<leader>md", "<cmd>:Markview toggleAll<CR>", { desc = "Toggle Markview" })
		vim.keymap.set("n", "<leader>mq", "<cmd>:Markview splitToggle<CR>", { desc = "Split Toggle Markview" })
	end,
}
