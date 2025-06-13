return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>ff",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = { "n", "v" },
			desc = "Format file or range (in visual mode)",
		},
		{
			"<leader>F",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
				vim.cmd("write")
			end,
			mode = "n",
			desc = "Format and save",
		},
	},
	opts = {
		formatters_by_ft = {
			-- Lua
			lua = { "stylua" },

			-- Python
			python = { "isort", "black" },

			-- JavaScript/TypeScript
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },

			-- Web technologies
			html = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },

			-- Other languages
			sh = { "shfmt" },
			bash = { "shfmt" },
			rust = { "rustfmt" },
			go = { "gofmt", "goimports" },

			-- Fallbacks
			["*"] = { "codespell" }, -- Check spelling for all files
			["_"] = { "trim_whitespace", "trim_newlines" }, -- Clean up whitespace
		},

		formatters = {
			shfmt = {
				prepend_args = { "-i", "2", "-ci" }, -- Use 2 spaces and indent switch cases
			},
			prettier = {
				-- Use project's prettier config if available
				condition = function(self, ctx)
					local cwd = vim.fn.getcwd()
					local prettier_files = {
						".prettierrc",
						".prettierrc.json",
						".prettierrc.js",
						".prettierrc.cjs",
						".prettierrc.mjs",
						".prettierrc.yml",
						".prettierrc.yaml",
						".prettierrc.toml",
						"prettier.config.js",
						"prettier.config.cjs",
						"prettier.config.mjs",
					}

					for _, file in ipairs(prettier_files) do
						if vim.loop.fs_stat(cwd .. "/" .. file) then
							return true
						end
					end

					-- Check package.json for prettier config
					local package_json = cwd .. "/package.json"
					if vim.loop.fs_stat(package_json) then
						local ok, content = pcall(vim.fn.readfile, package_json)
						if ok and content then
							local json_str = table.concat(content, "\n")
							if json_str:find('"prettier"') then
								return true
							end
						end
					end

					return false
				end,
			},
			stylua = {
				-- Use project's stylua config if available
				condition = function(self, ctx)
					local cwd = vim.fn.getcwd()
					return vim.loop.fs_stat(cwd .. "/stylua.toml") or vim.loop.fs_stat(cwd .. "/.stylua.toml")
				end,
			},
		},

		-- Format options
		format_on_save = function(bufnr)
			-- Disable format on save for certain filetypes
			local ignore_filetypes = { "sql", "java" }
			if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
				return
			end

			-- Disable for files in certain directories
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			local ignore_paths = { "node_modules", ".git", "vendor", "target" }
			for _, path in ipairs(ignore_paths) do
				if bufname:match(path) then
					return
				end
			end

			-- Check file size (don't format very large files)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, bufname)
			if ok and stats and stats.size > max_filesize then
				return
			end

			return {
				timeout_ms = 1000,
				lsp_fallback = true,
				async = false,
			}
		end,

		notify_on_error = true,
		notify_no_formatters = false, -- Don't notify when no formatters are available
	},

	init = function()
		-- Set formatexpr for better integration
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		-- Create user command for formatting
		vim.api.nvim_create_user_command("Format", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			require("conform").format({ async = true, lsp_fallback = true, range = range })
		end, { range = true })
	end,
}
