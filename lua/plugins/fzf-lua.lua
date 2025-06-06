return {
	"ibhagwan/fzf-lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			global_resume = true,
			global_resume_query = true,
			winopts = {
				height = 0.85,
				width = 0.80,
				preview = {
					default = "bat",
					vertical = "down:45%",
					horizontal = "right:50%",
					layout = "horizontal",
					flip_columns = 100,
				},
				border = "rounded",
			},
			fzf_colors = true,
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "Search Keymaps" })
		vim.keymap.set("n", "<leader><leader>", fzf.files, { desc = "Search Files" })
		vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Search by Grep" })
		vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Search Diagnostics" })
		vim.keymap.set("n", "<leader>sb", fzf.buffers, { desc = "Search Buffers" })
		vim.keymap.set("n", "<leader>sh", fzf.help_tags, { desc = "Search Help Tags" })
		vim.keymap.set("n", "<leader>sm", fzf.marks, { desc = "Search Marks" })
		vim.keymap.set("n", "<leader>so", fzf.oldfiles, { desc = "Search Old Files" })
	end,
}
