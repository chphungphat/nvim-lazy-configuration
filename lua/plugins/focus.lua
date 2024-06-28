return {
	"nvim-focus/focus.nvim",
	version = false,
	config = function()
		require("focus").setup({
			enable = false,
			commands = true,
			ui = {
				number = true,
				relativenumber = false,
				hybridnumber = false,
				absolutenumber_unfocussed = false,

				cursorline = true,
				cursorcolumn = false,
				colorcolumn = {
					enable = false,
					list = "+1",
				},
				signcolumn = true,
				winhighlight = false,
			},
		})
	end,
}
