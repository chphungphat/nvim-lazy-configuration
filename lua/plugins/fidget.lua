return {
	"j-hui/fidget.nvim",
	opts = {
		progress = {
			suppress_on_insert = true,
			ignore_empty_message = true,
			display = {
				render_limit = 10,
			},
		},
		notification = {
			view = {
				stack_upwards = false,
				icon_separator = " ",
				group_separator = "---",
			},
			window = {
				winblend = 80,
				align = "top",
			},
		},
	},
}
