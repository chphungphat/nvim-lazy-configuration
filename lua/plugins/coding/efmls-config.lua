-- if true then return {} end
return {
	"creativenull/efmls-configs-nvim",
	version = "v1.x.x",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	config = function()
		local eslint = require("efmls-configs.linters.eslint")
    local eslint_d = require("efmls-configs.linters.eslint_d")
		local prettier = require("efmls-configs.formatters.prettier")
		local stylua = require("efmls-configs.formatters.stylua")
		-- Register linters and formatters per language
		local languages = {
			typescript = { eslint, prettier },
			lua = { stylua },
		}

		-- Or use the defaults provided by this plugin
		-- check doc/SUPPORTED_LIST.md for the supported languages
		--
		-- local languages = require('efmls-configs.defaults').languages()

		local efmls_config = {
			filetypes = vim.tbl_keys(languages),
			settings = {
				rootMarkers = { ".git/" },
				languages = languages,
			},
			init_options = {
				documentFormatting = true,
				documentRangeFormatting = true,
			},
		}

		require("lspconfig").efm.setup(vim.tbl_extend("force", efmls_config, {
			-- Pass your custom lsp config below like on_attach and capabilities
			--
			-- on_attach = on_attach,
			-- capabilities = capabilities,
		}))

		local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = lsp_fmt_group,
			callback = function(ev)
				local efm = vim.lsp.get_active_clients({ name = "efm", bufnr = ev.buf })

				if vim.tbl_isempty(efm) then
					return
				end

				vim.lsp.buf.format({ name = "efm" })
			end,
		})
	end,
}
