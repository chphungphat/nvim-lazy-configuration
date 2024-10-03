return {
	"freddiehaddad/feline.nvim",
	event = "VeryLazy",
	dependencies = {
		"lewis6991/gitsigns.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local lsp = require("feline.providers.lsp")
		local vi_mode_utils = require("feline.providers.vi_mode")

		local config = {
			use_bold = false,
			separator = " ",
		}

		-- Helper function to handle bold styling
		local function get_style()
			return config.use_bold and "bold" or "NONE"
		end

		local force_inactive = {
			filetypes = {},
			buftypes = {},
			bufnames = {},
		}

		local components = {
			active = { {}, {}, {} },
			inactive = { {}, {}, {} },
		}

		local colors = {
			bg = "#403d2d",
			fg = "#ebdbb2",
			normal = "#a89984",
			insert = "#8ec07c",
			visual = "#fabd2f",
			replace = "#fb4934",
			command = "#83a598",
			inactive = "#3c3836",
		}

		local vi_mode_colors = {
			NORMAL = "normal",
			OP = "normal",
			INSERT = "insert",
			VISUAL = "visual",
			LINES = "visual",
			BLOCK = "visual",
			REPLACE = "replace",
			["V-REPLACE"] = "replace",
			ENTER = "insert",
			MORE = "insert",
			SELECT = "visual",
			COMMAND = "command",
			SHELL = "normal",
			TERM = "normal",
			NONE = "normal",
		}

		force_inactive.filetypes = {
			"NvimTree",
			"dbui",
			"packer",
			"startify",
			"fugitive",
			"fugitiveblame",
		}

		force_inactive.buftypes = {
			"terminal",
		}

		-- LEFT
		-- vi-mode
		components.active[1][1] = {
			provider = function()
				local mode = vi_mode_utils.get_vim_mode()
				return " " .. mode:upper() .. " "
			end,
			hl = function()
				local val = {}
				val.bg = vi_mode_utils.get_mode_color()
				val.fg = colors.bg
				val.style = "bold" -- Always bold for mode indicator
				return val
			end,
			right_sep = config.separator,
		}

		-- filename (without path and without symbols)
		components.active[1][2] = {
			provider = function()
				return vim.fn.expand("%:t")
			end,
			hl = {
				fg = colors.fg,
				bg = colors.bg,
				style = get_style(),
			},
		}

		-- MID
		-- gitBranch
		components.active[2][1] = {
			provider = "git_branch",
			hl = {
				fg = colors.visual,
				bg = colors.bg,
				style = get_style(),
			},
			right_sep = config.separator,
		}

		-- diffAdd
		components.active[2][2] = {
			provider = "git_diff_added",
			hl = {
				fg = colors.insert,
				bg = colors.bg,
				style = get_style(),
			},
			-- right_sep = config.separator,
		}

		-- diffModfified
		components.active[2][3] = {
			provider = "git_diff_changed",
			hl = {
				fg = colors.visual,
				bg = colors.bg,
				style = get_style(),
			},
			-- right_sep = config.separator,
		}

		-- diffRemove
		components.active[2][4] = {
			provider = "git_diff_removed",
			hl = {
				fg = colors.replace,
				bg = colors.bg,
				style = get_style(),
			},
			right_sep = config.separator,
		}

		-- diagnosticErrors
		components.active[2][5] = {
			provider = "diagnostic_errors",
			enabled = function()
				return lsp.diagnostics_exist(vim.diagnostic.severity.ERROR)
			end,
			hl = {
				fg = colors.replace,
				style = get_style(),
			},
			-- right_sep = config.separator,
		}

		-- diagnosticWarn
		components.active[2][6] = {
			provider = "diagnostic_warnings",
			enabled = function()
				return lsp.diagnostics_exist(vim.diagnostic.severity.WARN)
			end,
			hl = {
				fg = colors.visual,
				style = get_style(),
			},
			-- right_sep = config.separator,
		}

		-- diagnosticHint
		components.active[2][7] = {
			provider = "diagnostic_hints",
			enabled = function()
				return lsp.diagnostics_exist(vim.diagnostic.severity.HINT)
			end,
			hl = {
				fg = colors.insert,
				style = get_style(),
			},
			-- right_sep = config.separator,
		}

		-- diagnosticInfo
		components.active[2][8] = {
			provider = "diagnostic_info",
			enabled = function()
				return lsp.diagnostics_exist(vim.diagnostic.severity.INFO)
			end,
			hl = {
				fg = colors.command,
				style = get_style(),
			},
		}

		-- RIGHT
		-- fileIcon
		components.active[3][1] = {
			provider = function()
				local filename = vim.fn.expand("%:t")
				local extension = vim.fn.expand("%:e")
				local icon = require("nvim-web-devicons").get_icon(filename, extension)
				if icon == nil then
					icon = ""
				end
				return icon
			end,
			hl = function()
				local val = {}
				local filename = vim.fn.expand("%:t")
				local extension = vim.fn.expand("%:e")
				local icon, name = require("nvim-web-devicons").get_icon(filename, extension)
				if icon ~= nil then
					val.fg = vim.fn.synIDattr(vim.fn.hlID(name), "fg")
				else
					val.fg = colors.fg
				end
				val.bg = colors.bg
				val.style = get_style()
				return val
			end,
			right_sep = config.separator,
		}
		-- fileType
		components.active[3][2] = {
			provider = "file_type",
			hl = function()
				local val = {}
				local filename = vim.fn.expand("%:t")
				local extension = vim.fn.expand("%:e")
				local icon, name = require("nvim-web-devicons").get_icon(filename, extension)
				if icon ~= nil then
					val.fg = vim.fn.synIDattr(vim.fn.hlID(name), "fg")
				else
					val.fg = colors.fg
				end
				val.bg = colors.bg
				val.style = get_style()
				return val
			end,
			right_sep = config.separator,
		}

		-- lineInfo
		components.active[3][3] = {
			provider = "position",
			hl = {
				fg = colors.fg,
				bg = colors.bg,
				style = get_style(),
			},
			right_sep = config.separator,
		}
		-- linePercent
		components.active[3][4] = {
			provider = "line_percentage",
			hl = {
				fg = colors.fg,
				bg = colors.bg,
				style = get_style(),
			},
			right_sep = config.separator,
		}
		-- scrollBar
		components.active[3][5] = {
			provider = "scroll_bar",
			hl = {
				fg = colors.visual,
				bg = colors.bg,
			},
		}

		components.inactive = {
			{
				{
					provider = function()
						return vim.fn.expand("%:t") -- Also update inactive filename to show only name
					end,
					hl = {
						fg = colors.fg,
						bg = colors.inactive,
					},
				},
			},
		}

		require("feline").setup({
			theme = colors,
			default_bg = colors.bg,
			default_fg = colors.fg,
			vi_mode_colors = vi_mode_colors,
			components = components,
			force_inactive = force_inactive,
		})
	end,
}
