return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "antosha417/nvim-lsp-file-operations", config = true },
		"mason-org/mason-lspconfig.nvim",
		"stevearc/dressing.nvim",
	},
	config = function()
		local fzf = require("fzf-lua")

		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP references"
				keymap.set("n", "gr", fzf.lsp_references, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", fzf.lsp_definitions, opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", fzf.lsp_implementations, opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", fzf.lsp_typedefs, opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", function()
					vim.lsp.buf.code_action({
						-- This will use dressing.nvim for the code action menu
						context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() },
						apply = true,
					})
				end, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", fzf.diagnostics_document, opts)

				opts.desc = "Go to previous error"
				keymap.set("n", "[e", function()
					vim.diagnostic.jump({
						severity = vim.diagnostic.severity.ERROR,
						count = -1,
						float = true,
					})
				end, opts)

				opts.desc = "Go to next error"
				keymap.set("n", "]e", function()
					vim.diagnostic.jump({
						severity = vim.diagnostic.severity.ERROR,
						count = 1,
						float = true,
					})
				end, opts)

				opts.desc = "Go to previous warning/hint"
				keymap.set("n", "[d", function()
					vim.diagnostic.jump({
						severity = {
							min = vim.diagnostic.severity.HINT,
							max = vim.diagnostic.severity.WARN,
						},
						count = -1,
						float = true,
					})
				end, opts)

				opts.desc = "Go to next warning/hint"
				keymap.set("n", "]d", function()
					vim.diagnostic.jump({
						severity = {
							min = vim.diagnostic.severity.HINT,
							max = vim.diagnostic.severity.WARN,
						},
						count = 1,
						float = true,
					})
				end, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
				texthl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				},
				linehl = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				},
			},
			underline = true,
			update_in_insert = false,
			virtual_text = false,
			severity_sort = true,
		})

		---------------------------------------------------------------------
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local mason_lspconfig = require("mason-lspconfig")

		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		mason_lspconfig.setup({
			ensure_installed = {
				"ts_ls",
				"lua_ls",
				"marksman",
				"bashls",
				"vimls",
			},
			automatic_enable = true,
		})
	end,
}
