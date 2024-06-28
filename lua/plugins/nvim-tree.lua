return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			view = {
				adaptive_size = true,
				width = {
					min = 30,
					max = 100,
				},
			},
			sort = {
				sorter = "name",
				folders_first = true,
				files_first = false,
			},
			renderer = {
				special_files = {
					"Cargo.toml",
					"Makefile",
					"README.md",
					"readme.md",
					"package.json",
				},
				icons = {
					git_placement = "after",
				},
			},
			actions = {
				open_file = {
					window_picker = {
						enable = true,
						picker = function()
							-- Use a custom picker function
							local picked_window_id = require("window-picker").pick_window()

							-- If no window is picked, use the current window
							return picked_window_id or vim.api.nvim_get_current_win()
						end,
					},
				},
				change_dir = {
					enable = false,
					global = false,
				},
			},
		})

		local tree_api = require("nvim-tree.api")

		-- Toggle NvimTree
		local nvimTreeFocusOrToggle = function()
			local nvimTree = require("nvim-tree.api")
			local currentBuf = vim.api.nvim_get_current_buf()
			local currentBufFt = vim.api.nvim_get_option_value("filetype", { buf = currentBuf })
			if currentBufFt == "NvimTree" then
				nvimTree.tree.toggle()
			else
				nvimTree.tree.focus()
			end
		end

		vim.keymap.set("n", "<C-t>", nvimTreeFocusOrToggle)

		vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>NvimTreeToggle<CR>", { silent = true, noremap = true })

		-- Set statusline to show the tree name
		tree_api.events.subscribe(tree_api.events.Event.TreeOpen, function()
			local tree_winid = tree_api.tree.winid()

			if tree_winid ~= nil then
				vim.api.nvim_set_option_value("statusline", "%t", { win = tree_winid })
			end
		end)

		-- Change Root To Global Current Working Directory
		local function change_root_to_global_cwd()
			local api = require("nvim-tree.api")
			local global_cwd = vim.fn.getcwd(-1, -1)
			api.tree.change_root(global_cwd)
		end

		-- Sorting files naturally

		vim.keymap.set("n", "<C-c>", change_root_to_global_cwd, { desc = "Change Root To Global CWD", noremap = true })
	end,
}
