return {
	"sainnhe/gruvbox-material",
	event = { "VimEnter", "ColorScheme" },
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.gruvbox_material_foreground = "mix"
		vim.g.gruvbox_material_background = "medium"
		vim.g.gruvbox_material_disable_italic_comment = 0
		vim.g.gruvbox_material_enable_italic = true
		vim.g.gruvbox_material_enable_bold = 1
		-- vim.cmd.colorscheme("gruvbox-material")

		vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3c3836" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fabd2f", bold = true })
	end,
}
