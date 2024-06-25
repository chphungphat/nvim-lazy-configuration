if true then
	return {}
end
return {
	"romgrk/barbar.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		vim.g.barbar_auto_setup = false

		require("barbar").setup({
			animation = false,
			clickable = true,
			no_name_title = "Buffer",
			exclude_ft = {
				"notify",
				"oil",
				"oil_preview",
				"copliot-chat",
				"fidget",
				"TelescopePrompt",
			},
		})

		local map = vim.api.nvim_set_keymap

		local function set_key(mode, key, cmd, desc)
			map(mode, key, cmd, { desc = desc, noremap = true, silent = true })
		end

		set_key("n", "H", "<cmd>BufferPrevious<CR>", "Previous buffer")
		set_key("n", "L", "<cmd>BufferNext<CR>", "Next buffer")
		set_key("n", "B", "<cmd>BufferClose<CR>", "Close buffer")
	end,
}
