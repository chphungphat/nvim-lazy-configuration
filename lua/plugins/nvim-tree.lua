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
				width = { min = 30, max = 100 },
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
						diagnostics = false,
						bookmarks = false,
					},
				},
			},
			git = {
				enable = true,
				show_on_dirs = true,
				ignore = false,
				show_on_open_dirs = true,
				disable_for_dirs = {},
				timeout = 400,
				cygwin_support = false,
			},
			filters = {
				dotfiles = false,
				custom = {},
				exclude = {},
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

			-- update_focused_file = {
			-- 	enable = true,
			-- 	update_cwd = false,
			-- 	ignore_list = {},
			-- },
		})

		local gruvbox_material = {
			fg = "#d4be98", -- Foreground
			bg = "#282828", -- Background (Medium variant)
			green = "#a9b665", -- Green
			aqua = "#89b482", -- Aqua / Cyan
			yellow = "#d8a657", -- Yellow (Warmer than default gruvbox)
			orange = "#e78a4e", -- Orange
			red = "#ea6962", -- Red
			gray = "#928374", -- Neutral Gray
		}

		local function set_nvim_tree_highlight()
			vim.api.nvim_set_hl(0, "NvimTreeGitFileNewHL", { fg = gruvbox_material.green })
			vim.api.nvim_set_hl(0, "NvimTreeGitFolderNewHL", { fg = gruvbox_material.green })

			vim.api.nvim_set_hl(0, "NvimTreeGitFileDirtyHL", { fg = gruvbox_material.aqua })
			vim.api.nvim_set_hl(0, "NvimTreeGitFolderDirtyHL", { fg = gruvbox_material.aqua })

			vim.api.nvim_set_hl(0, "NvimTreeDiagnosticWarnFileHL", { fg = gruvbox_material.yellow, underline = true })
			vim.api.nvim_set_hl(0, "NvimTreeDiagnosticWarnFolderHL", { fg = gruvbox_material.yellow, bold = true })

			vim.api.nvim_set_hl(0, "NvimTreeDiagnosticErrorFileHL", { fg = gruvbox_material.orange, underline = true })
			vim.api.nvim_set_hl(0, "NvimTreeDiagnosticErrorFolderHL", { fg = gruvbox_material.orange, bold = true })

			vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = gruvbox_material.gray }) -- Indentation guides

			-- Window picker background
			vim.api.nvim_set_hl(0, "NvimTreeWindowPicker", {
				fg = gruvbox_material.bg,
				bg = gruvbox_material.orange,
				bold = true,
			})
		end

		-- Apply highlights immediately
		set_nvim_tree_highlight()

		-- Auto-adjust highlights after colorscheme changes
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

		vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { silent = true, noremap = true })

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

		local function focus_on_current_file()
			local api = require("nvim-tree.api")

			api.tree.find_file(vim.fn.expand("%:p"), true)
		end

		vim.keymap.set("n", "<C-t>", focus_on_current_file, { desc = "Focus on current file", noremap = true })
	end,
}
