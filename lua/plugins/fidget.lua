return {
	"j-hui/fidget.nvim",
	config = function()
		require("fidget").setup({
			notification = {
				poll_rate = 10,
				filter = vim.log.levels.INFO,
				history_size = 128,
				override_vim_notify = true,

				view = {
					stack_upwards = true,
					icon_separator = " ",
					group_separator = "---",
					group_separator_hl = "Comment",
					render_message = function(msg, cnt)
						return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
					end,
				},

				window = {
					normal_hl = "Comment",
					winblend = 100,
					border = "none",
					zindex = 45,
					max_width = 0,
					max_height = 0,
					x_padding = 1,
					y_padding = 0,
					align = "top",
					relative = "editor",
				},
			},
		})
	end,
}
