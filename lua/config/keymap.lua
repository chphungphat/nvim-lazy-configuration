vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, { desc = "Go to previous Diagnostic message" })
vim.keymap.set("n", "]e", vim.diagnostic.goto_next, { desc = "Go to next Diagnostic message" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostic Error messages" })
vim.keymap.set("n", "<leader>ca", vim.diagnostic.setloclist, { desc = "Open diagnostic Quickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>gf", vim.cmd("git fetch"), { desc = "Git fetch" })
vim.keymap.set("n", "<leader>gp", vim.cmd("git push"), { desc = "Git push" })
vim.keymap.set("n", "<leader>gpl", vim.cmd("git pull"), { desc = "Git pull" })
vim.keymap.set("n", "<leader>ga", vim.cmd("git add ."), { desc = "Git add" })
vim.keymap.set("n", "<leader>gc", function()
	vim.ui.input({ prompt = "Commit message: " }, function(message)
		if message then
			vim.cmd('git commit -m "' .. message .. '"')
		end
	end)
end)
