return {
	"s1n7ax/nvim-window-picker",
	name = "window-picker",
	config = function()
		require("window-picker").setup({
			selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
			show_prompt = false,
			filter_rules = {
				include_current_win = false,
				autoselect_one = true,
				bo = {
					filetype = { "neo-tree", "neo-tree-popup", "notify", "oil-preview", "copilot-chat" },
					buftype = { "terminal", "quickfix" },
				},
			},
			highlights = {
				statusline = {
					focused = {
						fg = "#5f8700",
						bg = "#2c2f27",
						bold = true,
					},
					unfocused = {
						fg = "#5f8700",
						bg = "#3c3f37",
						bold = true,
					},
				},
				winbar = {
					focused = {
						fg = "#5f8700",
						bg = "#2c2f27",
						bold = true,
					},
					unfocused = {
						fg = "#5f8700",
						bg = "#3c3f37",
						bold = true,
					},
				},
			},
		})
	end,
}
