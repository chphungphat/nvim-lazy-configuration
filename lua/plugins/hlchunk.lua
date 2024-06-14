return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("hlchunk").setup({
			indent = {
				enable = true,
				priority = 10,
				chars = {
					"│",
				},
			},
			chunk = {
				enable = true,
				priority = 15,
				chars = {
					horizontal_line = "─",
					vertical_line = "│",
					left_top = "┌",
					left_bottom = "└",
					right_arrow = "─",
				},
				style = "#d47d26",
				duration = 50,
				delay = 75,
			},
		})
	end,
}
