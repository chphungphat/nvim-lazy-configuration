return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local colorscheme = vim.g.colors_name

		local styleColors = {
			gruvbox = "#d47d26",
			-- bamboo = "#8ac6d1",
			-- bamboo =  "#a5dee5",
			bamboo = "#4b9e99",
			-- bamboo =  "#7fc8a9",
			-- bamboo = "#6ab78a",
		}
		local styleColor = styleColors[colorscheme]
		require("hlchunk").setup({
			indent = {
				enable = true,
				priority = 10,
				chars = {
					"┊",
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
				style = styleColor,
				duration = 50,
				delay = 75,
			},
		})
	end,
}
