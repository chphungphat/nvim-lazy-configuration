return {
	"willothy/nvim-cokeline",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"stevearc/resession.nvim",
	},
	config = function()
		local gruvbox = {
			-- bg = "#282828",
			-- fg = "#ebdbb2",
			-- gray = "#928374",
			light_gray = "#a89984",
			light_black = "#423e34",
		}

		local components = {
			space = {
				text = " ",
				truncation = { priority = 1 },
			},

			separator = {
				text = function(buffer)
					return buffer.index ~= 1 and "▏" or ""
				end,
				truncation = { priority = 1 },
			},

			devicon = {
				text = function(buffer)
					return buffer.devicon.icon
				end,
				fg = function(buffer)
					return buffer.is_focused and gruvbox.light_black or gruvbox.light_gray
				end,
				truncation = { priority = 1 },
			},

			filename = {
				text = function(buffer)
					return buffer.filename
				end,
				fg = function(buffer)
					return buffer.is_focused and gruvbox.light_black or gruvbox.light_gray
				end,
				style = function(buffer)
					return buffer.is_focused and "bold" or nil
				end,
				truncation = {
					priority = 2,
					direction = "left",
				},
			},

			close_or_unsaved = {
				text = function(buffer)
					return buffer.is_modified and "●" or ""
				end,
				fg = function(buffer)
					if buffer.is_focused then
						return buffer.is_modified and gruvbox.light_black
					else
						return buffer.is_modified and gruvbox.light_gray
					end
				end,
				delete_buffer_on_left_click = false,
				truncation = { priority = 1 },
			},
		}

		local get_hex = require("cokeline.hlgroups").get_hl_attr

		require("cokeline").setup({
			show_if_buffers_are_at_least = 1,

			buffers = {
				focus_on_delete = "prev",
				new_buffers_position = "next",
			},

			rendering = {
				max_buffer_width = 30,
			},

			sidebar = {
				filetype = "NvimTree",
				components = {
					{
						text = "  NvimTree",
						fg = vim.g.terminal_color_3,
						bg = get_hex("NvimTreeNormal", "bg"),
						bold = true,
					},
				},
			},

			default_hl = {
				fg = function(buffer)
					return buffer.is_focused and gruvbox.light_black or gruvbox.light_gray
				end,
				bg = function(buffer)
					return buffer.is_focused and gruvbox.light_gray or gruvbox.light_black
				end,
				bold = true,
			},

			components = {
				components.separator,
				components.space,
				components.devicon,
				components.space,
				components.filename,
				components.space,
				components.close_or_unsaved,
				components.space,
			},
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>bd", "<Cmd>bdelete<CR>", { silent = true, desc = "Close buffer" })

		vim.keymap.set("n", "<tab>", function()
			return ("<Plug>(cokeline-focus-%s)"):format(vim.v.count > 0 and vim.v.count or "next")
		end, { silent = true, expr = true })

		vim.keymap.set("n", "<S-tab>", function()
			return ("<Plug>(cokeline-focus-%s)"):format(vim.v.count > 0 and vim.v.count - 2 or "prev")
		end, { silent = true, expr = true })
	end,
}
