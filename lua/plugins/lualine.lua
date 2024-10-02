return {
	"nvim-lualine/lualine.nvim",
	event = { "ColorScheme" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- Modified and taken from: https://github.com/jdhao/nvim-config/blob/master/lua/config/statusline.lua

		local fn = vim.fn

		local function spell()
			if vim.o.spell then
				return string.format("[SPELL]")
			end

			return ""
		end

		--- show indicator for Chinese IME
		local function ime_state()
			if vim.g.is_mac then
				-- ref: https://github.com/vim-airline/vim-airline/blob/master/autoload/airline/extensions/xkblayout.vim#L11
				local layout = fn.libcall(vim.g.XkbSwitchLib, "Xkb_Switch_getXkbLayout", "")

				-- We can use `xkbswitch -g` on the command line to get current mode.
				-- mode for macOS builtin pinyin IME: com.apple.inputmethod.SCIM.ITABC
				-- mode for Rime: im.rime.inputmethod.Squirrel.Rime
				local res = fn.match(layout, [[\v(Squirrel\.Rime|SCIM.ITABC)]])
				if res ~= -1 then
					return "[CN]"
				end
			end
			return ""
		end

		local function trailing_space()
			if not vim.o.modifiable then
				return ""
			end

			local line_num = nil

			for i = 1, fn.line("$") do
				local linetext = fn.getline(i)
				-- To prevent invalid escape error, we wrap the regex string with `[[]]`.
				local idx = fn.match(linetext, [[\v\s+$]])

				if idx ~= -1 then
					line_num = i
					break
				end
			end

			local msg = ""
			if line_num ~= nil then
				msg = string.format("[%d]trailing", line_num)
			end

			return msg
		end

		local function mixed_indent()
			if not vim.o.modifiable then
				return ""
			end

			local space_pat = [[\v^ +]]
			local tab_pat = [[\v^\t+]]
			local space_indent = fn.search(space_pat, "nwc")
			local tab_indent = fn.search(tab_pat, "nwc")
			local mixed = (space_indent > 0 and tab_indent > 0)
			local mixed_same_line
			if not mixed then
				mixed_same_line = fn.search([[\v^(\t+ | +\t)]], "nwc")
				mixed = mixed_same_line > 0
			end
			if not mixed then
				return ""
			end
			if mixed_same_line ~= nil and mixed_same_line > 0 then
				return "MI:" .. mixed_same_line
			end
			local space_indent_cnt = fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
			local tab_indent_cnt = fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
			if space_indent_cnt > tab_indent_cnt then
				return "MI:" .. tab_indent
			else
				return "MI:" .. space_indent
			end
		end

		local diff = function()
			local git_status = vim.b.gitsigns_status_dict
			if git_status == nil then
				return
			end

			local modify_num = git_status.changed
			local remove_num = git_status.removed
			local add_num = git_status.added

			local info = { added = add_num, modified = modify_num, removed = remove_num }
			-- vim.print(info)
			return info
		end

		local virtual_env = function()
			-- only show virtual env for Python
			if vim.bo.filetype ~= "python" then
				return ""
			end

			local conda_env = os.getenv("CONDA_DEFAULT_ENV")
			local venv_path = os.getenv("VIRTUAL_ENV")

			if venv_path == nil then
				if conda_env == nil then
					return ""
				else
					return string.format("  %s (conda)", conda_env)
				end
			else
				local venv_name = vim.fn.fnamemodify(venv_path, ":t")
				return string.format("  %s (venv)", venv_name)
			end
		end

		local bamboo_colors = {
			normal = "#80b39d",
			insert = "#8ac6d1",
			visual = "#f0e68c",
			replace = "#ff8c00",
			command = "#7fc8a9",
			inactive = "#3a3a38",
			bg = "#394a46",
			fg = "#ebdbb2",
		}

		local gruvbox_colors = {
			normal = "#a89984",
			insert = "#8ec07c",
			visual = "#fabd2f",
			replace = "#fb4934",
			command = "#83a598",
			inactive = "#3c3836",
			bg = "#403d2d",
			fg = "#ebdbb2",
		}

		local lualine_style = {
			gruvbox = gruvbox_colors,
			bamboo = bamboo_colors,
		}

		local colorscheme = vim.g.colors_name or "bamboo"

		local style_colors = lualine_style[colorscheme]

		if not style_colors then
			style_colors = bamboo_colors
		end

		local lualine_theme = {
			normal = {
				a = { bg = style_colors.normal, fg = style_colors.bg, gui = "bold" },
				b = { bg = style_colors.bg, fg = style_colors.fg },
				c = { bg = style_colors.bg, fg = style_colors.fg },
			},
			insert = {
				a = { bg = style_colors.insert, fg = style_colors.bg, gui = "bold" },
				b = { bg = style_colors.bg, fg = style_colors.fg },
				c = { bg = style_colors.bg, fg = style_colors.fg },
			},
			visual = {
				a = { bg = style_colors.visual, fg = style_colors.bg, gui = "bold" },
				b = { bg = style_colors.bg, fg = style_colors.fg },
				c = { bg = style_colors.bg, fg = style_colors.fg },
			},
			command = {
				a = { bg = style_colors.command, fg = style_colors.bg, gui = "bold" },
				b = { bg = style_colors.bg, fg = style_colors.fg },
				c = { bg = style_colors.bg, fg = style_colors.fg },
			},
			replace = {
				a = { bg = style_colors.replace, fg = style_colors.bg, gui = "bold" },
				b = { bg = style_colors.bg, fg = style_colors.fg },
				c = { bg = style_colors.bg, fg = style_colors.fg },
			},
			inactive = {
				a = { bg = style_colors.inactive, fg = style_colors.fg, gui = "bold" },
				b = { bg = style_colors.inactive, fg = style_colors.fg },
				c = { bg = style_colors.inactive, fg = style_colors.fg },
			},
		}

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = lualine_theme,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				-- section_separators = "",
				-- component_separators = "",
				disabled_filetypes = {},
				always_divide_middle = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					{
						"diff",
						source = diff,
					},
					{
						virtual_env,
						color = { fg = "black", bg = "#F1CA81" },
					},
				},
				lualine_c = {
					"filename",
					{
						ime_state,
						color = { fg = "black", bg = "#f46868" },
					},
					{
						spell,
						color = { fg = "black", bg = "#a7c080" },
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", hint = "󰠠 ", info = " " },
					},
				},
				lualine_x = {
					{
						"copilot",
						show_colors = true,
					},
					"encoding",
					{
						"fileformat",
						symbols = {
							unix = "linux",
							dos = "win",
							mac = "mac",
						},
					},
					"filetype",
				},
				lualine_y = {
					"location",
				},
				lualine_z = {
					{
						trailing_space,
						color = "WarningMsg",
					},
					{
						mixed_indent,
						color = "WarningMsg",
					},
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			-- tabline = {
			-- 	lualine_a = {
			-- 		{
			-- 			"buffers",
			-- 			show_filename_only = true,
			-- 			show_modified_status = true,
			-- 			separator = { left = "▏", right = "" },
			-- 			right_padding = 2,
			-- 			symbols = {
			-- 				modified = " ",
			-- 				alternate_file = "",
			-- 			},
			-- 		},
			-- 	},
			-- },
			extensions = { "fzf", "mason", "nvim-tree", "lazy" },
		})
	end,
}
