return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- "hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		"williamboman/mason-lspconfig.nvim",
		"stevearc/dressing.nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")
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
					vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
				end, opts)

				opts.desc = "Go to next error"
				keymap.set("n", "]e", function()
					vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
				end, opts)

				opts.desc = "Go to previous warning/hint"
				keymap.set("n", "[d", function()
					vim.diagnostic.goto_prev({
						severity = { min = vim.diagnostic.severity.HINT, max = vim.diagnostic.severity.WARN },
					})
				end, opts)

				opts.desc = "Go to next warning/hint"
				keymap.set("n", "]d", function()
					vim.diagnostic.goto_next({
						severity = { min = vim.diagnostic.severity.HINT, max = vim.diagnostic.severity.WARN },
					})
				end, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		-- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		-- for type, icon in pairs(signs) do
		-- 	local hl = "DiagnosticSign" .. type
		-- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		-- end

		for _, diag in ipairs({ "Error", "Warn", "Info", "Hint" }) do
			vim.fn.sign_define("DiagnosticSign" .. diag, {
				text = "",
				texthl = "DiagnosticSign" .. diag,
				linehl = "",
				numhl = "DiagnosticSign" .. diag,
			})
		end

		vim.diagnostic.config({
			signs = true,
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

		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,

			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,

			["ts_ls"] = function()
				lspconfig["ts_ls"].setup({
					capabilities = capabilities,
					commands = {
						OrganizeImports = {
							function()
								vim.lsp.buf.execute_command({
									command = "_typescript.organizeImports",
									arguments = { vim.api.nvim_buf_get_name(0) },
								})
							end,
							description = "Organize Imports",
						},
					},
					on_attach = function(client, bufnr)
						local opts = { noremap = true, silent = true, buffer = bufnr }

						vim.keymap.set("n", "<leader>oi", function()
							local params = {
								command = "_typescript.organizeImports",
								arguments = { vim.api.nvim_buf_get_name(0) },
							}

							client.request("workspace/executeCommand", params, function(err, _result, _ctx)
								if err then
									local msg = err.message or "Error organizing imports"
									vim.notify(msg, vim.log.levels.ERROR)
								else
									vim.notify("Imports organized", vim.log.levels.INFO)
								end
							end, bufnr)
						end, opts)
					end,
				})
			end,

			["bashls"] = function()
				lspconfig["bashls"].setup({
					capabilities = capabilities,
				})
			end,

			-- ["typos_lsp"] = function()
			-- 	lspconfig.typos_lsp.setup({
			-- 		capabilities = capabilities,
			-- 		init_options = {
			-- 			config = vim.fn.expand("~/.config/typos/typos.toml"),
			-- 			diagnosticSeverity = "warning",
			-- 			checkStrict = true,
			-- 		},
			-- 		settings = {
			-- 			diagnostics = {
			-- 				enabled = true,
			-- 			},
			-- 		},
			-- 		filetypes = { "*" },
			-- 	})
			-- end,
		})
	end,
}
