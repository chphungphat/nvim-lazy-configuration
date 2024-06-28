return {
	"s1n7ax/nvim-window-picker",
	name = "window-picker",
	event = "VimEnter",
	config = function()
		require("window-picker").setup({
			selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
			filter_rules = {
				bo = {
					filetype = {
						"notify",
						"packer",
						"qf",
						"diff",
						"fugitive",
						"fugitiveblame",
						-- "fidget",
						-- "NeogitStatus",
						-- "copliot-chat",
						-- "TelescopePrompt",
						-- "NvimTree",
					},
					buftype = { "terminal" },
				},
			},

			highlights = {
				statusline = {
					focused = {
						fg = "#fabd2f",
						bg = "#b8bb26",
						bold = true,
					},
					unfocused = {
						fg = "#ebdbb2",
						bg = "#458588",
						bold = true,
					},
				},
				winbar = {
					focused = {
						fg = "#fabd2f",
						bg = "#b8bb26",
						bold = true,
					},
					unfocused = {
						fg = "#ebdbb2",
						bg = "#458588",
						bold = true,
					},
				},
			},
		})
	end,
}
