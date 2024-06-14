return {
	"Wansmer/treesj",
	event = "BufRead",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local tsj = require("treesj")

		tsj.setup({
			use_default_keymaps = false,
		})

		vim.keymap.set("n", "<leader>xt", tsj.toggle, { desc = "Toggle split" })
		vim.keymap.set("n", "<leader>xT", function()
			tsj.toggle({ split = { recursive = true } })
		end, { desc = "Toggle split recursively" })
		vim.keymap.set("n", "<leader>xj", tsj.join, { desc = "Join" })
		vim.keymap.set("n", "<leader>xs", tsj.split, { desc = "Split" })
	end,
}
