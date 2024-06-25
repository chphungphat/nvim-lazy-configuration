vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- vim.cmd([[
--   hi SpellBad   guisp=red gui=undercurl
--   hi SpellCap   guisp=blue gui=undercurl
--   hi SpellRare  guisp=magenta gui=undercurl
--   hi SpellLocal guisp=cyan gui=undercurl
-- ]])
