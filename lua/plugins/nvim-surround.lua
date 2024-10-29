return {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		---@diagnostic disable-next-line
		require("nvim-surround").setup({
			keymaps = {
				insert = "<C-g>s",
				insert_line = "<C-g>S",
				normal = "ys",
				normal_cur = "yss",
				normal_line = "yS",
				normal_gcur_gline = "ySS",
				visual = "S",
				visual_line = "gS",
				delete = "ds",
				change = "cs",
				change_line = "cS",
			},
		})
	end,
}
