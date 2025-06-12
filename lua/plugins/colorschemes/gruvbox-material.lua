return {
	"sainnhe/gruvbox-material",
	event = { "VimEnter", "ColorScheme" },
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.gruvbox_material_background = "hard"
		vim.g.gruvbox_material_foreground = "mix"
		vim.g.gruvbox_material_disable_italic_comment = 0
		vim.g.gruvbox_material_enable_italic = true
		vim.g.gruvbox_material_enable_bold = 1

		local bg_colors = {
			very_dark = "#0f0f0f", -- Very dark (almost black)
			darker_hard = "#161616", --  Slightly darker than hard
			darker = "#111111", --  Hard but even darker
			dark_soft = "#101010", --  Almost black but slightly lighter
			dark_gray = "#121212", -- Very dark gray (popular "true black" alternative)

			medium_dark = "#1d1d1d", -- Medium dark gray
			standard_dark = "#282828", -- Standard dark gray (original gruvbox dark)
			lighter_dark = "#32302f", -- Lighter dark gray (close to original gruvbox soft)
			medium_gray = "#3c3836", -- Medium gray
			light_gray = "#504945", -- Light gray (still dark enough for a dark theme)
		}

		local cursorline_bg_colors = {
			very_dark = "#191919", -- Slightly lighter than very_dark
			darker_hard = "#202020", -- Slightly lighter than darker_hard
			darker = "#1a1a1a", -- Slightly lighter than darker
			dark_soft = "#1a1a1a", -- Slightly lighter than dark_soft
			dark_gray = "#1c1c1c", -- Slightly lighter than dark_gray

			medium_dark = "#262626", -- Slightly lighter than medium_dark
			standard_dark = "#32302f", -- Slightly lighter than standard_dark
			lighter_dark = "#3c3836", -- Slightly lighter than lighter_dark
			medium_gray = "#45403d", -- Slightly lighter than medium_gray
			light_gray = "#5a524c", -- Slightly lighter than light_gray
		}

		local selected_bg = bg_colors.standard_dark
		local cursorline_bg = cursorline_bg_colors.standard_dark

		local function override_backgrounds()
			local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
			vim.api.nvim_set_hl(0, "Normal", {
				fg = normal_hl.fg,
				bg = selected_bg,
				bold = normal_hl.bold,
				italic = normal_hl.italic,
				underline = normal_hl.underline,
			})

			-- NormalNC (non-current/inactive windows)
			local normal_nc_hl = vim.api.nvim_get_hl(0, { name = "NormalNC" })
			vim.api.nvim_set_hl(0, "NormalNC", {
				fg = normal_nc_hl.fg or normal_hl.fg,
				bg = selected_bg,
				bold = normal_nc_hl.bold,
				italic = normal_nc_hl.italic,
				underline = normal_nc_hl.underline,
			})

			-- NormalFloat (floating windows)
			local normal_float_hl = vim.api.nvim_get_hl(0, { name = "NormalFloat" })
			vim.api.nvim_set_hl(0, "NormalFloat", {
				fg = normal_float_hl.fg or normal_hl.fg,
				bg = selected_bg,
				bold = normal_float_hl.bold,
				italic = normal_float_hl.italic,
				underline = normal_float_hl.underline,
			})

			-- EndOfBuffer (the ~ at the end of buffer)
			local eob_hl = vim.api.nvim_get_hl(0, { name = "EndOfBuffer" })
			vim.api.nvim_set_hl(0, "EndOfBuffer", {
				fg = eob_hl.fg,
				bg = selected_bg,
				bold = eob_hl.bold,
				italic = eob_hl.italic,
				underline = eob_hl.underline,
			})

			-- SignColumn
			local sign_hl = vim.api.nvim_get_hl(0, { name = "SignColumn" })
			vim.api.nvim_set_hl(0, "SignColumn", {
				fg = sign_hl.fg,
				bg = selected_bg,
				bold = sign_hl.bold,
				italic = sign_hl.italic,
				underline = sign_hl.underline,
			})

			-- LineNr (line numbers)
			local line_nr_hl = vim.api.nvim_get_hl(0, { name = "LineNr" })
			vim.api.nvim_set_hl(0, "LineNr", {
				fg = line_nr_hl.fg,
				bg = selected_bg,
				bold = line_nr_hl.bold,
				italic = line_nr_hl.italic,
				underline = line_nr_hl.underline,
			})

			-- CursorLine
			local cursorline_hl = vim.api.nvim_get_hl(0, { name = "CursorLine" })
			vim.api.nvim_set_hl(0, "CursorLine", {
				fg = cursorline_hl.fg,
				bg = cursorline_bg,
				bold = cursorline_hl.bold,
				italic = cursorline_hl.italic,
				underline = cursorline_hl.underline,
			})

			-- CursorLineNr
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fabd2f", bold = true })

			-- Fix slimline highlights - properly extract and set attributes
			local slimline_hls = vim.fn.getcompletion("slimline", "highlight")
			for _, hl_name in ipairs(slimline_hls) do
				local hl = vim.api.nvim_get_hl(0, { name = hl_name })
				if hl and (hl.fg or hl.bg) then
					-- Create a new highlight with explicit attributes
					local new_hl = {}

					if hl.fg then
						new_hl.fg = hl.fg
					end
					if hl.bg then
						new_hl.bg = hl.bg
					end
					if hl.sp then
						new_hl.sp = hl.sp
					end
					if hl.bold then
						new_hl.bold = hl.bold
					end
					if hl.italic then
						new_hl.italic = hl.italic
					end
					if hl.underline then
						new_hl.underline = hl.underline
					end
					if hl.undercurl then
						new_hl.undercurl = hl.undercurl
					end
					if hl.reverse then
						new_hl.reverse = hl.reverse
					end

					-- Set the highlight with our extracted attributes
					vim.api.nvim_set_hl(0, hl_name, new_hl)
				end
			end
		end

		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "gruvbox-material",
			callback = function()
				-- Delay the background override to ensure all plugins have initialized their highlights
				vim.defer_fn(override_backgrounds, 10)
			end,
		})

		-- Also apply after VimEnter to ensure it works when opening files directly
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if vim.g.colors_name == "gruvbox-material" then
					vim.defer_fn(override_backgrounds, 100)
				end
			end,
		})

		-- Apply when switching windows to ensure all windows get the dark background
		vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
			callback = function()
				if vim.g.colors_name == "gruvbox-material" then
					vim.defer_fn(override_backgrounds, 10)
				end
			end,
		})
	end,
}
