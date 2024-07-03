return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
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
					-- "Cargo.toml",
					-- "Makefile",
					-- "README.md",
					-- "readme.md",
					-- "package.json",
				},
				highlight_git = "name",
				highlight_diagnostics = "name",
				highlight_opened_files = "none",
				highlight_modified = "name",
				highlight_bookmarks = "none",
				highlight_clipboard = "name",
				indent_markers = {
					enable = true,
					inline_arrows = true,
					icons = {
						corner = "└",
						edge = "│",
						item = "│",
						bottom = "─",
						none = " ",
					},
				},

				icons = {
					git_placement = "after",
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = false,
						modified = false,
						diagnostics = true,
						bookmarks = false,
					},
				},
			},
			git = {
				enable = true,
				show_on_dirs = true,
				show_on_open_dirs = true,
				disable_for_dirs = {},
				timeout = 400,
				cygwin_support = false,
			},
			diagnostics = {
				enable = true,
				show_on_dirs = true,
				show_on_open_dirs = false,
				debounce_delay = 50,
				severity = {
					min = vim.diagnostic.severity.HINT,
					max = vim.diagnostic.severity.ERROR,
				},
				icons = {
					hint = "󰠠 ",
					info = " ",
					warning = " ",
					error = " ",
				},
			},
			modified = {
				enable = true,
				show_on_dirs = true,
				show_on_open_dirs = false,
			},

			actions = {
				open_file = {
					window_picker = {
						enable = true,
					},
				},
				change_dir = {
					enable = false,
					global = false,
				},
			},
		})

		local function set_nvim_tree_highlight()
			vim.api.nvim_set_hl(0, "NvimTreeGitFileNewHL", { fg = "#98971a" })
			vim.api.nvim_set_hl(0, "NvimTreeGitFolderNewHL", { fg = "#98971a" })

			vim.api.nvim_set_hl(0, "NvimTreeGitFileDirtyHL", { fg = "#689d6a" })
			vim.api.nvim_set_hl(0, "NvimTreeGitFolderDirtyHL", { fg = "#689d6a" })

			vim.api.nvim_set_hl(0, "NvimTreeDiagnosticErrorFileHL", { fg = "#d79921", underline = true })
			vim.api.nvim_set_hl(0, "NvimTreeDiagnosticErrorFolderHL", { fg = "#d79921", bold = true })

			vim.api.nvim_set_hl(0, "NvimTreeDiagnosticWarnFileHL", { fg = "#fabd2f", underline = true })
			vim.api.nvim_set_hl(0, "NvimTreeDiagnosticWarnFolderHL", { fg = "#fabd2f", bold = true })

			vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#504945" })

			vim.api.nvim_set_hl(0, "NvimTreeWindowPicker", {
				fg = "#3c3836",
				bg = "#fe8019",
				bold = true,
			})
		end

		-- Set up the highlight immediately
		set_nvim_tree_highlight()

		-- Set up an autocommand to apply the highlight after colorscheme changes
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = set_nvim_tree_highlight,
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

		vim.keymap.set("n", "<C-c>", change_root_to_global_cwd, { desc = "Change Root To Global CWD", noremap = true })
	end,
}
