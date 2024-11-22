return {
	"freddiehaddad/feline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"lewis6991/gitsigns.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local ok_lsp, lsp = pcall(require, "feline.providers.lsp")
		local ok_vimode, vi_mode_utils = pcall(require, "feline.providers.vi_mode")

		if not (ok_lsp and ok_vimode) then
			return
		end

		local config = {
			use_bold = false,
			separator = " ",
		}

		local function get_style()
			return config.use_bold and "bold" or "NONE"
		end

		local function safe_diagnostics_exist(severity)
			local ok, exists = pcall(lsp.diagnostics_exist, severity)
			return ok and exists or false
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
			filetype = "#bdae93",
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
			"man",
		}

		force_inactive.buftypes = {
			"terminal",
		}

		-- LEFT
		components.active[1][1] = {
			provider = function()
				local mode = vi_mode_utils.get_vim_mode()
				return " " .. mode:upper() .. " "
			end,
			hl = function()
				local val = {}
				val.bg = vi_mode_utils.get_mode_color()
				val.fg = colors.bg
				val.style = "bold"
				return val
			end,
			right_sep = config.separator,
		}

		components.active[1][2] = {
			provider = function()
				return vim.fn.expand("%:t")
			end,
			hl = {
				fg = colors.fg,
				bg = colors.bg,
				style = get_style(),
			},
			right_sep = config.separator .. config.separator,
		}

		components.active[1][3] = {
			provider = "git_branch",
			hl = {
				fg = colors.visual,
				bg = colors.bg,
				style = get_style(),
			},
			right_sep = config.separator,
		}

		components.active[1][4] = {
			provider = "git_diff_added",
			hl = {
				fg = colors.insert,
				bg = colors.bg,
				style = get_style(),
			},
		}

		components.active[1][5] = {
			provider = "git_diff_changed",
			hl = {
				fg = colors.visual,
				bg = colors.bg,
				style = get_style(),
			},
		}

		components.active[1][6] = {
			provider = "git_diff_removed",
			hl = {
				fg = colors.replace,
				bg = colors.bg,
				style = get_style(),
			},
			right_sep = config.separator,
		}

		-- Diagnostics with safe checks
		components.active[2][1] = {
			provider = "diagnostic_errors",
			enabled = function()
				return safe_diagnostics_exist(vim.diagnostic.severity.ERROR)
			end,
			hl = {
				fg = colors.replace,
				style = get_style(),
			},
		}

		components.active[2][2] = {
			provider = "diagnostic_warnings",
			enabled = function()
				return safe_diagnostics_exist(vim.diagnostic.severity.WARN)
			end,
			hl = {
				fg = colors.visual,
				style = get_style(),
			},
		}

		components.active[2][3] = {
			provider = "diagnostic_hints",
			enabled = function()
				return safe_diagnostics_exist(vim.diagnostic.severity.HINT)
			end,
			hl = {
				fg = colors.insert,
				style = get_style(),
			},
		}

		components.active[2][4] = {
			provider = "diagnostic_info",
			enabled = function()
				return safe_diagnostics_exist(vim.diagnostic.severity.INFO)
			end,
			hl = {
				fg = colors.command,
				style = get_style(),
			},
		}

		components.active[3][1] = {
			provider = "position",
			hl = {
				fg = colors.fg,
				bg = colors.bg,
				style = get_style(),
			},
			right_sep = config.separator,
		}

		components.inactive = {
			{
				{
					provider = function()
						return vim.fn.expand("%:t")
					end,
					hl = {
						fg = colors.fg,
						bg = colors.inactive,
					},
				},
			},
		}

		local ok_feline = pcall(require, "feline")
		if not ok_feline then
			return
		end

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
