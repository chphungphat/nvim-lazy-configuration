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

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local bg = vim.g.colors_name == "gruvbox-material" and "#3c3836" or "#2a2a37"
		vim.api.nvim_set_hl(0, "CursorLine", { bg = bg })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fabd2f", bold = true })
	end,
})

vim.o.background = "dark"
