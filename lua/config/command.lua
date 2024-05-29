vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight text when yanking",
	group = vim.api.nvim_create_autogroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
