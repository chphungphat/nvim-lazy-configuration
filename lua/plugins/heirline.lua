return {
	"rebelot/heirline.nvim",
	event = "VeryLazy",
	config = function()
		local conditions = require("heirline.conditions")

		local colors = {
			bg = "#282828",
			fg = "#d4be98",
			red = "#ea6962",
			green = "#a9b665",
			yellow = "#d8a657",
			blue = "#7daea3",
			purple = "#d3869b",
			aqua = "#89b482",
			gray = "#928374",
		}

		local mode_colors = {
			n = colors.green,
			i = colors.blue,
			v = colors.purple,
			[""] = colors.purple,
			V = colors.purple,
			c = colors.red,
			no = colors.red,
			s = colors.orange,
			S = colors.orange,
			ic = colors.yellow,
			R = colors.purple,
			cv = colors.red,
			ce = colors.red,
			t = colors.red,
		}

		local Mode = {
			provider = function()
				return "  "
			end,
			hl = function()
				local mode = vim.fn.mode()
				return { fg = mode_colors[mode], bold = true }
			end,
		}

		local FileName = {
			provider = function()
				local filename = vim.fn.expand("%:t")
				return filename == "" and "[No Name]" or filename
			end,
			hl = { fg = colors.fg, bold = true },
		}

		local FileType = {
			provider = function()
				return string.upper(vim.bo.filetype)
			end,
			hl = { fg = colors.blue, bold = true },
		}

		local Diagnostics = {
			condition = conditions.has_diagnostics,
			static = {
				error_icon = " ",
				warn_icon = " ",
				info_icon = " ",
				hint_icon = " ",
			},
			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			end,
			update = { "DiagnosticChanged", "BufEnter" },
		}

		local Git = {
			condition = conditions.is_git_repo,
			init = function(self)
				self.status_dict = vim.b.gitsigns_status_dict or { head = "", added = 0, changed = 0, removed = 0 }
			end,
			hl = { fg = colors.yellow },
			{
				provider = function(self)
					return " " .. self.status_dict.head
				end,
				hl = { bold = true },
			},
		}

		local Align = { provider = "%=" }
		local Space = { provider = " " }

		local Bufferline = {
			condition = conditions.is_not_empty,
			provider = function()
				local buffers = vim.api.nvim_list_bufs()
				local components = {}
				for _, buf in ipairs(buffers) do
					if vim.api.nvim_buf_is_loaded(buf) then
						table.insert(components, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t"))
					end
				end
				return "[ " .. table.concat(components, " | ") .. " ]"
			end,
			hl = { fg = colors.fg, bg = colors.bg, bold = true },
		}

		require("heirline").setup({
			statusline = { Mode, Space, FileName, Space, FileType, Align, Diagnostics, Space, Git, Space },
			tabline = Bufferline,
		})
	end,
}
