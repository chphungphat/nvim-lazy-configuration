return {
	"ThePrimeagen/harpoon",
	branch = "hapoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("harpoon").setup()
	end,
}
