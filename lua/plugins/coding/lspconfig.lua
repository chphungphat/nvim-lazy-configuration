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

				opts.desc = "Organize imports"
				keymap.set("n", "<leader>oi", function()
					if
						vim.bo.filetype == "typescript"
						or vim.bo.filetype == "typescriptreact"
						or vim.bo.filetype == "javascript"
						or vim.bo.filetype == "javascriptreact"
					then
						local params = {
							command = "_typescript.organizeImports",
							arguments = { vim.api.nvim_buf_get_name(0) },
							title = "",
						}
						vim.lsp.buf_request_sync(0, "workspace/executeCommand", params, 1000)
					end
				end, opts)
			end,
		})

		-- Improved diagnostic configuration for stability
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
			},
			underline = true,
			update_in_insert = false, -- Don't update in insert mode to prevent crashes
			virtual_text = false, -- Disable virtual text to improve performance
			severity_sort = true,
			float = {
				border = "rounded",
				source = "if_many", -- Fixed type: should be "if_many" or boolean
				header = "",
				prefix = "",
			},
		})

		---------------------------------------------------------------------
		-- Configure capabilities based on which completion plugin is being used
		local capabilities
		local has_blink, blink = pcall(require, "blink.cmp")
		if has_blink then
			capabilities = blink.get_lsp_capabilities()
		else
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if has_cmp then
				capabilities = cmp_nvim_lsp.default_capabilities()
			else
				capabilities = vim.lsp.protocol.make_client_capabilities()
			end
		end

		-- Add folding capabilities
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		local mason_lspconfig = require("mason-lspconfig")

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

		-- Lua LSP configuration
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
					workspace = {
						checkThirdParty = false,
					},
				},
			},
		})

		-- TypeScript LSP configuration with crash prevention for Ubuntu 25.04
		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			init_options = {
				preferences = {
					-- Disable problematic features that can cause crashes
					disableSuggestions = false,
					quotePreference = "auto",
					includeCompletionsForModuleExports = false, -- Disable to prevent crashes
					includeCompletionsForImportStatements = false, -- Disable to prevent crashes
					includeCompletionsWithSnippetText = false, -- Disable snippets to prevent crashes
					allowIncompleteCompletions = false,
					-- Reduce completion details to prevent crashes
					providePrefixAndSuffixTextForRename = false,
					allowRenameOfImportPath = false,
					-- Additional safety settings for Ubuntu 25.04
					includeAutomaticOptionalChainCompletions = false,
					includeCompletionsWithClassMemberSnippets = false,
					includeCompletionsWithObjectLiteralMethodSnippets = false,
				},
			},
			settings = {
				typescript = {
					-- Disable inlay hints completely to reduce complexity
					inlayHints = {
						includeInlayParameterNameHints = "none",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = false,
						includeInlayVariableTypeHints = false,
						includeInlayPropertyDeclarationTypeHints = false,
						includeInlayFunctionLikeReturnTypeHints = false,
						includeInlayEnumMemberValueHints = false,
					},
					-- Reduce suggest settings to prevent problematic completions
					suggest = {
						completeFunctionCalls = false,
						includeCompletionsForModuleExports = false,
						includeAutomaticOptionalChainCompletions = false,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "none",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = false,
						includeInlayVariableTypeHints = false,
						includeInlayPropertyDeclarationTypeHints = false,
						includeInlayFunctionLikeReturnTypeHints = false,
						includeInlayEnumMemberValueHints = false,
					},
					suggest = {
						completeFunctionCalls = false,
						includeCompletionsForModuleExports = false,
						includeAutomaticOptionalChainCompletions = false,
					},
				},
			},
			-- Reduce timeout to prevent hangs
			timeout = 3000,
		})

		vim.lsp.config("bashls", {
			capabilities = capabilities,
		})

		-- Note: LSP handlers use default floating window settings
		-- Borders can be configured through vim.diagnostic.config() above

		-- Add comprehensive error protection for LSP completion on Ubuntu 25.04
		local original_completion = vim.lsp.handlers["textDocument/completion"]
		vim.lsp.handlers["textDocument/completion"] = function(err, result, ctx, config)
			if err then
				vim.notify("LSP completion error: " .. tostring(err), vim.log.levels.WARN)
				return
			end

			-- Comprehensive filtering for problematic completion items
			if result and result.items then
				result.items = vim.tbl_filter(function(item)
					-- Filter out items that commonly cause crashes
					if item.kind == 1 or item.kind == 15 then -- Text and Snippet
						return false
					end

					-- Filter out problematic insertText patterns
					if item.insertText then
						-- Remove template strings that can cause crashes
						if
							string.find(item.insertText, "^%$")
							or string.find(item.insertText, "%$%{")
							or string.find(item.insertText, "%${.*}")
						then
							return false
						end

						-- Remove very long completions that might cause memory issues
						if #item.insertText > 300 then
							return false
						end
					end

					-- Filter out problematic detail text
					if item.detail then
						-- Remove very long details
						if #item.detail > 500 then
							item.detail = string.sub(item.detail, 1, 200) .. "..."
						end
						-- Remove details with problematic characters
						if string.find(item.detail, "%$%{") then
							item.detail = "..."
						end
					end

					-- Filter out problematic documentation (with proper type handling)
					if item.documentation then
						if type(item.documentation) == "string" then
							-- Handle string documentation
							if #item.documentation > 1000 then
								item.documentation = string.sub(item.documentation, 1, 500) .. "..."
							end
						elseif
							type(item.documentation) == "table"
							and item.documentation.value
							and type(item.documentation.value) == "string"
						then
							-- Handle MarkupContent documentation
							if #item.documentation.value > 1000 then
								-- Create new table instead of modifying the field
								item.documentation = {
									kind = item.documentation.kind,
									value = string.sub(item.documentation.value, 1, 500) .. "...",
								}
							end
						end
					end

					return true
				end, result.items)

				-- Limit total number of items to prevent memory issues
				if #result.items > 50 then
					local limited_items = {}
					for i = 1, 50 do
						table.insert(limited_items, result.items[i])
					end
					result.items = limited_items
				end
			end

			-- Call original handler with protected call
			local ok, ret = pcall(original_completion, err, result, ctx, config)
			if not ok then
				vim.notify("Completion handler error: " .. tostring(ret), vim.log.levels.ERROR)
				return nil
			end
			return ret
		end
	end,
}
