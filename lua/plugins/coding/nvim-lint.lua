-- Use LSP for linting instead, this plugin is too slow
if true then
	return {}
end
return {
	"mfussenegger/nvim-lint",
	dependencies = {
		"williamboman/mason.nvim",
	},
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			-- kotlin = { "ktlint" },
		}

		lint.linters.eslint_d = {
			cmd = "eslint_d",
			args = {
				"--format",
				"json",
				"--stdin",
				"--stdin-filename",
				function()
					return vim.api.nvim_buf_get_name(0)
				end,
			},
			stdin = true,
			stream = "stdout",
			ignore_exitcode = true,
			parser = require("lint.parser").from_json,
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({
			"BufEnter",
			"BufWritePost",
			"InsertLeave",
			-- "InsertChange",
			-- "TextChanged",
			-- "TextChangedI",
			-- "TextYankPost",
		}, {
			group = lint_augroup,
			callback = function()
				vim.defer_fn(function()
					lint.try_lint()
				end, 100)
			end,
		})

		vim.keymap.set("n", "<leader>fl", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })

		-- Disable auto fix linting on save because it's too slow

		-- local function fix_eslint()
		-- 	local bufnr = vim.api.nvim_get_current_buf()
		-- 	local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
		--
		-- 	if ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
		-- 		local eslint_config = lint.linters_by_ft[ft][1]
		-- 		local eslint_args = { "--fix", "--cache" }
		--
		-- 		vim.fn.jobstart(eslint_config .. " " .. table.concat(eslint_args, " ") .. " " .. vim.fn.expand("%"), {
		-- 			on_exit = function(_, code)
		-- 				if code == 0 then
		-- 					vim.cmd("edit")
		-- 				end
		-- 			end,
		-- 		})
		-- 	end
		-- end
		--
		-- vim.api.nvim_create_autocmd({
		-- 	"BufWritePost",
		-- }, {
		-- 	group = lint_augroup,
		-- 	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
		-- 	callback = fix_eslint,
		-- })
		--
		-- vim.keymap.set("n", "<leader>fL", function()
		-- 	lint.fix_eslint()
		-- end, { desc = "Fix eslint" })
	end,
}
