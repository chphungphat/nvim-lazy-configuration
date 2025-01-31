if true then
	return {}
end
return {
	"willothy/nvim-cokeline",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"stevearc/resession.nvim",
	},
	config = function()
		local excluded_filetypes = {
			"NvimTree",
			"man",
		}

		local function is_excluded(buf)
			return vim.tbl_contains(excluded_filetypes, vim.bo[buf].filetype)
		end

		local ok_hlgroups, hlgroups = pcall(require, "cokeline.hlgroups")
		if not ok_hlgroups then
			return
		end

		local function safe_get_hex(group, attr)
			local ok, color = pcall(hlgroups.get_hl_attr, group, attr)
			return ok and color or "#000000"
		end

		local gruvbox = {
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

		local ok_cokeline, cokeline = pcall(require, "cokeline")
		if not ok_cokeline then
			return
		end

		cokeline.setup({
			show_if_buffers_are_at_least = 1,

			buffers = {
				focus_on_delete = "prev",
				new_buffers_position = "next",

				filter_valid = function(buffer)
					return not is_excluded(buffer.number)
				end,
			},

			rendering = {
				max_buffer_width = 30,
			},

			sidebar = {
				filetype = "NvimTree",
				components = {
					{
						text = "  NvimTree",
						fg = vim.g.terminal_color_3 or "#fabd2f",
						bg = safe_get_hex("NvimTreeNormal", "bg"),
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
		vim.keymap.set("n", "<leader>bd", function()
			local current_buf = vim.api.nvim_get_current_buf()
			local buffers = vim.api.nvim_list_bufs()
			local alternate_buffers = vim.tbl_filter(function(buf)
				return buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf)
			end, buffers)

			if #alternate_buffers > 0 then
				vim.api.nvim_set_current_buf(alternate_buffers[1])
			else
				vim.cmd("enew")
			end

			vim.api.nvim_buf_delete(current_buf, { force = false })
		end, { silent = true, desc = "Close buffer while preserving window" })

		vim.keymap.set("n", "<tab>", function()
			return ("<Plug>(cokeline-focus-%s)"):format(vim.v.count > 0 and vim.v.count or "next")
		end, { silent = true, expr = true })

		vim.keymap.set("n", "<S-tab>", function()
			return ("<Plug>(cokeline-focus-%s)"):format(vim.v.count > 0 and vim.v.count - 2 or "prev")
		end, { silent = true, expr = true })
	end,
}
