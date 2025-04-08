return {
	"ibhagwan/fzf-lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local fzf = require("fzf-lua")

		local function get_fzf_colors()
			local colorscheme = vim.g.colors_name or "kanagawa"

			local themes = {
				["gruvbox-material"] = {
					bg = "#282828",
					fg = "#d4be98",
					red = "#ea6962",
					green = "#a9b665",
					yellow = "#d8a657",
					blue = "#7daea3",
					purple = "#d3869b",
					aqua = "#89b482",
					gray = "#928374",
					hl = "#fabd2f",
					info = "#83a598",
					search = "#fe8019",
					header = "#d79921",
					pointer = "#fabd2f",
					marker = "#fe8019",
					prompt = "#d3869b",
				},
				["kanagawa"] = {
					bg = "#181616",
					fg = "#C5C9C5",
					red = "#C34043",
					green = "#76946A",
					yellow = "#C0A36E",
					blue = "#7E9CD8",
					purple = "#957FB8",
					aqua = "#7AA89F",
					gray = "#727169",
					hl = "#C34043",
					info = "#7E9CD8",
					search = "#E82424",
					header = "#DCA561",
					pointer = "#9D6F6C",
					marker = "#C34043",
					prompt = "#C34043",
				},
			}

			return themes[colorscheme] or themes["gruvbox-material"]
		end

		local function apply_fzf_colors()
			local colors = get_fzf_colors()
			fzf.setup({
				global_resume = true,
				global_resume_query = true,
				hls = {
					normal = "Normal",
					border = "FloatBorder",
					cursor = "Cursor",
					cursorline = "CursorLine",
					search = "Search",
					scrollbar_f = "PmenuThumb",
					scrollbar_e = "PmenuSbar",
				},
				winopts = {
					height = 0.85,
					width = 0.80,
					preview = {
						default = "bat",
						vertical = "down:45%",
						horizontal = "right:50%",
						layout = "horizontal",
						flip_columns = 100,
					},
					border = "rounded",
					fzf_opts = {
						["--color"] = string.format(
							"bg+:%s,bg:%s,spinner:%s,hl:%s,fg:%s,header:%s,info:%s,pointer:%s,marker:%s,fg+:%s,prompt:%s,hl+:%s",
							colors.bg, -- Background Highlight
							colors.bg, -- Background
							colors.search, -- Spinner (loading indicator)
							colors.hl, -- Highlight
							colors.fg, -- Foreground
							colors.header, -- Header (title)
							colors.info, -- Info text
							colors.pointer, -- Pointer (cursor)
							colors.hl, -- Marker (selection indicator)
							colors.fg, -- Foreground (active)
							colors.hl, -- Prompt color
							colors.hl -- Search Highlight
						),
					},
				},
			})
		end

		apply_fzf_colors()

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.schedule(apply_fzf_colors)
			end,
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "Search Keymaps" })
		vim.keymap.set("n", "<leader><leader>", fzf.files, { desc = "Search Files" })
		vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Search by Grep" })
		vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Search Diagnostics" })
		vim.keymap.set("n", "<leader>sb", fzf.buffers, { desc = "Search Buffers" })
		vim.keymap.set("n", "<leader>sh", fzf.help_tags, { desc = "Search Help Tags" })
		vim.keymap.set("n", "<leader>sm", fzf.marks, { desc = "Search Marks" })
		vim.keymap.set("n", "<leader>so", fzf.oldfiles, { desc = "Search Old Files" })
	end,
}
