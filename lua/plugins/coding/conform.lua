return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Format on demand
			"<leader>ff",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = { "n", "v" },
			desc = "Format file or range (in visual mode)",
		},
		{
			-- Format and save
			"<leader>F",
			function()
				vim.cmd("write")
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "n",
			desc = "Save and format",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			svelte = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			graphql = { "prettier" },
			liquid = { "prettier" },
			sql = { "sql-formatter" },
			sh = { "shfmt" },
			rust = { "rustfmt" },
			go = { "gofmt", "goimports" },
			["*"] = { "codespell" },
			["_"] = { "trim_whitespace", "trim_newlines" },
		},

		formatters = {
			shfmt = {
				prepend_args = { "-i", "2", "-ci" }, -- Use 2 spaces and indent switch cases
			},
			prettier = {
				-- Override defaults to not conflict with .prettierrc
				prepend_args = {},
			},
			sql_formatter = {
				prepend_args = { "--language", "postgresql" },
			},
		},

		-- Format options
		format_on_save = function(bufnr)
			local ignore_filetypes = { "sql", "liquid" }
			if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
				return
			end

			-- Check if file is in a node_modules or .git directory
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if bufname:match("node_modules") or bufname:match("%.git") then
				return
			end

			return {
				timeout_ms = 500,
				lsp_fallback = true,
				async = false,
			}
		end,

		notify_on_error = true,
		format_after_save = false, -- Don't format again after save
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
