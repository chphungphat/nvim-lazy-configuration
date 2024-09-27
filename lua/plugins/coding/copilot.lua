return {
	{
		"zbirenbaum/copilot.lua",
		dependencies = {
			"zbirenbaum/copilot-cmp",
		},
		cmd = "Copilot",
		event = "BufEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
			require("copilot_cmp").setup()
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		event = "BufEnter",
		dependencies = {
			"zbirenbaum/copilot.lua",
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("CopilotChat.integrations.cmp").setup()
			require("CopilotChat").setup({
				mappings = {
					complete = {
						insert = "",
					},
					reset = {
						normal = "<C-r>",
						insert = "<C-r>",
					},
				},
			})

			local function map(mode, lhs, rhs, opts)
				opts = opts or {}
				opts.noremap = true
				opts.silent = true
				vim.keymap.set(mode, lhs, rhs, opts)
			end

			-- Open Chat
			map("n", "<leader>cpp", ":CopilotChatOpen<CR>", { desc = "CopilotChat - Open" })

			-- Quick Chat with selected buffer
			local function quick_chat()
				local input = vim.fn.input("Quick Chat: ")
				if input ~= "" then
					require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
				end
			end
			map({ "n", "v" }, "<leader>cpq", quick_chat, { desc = "CopilotChat - Quick chat" })

			-- Optimize selected buffer
			local function optimize_chat()
				vim.cmd("normal! ggVG")
				vim.cmd("CopilotChatOptimize")
			end
			map("n", "<leader>cpo", optimize_chat, { desc = "CopilotChat - Optimize file" })

			-- Fix selected buffer
			local function fix_chat()
				vim.cmd("normal! ggVG")
				vim.cmd("CopilotChatFix")
			end
			map("n", "<leader>cpf", fix_chat, { desc = "CopilotChat - Fix file" })

			-- Explain selected buffer
			local function explain_chat()
				vim.cmd("normal! ggVG")
				vim.cmd("CopilotChatExplain")
			end

			map("n", "<leader>cpe", explain_chat, { desc = "CopilotChat - Explain file" })

			-- Fix Diagnostic
			map("n", "<leader>cpd", ":CopilotChatFixDiagnostic<CR>", { desc = "CopilotChat - Fix Diagnostic" })

			-- Visual mode mappings
			map(
				"v",
				"<leader>cpq",
				":<C-u>lua require('CopilotChat').ask(vim.fn.input('Quick Chat: '), { selection = require('CopilotChat.select').visual })<CR>",
				{ desc = "CopilotChat - Quick chat (Visual)" }
			)
			map("v", "<leader>po", ":CopilotChatOptimize<CR>", { desc = "CopilotChat - Optimize selection" })
			map("v", "<leader>pf", ":CopilotChatFix<CR>", { desc = "CopilotChat - Fix selection" })
			map("v", "<leader>pe", ":CopilotChatExplain<CR>", { desc = "CopilotChat - Explain selection" })
		end,
	},
	{
		"AndreM222/copilot-lualine",
	},
}
