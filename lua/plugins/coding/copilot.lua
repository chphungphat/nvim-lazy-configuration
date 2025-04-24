return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		dependencies = {
			"windwp/nvim-autopairs",
		},
		config = function()
			require("copilot").setup({
				panel = {
					enabled = false,
					auto_refresh = true,
					layout = {
						position = "bottom",
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = false,
					auto_trigger = false,
					debounce = 100,
					keymap = {
						accept = "<M-l>",
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				filetypes = {
					markdown = true,
					help = false,
					gitcommit = false,
					gitrebase = false,
					["."] = false,
					[""] = false,
				},
				copilot_node_command = "node",
				server_opts_overrides = {
					advanced = {
						inlineSuggestCount = 3,
						length = 100,
					},
				},
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		event = "VeryLazy",
		dependencies = {
			"zbirenbaum/copilot.lua",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")

			chat.setup({
				debug = false,
				show_help = false,
				model = "claude-3.7-sonnet-thought",
				-- window = {
				-- 	width = 0.8,
				-- 	height = 0.8,
				-- 	row = 0.1,
				-- 	col = 0.1,
				-- },
				-- agent = "agentic-search",
				mappings = {
					complete = {
						insert = "<C-x>",
					},
					close = {
						normal = "q",
						insert = "<C-c>",
					},
					reset = {
						normal = "<C-r>",
						insert = "<C-r>",
					},
					submit_prompt = {
						normal = "<CR>",
						insert = "<C-CR>",
					},
				},
			})

			-- Keymaps helper
			local function map(mode, lhs, rhs, opts)
				opts = opts or {}
				opts.noremap = true
				opts.silent = true
				vim.keymap.set(mode, lhs, rhs, opts)
			end

			-- Chat commands
			local chat_commands = {
				{ key = "<leader>cpp", cmd = ":CopilotChatOpen<CR>", desc = "Open Chat" },
				{ key = "<leader>cpt", cmd = ":CopilotChatTests<CR>", desc = "Generate Tests" },
				{ key = "<leader>cpr", cmd = ":CopilotChatReview<CR>", desc = "Review Code" },
			}

			-- Buffer operations
			local buffer_commands = {
				{
					key = "<leader>cpo",
					fn = function()
						vim.cmd("normal! ggVG")
						vim.cmd("CopilotChatOptimize")
					end,
					desc = "Optimize Buffer",
				},
				{
					key = "<leader>cpf",
					fn = function()
						vim.cmd("normal! ggVG")
						vim.cmd("CopilotChatFix")
					end,
					desc = "Fix Buffer",
				},
				{
					key = "<leader>cpe",
					fn = function()
						vim.cmd("normal! ggVG")
						vim.cmd("CopilotChatExplain")
					end,
					desc = "Explain Buffer",
				},
			}

			-- Quick chat with input
			local function quick_chat()
				local input = vim.fn.input("Quick Chat: ")
				if input ~= "" then
					chat.ask(input, { selection = select.buffer })
				end
			end

			-- Register normal mode commands
			for _, cmd in ipairs(chat_commands) do
				map("n", cmd.key, cmd.cmd, { desc = cmd.desc })
			end

			for _, cmd in ipairs(buffer_commands) do
				map("n", cmd.key, cmd.fn, { desc = cmd.desc })
			end

			map({ "n" }, "<leader>cpq", quick_chat, { desc = "Quick Chat" })

			-- Visual mode mappings
			map("v", "<leader>cpo", ":CopilotChatOptimize<CR>", { desc = "Optimize Selection" })
			map("v", "<leader>cpf", ":CopilotChatFix<CR>", { desc = "Fix Selection" })
			map("v", "<leader>cpe", ":CopilotChatExplain<CR>", { desc = "Explain Selection" })
			map(
				"v",
				"<leader>cpq",
				":<C-u>lua require('CopilotChat').ask(vim.fn.input('Quick Chat: '), { selection = require('CopilotChat.select').visual })<CR>",
				{ desc = "Quick Chat (Visual)" }
			)
		end,
	},
}
