return {
	{
		"zbirenbaum/copilot.lua",
		dependencies = {
			"zbirenbaum/copilot-cmp",
		},
		cmd = "Copilot",
		event = "InsertEnter",
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
				},
			})

			------------------ Open Chat ---------------------------
			vim.api.nvim_set_keymap(
				"n",
				"<leader>caa",
				":CopilotChatOpen<CR>",
				{ noremap = true, silent = true, desc = "CopilotChat - Open" }
			)

			------------------Quick Chat with selected buffer ---------------
			local function quick_chat()
				local input = vim.fn.input("Quick Chat: ")
				if input ~= "" then
					require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
				end
			end
			_G.quick_chat = quick_chat
			vim.api.nvim_set_keymap(
				"n",
				"<leader>caq",
				":lua quick_chat()<CR>",
				{ noremap = true, silent = true, desc = "CopilotChat - Quick chat" }
			)

			------------------ Optimize selected buffer ---------------
			local function optimize_chat()
				vim.cmd("normal! ggVG")
				vim.cmd("CopilotChatOptimize")
			end
			_G.optimize_chat = optimize_chat
			vim.api.nvim_set_keymap(
				"n",
				"<leader>cao",
				":lua optimize_chat()<CR>",
				{ noremap = true, silent = true, desc = "CopilotChat - Optimize file" }
			)

			------------------ Review selected buffer ---------------
			local function review_chat()
				vim.cmd("normal! ggVG")
				vim.cmd("CopilotChatReview")
			end
			_G.review_chat = review_chat
			vim.api.nvim_set_keymap(
				"n",
				"<leader>car",
				":lua review_chat()<CR>",
				{ noremap = true, silent = true, desc = "CopilotChat - Review file" }
			)

			------------------ Fix selected buffer ---------------
			local function fix_chat()
				vim.cmd("normal! ggVG")
				vim.cmd("CopilotChatFix")
			end
			_G.fix_chat = fix_chat
			vim.api.nvim_set_keymap(
				"n",
				"<leader>cpf",
				":lua fix_chat()<CR>",
				{ noremap = true, silent = true, desc = "CopilotChat - Fix file" }
			)

			------------------ Explain selected buffer ---------------
			local function explain_chat()
				vim.cmd("normal! ggVG")
				vim.cmd("CopilotChatExplain")
			end
			_G.explain_chat = explain_chat
			vim.api.nvim_set_keymap(
				"n",
				"<leader>cae",
				":lua explain_chat()<CR>",
				{ noremap = true, silent = true, desc = "CopilotChat - Explain file" }
			)

			---------------------- Fix Diagnostic ----------------------
			vim.api.nvim_set_keymap(
				"n",
				"<leader>caf",
				":CopilotChatFixDiagnostic<CR>",
				{ noremap = true, silent = true, desc = "CopilotChat - Fix Diagnostic" }
			)
		end,
	},
}
