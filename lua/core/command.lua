vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.cmd([[
  augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
  augroup END
]])

vim.o.background = "dark"
