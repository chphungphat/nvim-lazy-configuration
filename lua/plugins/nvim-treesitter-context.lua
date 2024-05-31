return {
	"nvim-treesitter/nvim-treesitter-context",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		enable = true,
		max_lines = 0,
		min_window_height = 10,
		line_numbers = true,
		multiline_threshold = 20,
		trim_scope = "inner",
		mode = "cursor",
		separator = nil,
		zindex = 20,
		on_attach = nil,
	},
	config = function(_, opts)
		require("treesitter-context").setup(opts)
	end,
}
