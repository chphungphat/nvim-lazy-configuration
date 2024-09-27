if true then
	return {}
end
return {
	"simonmclean/triptych.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local triptych = require("triptych")

		vim.api.nvim_set_hl(0, "GruvboxFg1", { fg = "#ebdbb2" })
		vim.api.nvim_set_hl(0, "GruvboxYellow", { fg = "#fabd2f" })
		vim.api.nvim_set_hl(0, "GruvboxGray", { fg = "#928374" })
		vim.api.nvim_set_hl(0, "GruvboxBlue", { fg = "#83a598" })

		triptych.setup({
			mappings = {
				-- show_help = "g?",
				-- jump_to_cwd = ".",
				-- nav_left = "h",
				-- nav_right = { "l", "<CR>" },
				-- delete = "d",
				-- add = "a",
				-- copy = "c",
				-- rename = "r",
				-- cut = "x",
				-- paste = "p",
				-- close = "q",
				-- toggle_hidden = "<leader>.",
				show_help = "g?",
				jump_to_cwd = ".", -- Pressing again will toggle back
				nav_left = "h",
				nav_right = { "l", "<CR>" }, -- If target is a file, opens the file in-place
				open_hsplit = { "-" },
				open_vsplit = { "|" },
				open_tab = { "<C-t>" },
				cd = "<leader>cd",
				delete = "d",
				add = "a",
				copy = "c",
				rename = "r",
				cut = "x",
				paste = "p",
				quit = "q",
				toggle_hidden = "<leader>.",
				toggle_collapse_dirs = "z",
			},
			-- extension_mappings = {
			-- 	["lua"] = "nvim",
			-- 	["js"] = "node",
			-- },
			options = {
				dirs_first = true,
				show_hidden = true,
				line_numbers = {
					enabled = true,
					relative = false,
				},
				file_icons = {
					enabled = true,
					directory_icon = "",
					fallback_file_icon = "",
				},
				responsive_column_widths = {
					-- Keys are breakpoints, values are column widths
					-- A breakpoint means "when vim.o.columns >= x, use these column widths"
					-- Columns widths must add up to 1 after rounding to 2 decimal places
					-- Parent or child windows can be hidden by setting a width of 0
					["0"] = { 0, 0.5, 0.5 },
					["120"] = { 0.2, 0.3, 0.5 },
					["200"] = { 0.25, 0.25, 0.5 },
				}, -- Adjust these values as needed
				highlights = {
					-- Gruvbox-inspired colors
					file_names = "GruvboxFg1",
					directory_names = "GruvboxYellow",
					hidden_files = "GruvboxGray",
					selected = "GruvboxBlue",
				},
			},
			git_signs = {
				enabled = true,
				signs = {
					add = "+",
					modify = "~",
					rename = "r",
					untracked = "?",
				},
			},
		})

		-- Keybindings
		vim.keymap.set("n", "<C-t>", ":Triptych<CR>", { silent = true })
		vim.keymap.set("n", "<leader>t", ":Triptych<CR>", { silent = true })
	end,
}
