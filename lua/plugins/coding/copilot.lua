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
					enabled = false, -- Disable panel as we use blink.cmp integration
					auto_refresh = false,
				},
				suggestion = {
					enabled = false, -- Disable suggestions as we use blink.cmp integration
					auto_trigger = false,
				},
				filetypes = {
					-- Enable for specific filetypes
					lua = true,
					javascript = true,
					typescript = true,
					javascriptreact = true,
					typescriptreact = true,
					python = true,
					rust = true,
					go = true,
					java = true,
					c = true,
					cpp = true,
					markdown = true,
					yaml = true,
					json = true,
					html = true,
					css = true,
					scss = true,
					-- Disable for certain filetypes
					gitcommit = false,
					gitrebase = false,
					help = false,
					["."] = false,
					[""] = false,
				},
				copilot_node_command = "node", -- Use system node
				server_opts_overrides = {
					trace = "off", -- Reduce logging for performance
					settings = {
						advanced = {
							inlineSuggestCount = 3,
							length = 500, -- Allow longer suggestions
							listCount = 10, -- More suggestions for blink.cmp
						},
					},
				},
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			"zbirenbaum/copilot.lua",
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- For better UI selection
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		event = "VeryLazy",
		config = function()
			local chat = require("CopilotChat")

			chat.setup({
				debug = false,
				show_help = false,
				model = "gpt-4o-2024-11-20", -- Latest GPT-4o model
				agent = "copilot", -- Use official Copilot agent
				context = nil, -- Auto-detect context
				temperature = 0.1,

				-- Window configuration
				window = {
					layout = "vertical", -- or 'horizontal', 'float', 'replace'
					width = 0.4, -- 40% of screen width
					height = 0.8, -- 80% of screen height
					relative = "editor",
					border = "rounded",
					title = "Copilot Chat",
				},

				-- Selection configuration
				selection = function(source)
					local select = require("CopilotChat.select")
					return select.visual(source) or select.line(source)
				end,

				-- Prompts configuration
				prompts = {
					Explain = {
						prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
					},
					Review = {
						prompt = "/COPILOT_REVIEW Review the selected code.",
						callback = function(response, source)
							-- Add review to quickfix
							local lines = vim.split(response, "\n", { plain = true })
							local qf_entries = {}
							for i, line in ipairs(lines) do
								if line:match("^-") or line:match("^%+") then
									table.insert(qf_entries, {
										filename = source.filename or "",
										lnum = source.line_start or 1,
										col = 1,
										text = line,
									})
								end
							end
							if #qf_entries > 0 then
								vim.fn.setqflist(qf_entries, "r")
								vim.cmd("copen")
							end
						end,
					},
					Fix = {
						prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to fix the problem.",
					},
					Optimize = {
						prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readability.",
					},
					Docs = {
						prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.",
					},
					Tests = {
						prompt = "/COPILOT_GENERATE Please generate tests for my code.",
					},
					FixDiagnostic = {
						prompt = "Please assist with the following diagnostic issue in file:",
						selection = function(source)
							return require("CopilotChat.select").diagnostics(source)
						end,
					},
					Commit = {
						prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
						selection = function(source)
							return require("CopilotChat.select").gitdiff(source, true)
						end,
					},
					CommitStaged = {
						prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
						selection = function(source)
							return require("CopilotChat.select").gitdiff(source)
						end,
					},
				},

				-- Mappings
				mappings = {
					complete = {
						insert = "<Tab>",
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
						insert = "<C-s>",
					},
					accept_diff = {
						normal = "<C-y>",
						insert = "<C-y>",
					},
					yank_diff = {
						normal = "gy",
						register = '"',
					},
					show_diff = {
						normal = "gd",
					},
					show_info = {
						normal = "gi",
					},
					show_context = {
						normal = "gc",
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

			-- Chat commands with better organization
			map("n", "<leader>cco", ":CopilotChatOpen<CR>", { desc = "Open Copilot Chat" })
			map("n", "<leader>ccc", ":CopilotChatClose<CR>", { desc = "Close Copilot Chat" })
			map("n", "<leader>cct", ":CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })
			map("n", "<leader>ccr", ":CopilotChatReset<CR>", { desc = "Reset Copilot Chat" })

			-- Quick actions
			map("n", "<leader>cce", ":CopilotChatExplain<CR>", { desc = "Explain code" })
			map("n", "<leader>ccf", ":CopilotChatFix<CR>", { desc = "Fix code" })
			map("n", "<leader>ccv", ":CopilotChatReview<CR>", { desc = "Review code" })
			map("n", "<leader>cco", ":CopilotChatOptimize<CR>", { desc = "Optimize code" })
			map("n", "<leader>ccd", ":CopilotChatDocs<CR>", { desc = "Add documentation" })
			map("n", "<leader>cct", ":CopilotChatTests<CR>", { desc = "Generate tests" })

			-- Visual mode mappings
			map("v", "<leader>cce", ":CopilotChatExplain<CR>", { desc = "Explain selection" })
			map("v", "<leader>ccf", ":CopilotChatFix<CR>", { desc = "Fix selection" })
			map("v", "<leader>ccv", ":CopilotChatReview<CR>", { desc = "Review selection" })
			map("v", "<leader>cco", ":CopilotChatOptimize<CR>", { desc = "Optimize selection" })

			-- Diagnostics and commit helpers
			map("n", "<leader>ccx", ":CopilotChatFixDiagnostic<CR>", { desc = "Fix diagnostic" })
			map("n", "<leader>ccm", ":CopilotChatCommit<CR>", { desc = "Generate commit message" })
			map("n", "<leader>ccM", ":CopilotChatCommitStaged<CR>", { desc = "Generate staged commit message" })

			-- Quick chat with input
			map("n", "<leader>ccq", function()
				local input = vim.fn.input("Quick Chat: ")
				if input ~= "" then
					require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
				end
			end, { desc = "Quick chat" })

			-- Visual mode quick chat
			map("v", "<leader>ccq", function()
				local input = vim.fn.input("Quick Chat: ")
				if input ~= "" then
					require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
				end
			end, { desc = "Quick chat with selection" })
		end,
	},
}
