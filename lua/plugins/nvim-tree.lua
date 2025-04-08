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

		local function set_nvim_tree_highlight()
			local scheme = vim.g.colors_name or "gruvbox-material"

			local palettes = {
				["gruvbox-material"] = {
					fg = "#d4be98",
					bg = "#282828",
					green = "#a9b665",
					aqua = "#89b482",
					yellow = "#d8a657",
					orange = "#e78a4e",
					red = "#ea6962",
					gray = "#928374",
				},
				["kanagawa"] = {
					fg = "#C5C9C5",
					bg = "#1F1F28",
					green = "#98BB6C",
					aqua = "#7AA89F",
					yellow = "#DCA561",
					orange = "#FFA066",
					red = "#E82424",
					gray = "#727169",
				},
			}

			local c = palettes[scheme] or palettes["gruvbox-material"]

			local highlights = {
				{ name = "NvimTreeGitFileNewHL", fg = c.green },
				{ name = "NvimTreeGitFolderNewHL", fg = c.green },
				{ name = "NvimTreeGitFileDirtyHL", fg = c.aqua },
				{ name = "NvimTreeGitFolderDirtyHL", fg = c.aqua },
				{ name = "NvimTreeDiagnosticWarnFileHL", fg = c.yellow, underline = true },
				{ name = "NvimTreeDiagnosticWarnFolderHL", fg = c.yellow, bold = true },
				{ name = "NvimTreeDiagnosticErrorFileHL", fg = c.orange, underline = true },
				{ name = "NvimTreeDiagnosticErrorFolderHL", fg = c.orange, bold = true },
				{ name = "NvimTreeIndentMarker", fg = c.gray },
				{ name = "NvimTreeWindowPicker", fg = c.bg, bg = c.orange, bold = true },
			}

			for _, h in ipairs(highlights) do
				local name = h.name
				h.name = nil
				vim.api.nvim_set_hl(0, name, h)
			end
		end

		-- Apply highlights immediately
		set_nvim_tree_highlight()

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.schedule(set_nvim_tree_highlight)
			end,
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
