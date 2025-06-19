return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
		"ibhagwan/fzf-lua", -- optional
	},
	cmd = "Neogit", -- Load only when command is run
	keys = {
		{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
		{ "<leader>gs", "<cmd>Neogit kind=split<cr>", desc = "Open Neogit in split" },
		{ "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit commit" },
		{ "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Neogit pull" },
		{ "<leader>gP", "<cmd>Neogit push<cr>", desc = "Neogit push" },
	},
	opts = {
		-- Modern Neogit configuration
		graph_style = "ascii",
		-- Git settings
		git_services = {
			["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
			["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
			["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
		},

		-- Better telescope integration
		telescope_sorter = function()
			return require("telescope").extensions.fzf.native_fzf_sorter()
		end,

		-- Better remember state
		remember_settings = true,

		-- Auto settings
		auto_refresh = true,
		auto_show_console = true,

		-- Console timeout
		console_timeout = 2000,

		-- Disable context highlighting to prevent conflicts
		disable_context_highlighting = false,
		disable_signs = false,

		-- Signs
		signs = {
			hunk = { "", "" },
			item = { "▸", "▾" },
			section = { "▸", "▾" },
		},

		-- Integrations
		integrations = {
			telescope = true,
			diffview = true,
			fzf_lua = true,
		},

		-- Sections (same as original)
		sections = {
			untracked = {
				folded = false,
				hidden = false,
			},
			unstaged = {
				folded = false,
				hidden = false,
			},
			staged = {
				folded = false,
				hidden = false,
			},
			stashes = {
				folded = true,
				hidden = false,
			},
			unpulled_upstream = {
				folded = true,
				hidden = false,
			},
			unmerged_upstream = {
				folded = false,
				hidden = false,
			},
			unpulled_pushRemote = {
				folded = true,
				hidden = false,
			},
			unmerged_pushRemote = {
				folded = false,
				hidden = false,
			},
			recent = {
				folded = true,
				hidden = false,
			},
			rebase = {
				folded = true,
				hidden = false,
			},
		},

		-- Mappings (same as original)
		mappings = {
			commit_editor = {
				["q"] = "Close",
				["<c-c><c-c>"] = "Submit",
				["<c-c><c-k>"] = "Abort",
			},
			commit_editor_I = {
				["<c-c><c-c>"] = "Submit",
				["<c-c><c-k>"] = "Abort",
			},
			rebase_editor = {
				["p"] = "Pick",
				["r"] = "Reword",
				["e"] = "Edit",
				["s"] = "Squash",
				["f"] = "Fixup",
				["x"] = "Execute",
				["d"] = "Drop",
				["b"] = "Break",
				["q"] = "Close",
				["<cr>"] = "OpenCommit",
				["gk"] = "MoveUp",
				["gj"] = "MoveDown",
				["<c-c><c-c>"] = "Submit",
				["<c-c><c-k>"] = "Abort",
				["[c"] = "OpenOrScrollUp",
				["]c"] = "OpenOrScrollDown",
			},
			rebase_editor_I = {
				["<c-c><c-c>"] = "Submit",
				["<c-c><c-k>"] = "Abort",
			},
			finder = {
				["<cr>"] = "Select",
				["<c-c>"] = "Close",
				["<esc>"] = "Close",
				["<c-n>"] = "Next",
				["<c-p>"] = "Previous",
				["<down>"] = "Next",
				["<up>"] = "Previous",
				["<tab>"] = "MultiselectToggleNext",
				["<s-tab>"] = "MultiselectTogglePrevious",
				["<c-j>"] = "NOP",
			},
			popup = {
				["?"] = "HelpPopup",
				["A"] = "CherryPickPopup",
				["D"] = "DiffPopup",
				["M"] = "RemotePopup",
				["P"] = "PushPopup",
				["X"] = "ResetPopup",
				["Z"] = "StashPopup",
				["b"] = "BranchPopup",
				["c"] = "CommitPopup",
				["f"] = "FetchPopup",
				["l"] = "LogPopup",
				["m"] = "MergePopup",
				["p"] = "PullPopup",
				["r"] = "RebasePopup",
				["t"] = "TagPopup",
				["v"] = "RevertPopup",
				["w"] = "WorktreePopup",
			},
			status = {
				["q"] = "Close",
				["I"] = "InitRepo",
				["1"] = "Depth1",
				["2"] = "Depth2",
				["3"] = "Depth3",
				["4"] = "Depth4",
				["<tab>"] = "Toggle",
				["x"] = "Discard",
				["s"] = "Stage",
				["S"] = "StageUnstaged",
				["<c-s>"] = "StageAll",
				["u"] = "Unstage",
				["U"] = "UnstageStaged",
				["$"] = "CommandHistory",
				["Y"] = "YankSelected",
				["<c-r>"] = "RefreshBuffer",
				["<enter>"] = "GoToFile",
				["<c-v>"] = "VSplitOpen",
				["<c-x>"] = "SplitOpen",
				["<c-t>"] = "TabOpen",
				["{"] = "GoToPreviousHunkHeader",
				["}"] = "GoToNextHunkHeader",
				["[c"] = "OpenOrScrollUp",
				["]c"] = "OpenOrScrollDown",
			},
		},
	},

	config = function(_, opts)
		local neogit = require("neogit")
		neogit.setup(opts)

		-- Enhanced autocmds for better treesitter integration
		local group = vim.api.nvim_create_augroup("NeogitModern", { clear = true })

		-- Handle file opening from Neogit (modern approach)
		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = "NeogitPushComplete",
			callback = function()
				vim.notify("Push completed successfully!", vim.log.levels.INFO)
			end,
		})

		-- Better file handling when jumping from Neogit
		vim.api.nvim_create_autocmd("BufEnter", {
			group = group,
			callback = function(event)
				local buf = event.buf
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end

				-- Check if this is a file opened from Neogit
				local bufname = vim.api.nvim_buf_get_name(buf)
				if bufname and bufname ~= "" and not bufname:match("NeogitStatus") then
					-- Modern treesitter doesn't need manual intervention
					-- It handles highlighting automatically with async parsing

					-- Only refresh if there are actual display issues
					local lines = vim.api.nvim_buf_line_count(buf)
					if lines > 0 then
						-- Check if highlighting is working by looking for any highlights
						local has_highlights = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { limit = 1 })

						if #has_highlights == 0 and vim.bo[buf].filetype ~= "" then
							-- Only force refresh if absolutely necessary
							vim.defer_fn(function()
								if vim.api.nvim_buf_is_valid(buf) then
									-- Trigger filetype detection again
									vim.api.nvim_exec_autocmds("BufRead", { buffer = buf })
								end
							end, 50)
						end
					end
				end
			end,
		})

		-- Handle Neogit closing
		-- UPDATED: Updated the buffer pattern matching for neo-tree compatibility
		-- vim.api.nvim_create_autocmd("BufDelete", {
		-- 	group = group,
		-- 	pattern = "*NeogitStatus*",
		-- 	callback = function()
		-- 		-- Refresh all visible buffers if needed
		-- 		for _, win in ipairs(vim.api.nvim_list_wins()) do
		-- 			local buf = vim.api.nvim_win_get_buf(win)
		-- 			if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
		-- 				local ft = vim.bo[buf].filetype
		-- 				-- UPDATED: Check for neo-tree instead of NvimTree
		-- 				if ft and ft ~= "" and ft ~= "neo-tree" and ft ~= "neo-tree-popup" then
		-- 					-- Modern treesitter handles this automatically
		-- 					-- No manual intervention needed
		-- 				end
		-- 			end
		-- 		end
		-- 	end,
		-- })
	end,
}
