return {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		---@diagnostic disable-next-line
		require("nvim-surround").setup({
			keymaps = {
				insert = false,
				insert_line = false,
				normal = "s",
				normal_cur = "ss",
				normal_line = "S",
				normal_cur_line = "SS",
				visual = "S",
				visual_line = "gS",
				delete = "ds",
				change = "cs",
				change_line = "cS",
			},
		})
	end,
}
