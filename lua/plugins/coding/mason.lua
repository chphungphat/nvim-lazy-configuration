return {
	"williamboman/mason.nvim",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"isort",
				-- "black",
				-- "pylint",
				"eslint-lsp",
				-- "eslint_d",
			},
		})

		vim.keymap.set("n", "<leader>mm", "<cmd>Mason<CR>", { noremap = true, silent = true })
	end,
}
