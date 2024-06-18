if true then
	return {}
end
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			window = {
				position = "float",
			},
		})

		vim.keymap.set("n", "<C-t>", "<cmd>Neotree<CR>", { desc = "Toggle NeoTree" })
	end,
}
