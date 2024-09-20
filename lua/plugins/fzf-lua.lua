return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzf = require("fzf-lua")

		-- Gruvbox-inspired colors
		local gruvbox = {
			bg = "#282828",
			fg = "#ebdbb2",
			red = "#cc241d",
			green = "#98971a",
			yellow = "#d79921",
			blue = "#458588",
			purple = "#b16286",
			aqua = "#689d6a",
			gray = "#a89984",
		}

		fzf.setup({
			-- Global options
			global_resume = true,
			global_resume_query = true,
			winopts = {
				height = 0.85,
				width = 0.80,
				preview = {
					default = "bat",
					vertical = "down:45%",
					horizontal = "right:50%",
					layout = "flex",
					flip_columns = 120,
				},
				hl = {
					normal = "Normal", -- Window normal color (fg+bg)
					border = "FloatBorder", -- Border color
					cursor = "Cursor", -- Cursor highlight
					cursorline = "CursorLine", -- Cursor line
					search = "Search", -- Search matches
					scrollbar_f = "PmenuThumb", -- Scrollbar "full" section highlight
					scrollbar_e = "PmenuSbar", -- Scrollbar "empty" section highlight
				},
				border = "rounded",
				fzf_opts = {
					["--color"] = string.format(
						"bg+:%s,bg:%s,spinner:%s,hl:%s,fg:%s,header:%s,info:%s,pointer:%s,marker:%s,fg+:%s,prompt:%s,hl+:%s",
						gruvbox.bg,
						gruvbox.bg,
						gruvbox.yellow,
						gruvbox.green,
						gruvbox.fg,
						gruvbox.blue,
						gruvbox.blue,
						gruvbox.yellow,
						gruvbox.yellow,
						gruvbox.fg,
						gruvbox.yellow,
						gruvbox.green
					),
				},
			},
			keymap = {
				builtin = {
					["<F1>"] = "toggle-help",
					["<F2>"] = "toggle-fullscreen",
					["<F3>"] = "toggle-preview-wrap",
					["<F4>"] = "toggle-preview",
					["<F5>"] = "toggle-preview-ccw",
					["<F6>"] = "toggle-preview-cw",
					["<S-down>"] = "preview-page-down",
					["<S-up>"] = "preview-page-up",
					["<S-left>"] = "preview-page-reset",
				},
			},
			previewers = {
				cat = {
					cmd = "cat",
					args = "--number",
				},
				bat = {
					cmd = "bat",
					args = "--style=numbers,changes --color always",
					theme = "gruvbox-dark", -- Use Gruvbox theme for bat
					config = nil,
				},
				head = {
					cmd = "head",
					args = nil,
				},
				git_diff = {
					cmd_deleted = "git diff --color HEAD --",
					cmd_modified = "git diff --color HEAD",
					cmd_untracked = "git diff --color --no-index /dev/null",
				},
				man = {
					cmd = "man -c %s | col -bx",
				},
				builtin = {
					syntax = true,
					syntax_limit_l = 0,
					syntax_limit_b = 1024 * 1024,
					limit_b = 1024 * 1024 * 10,
				},
			},
			files = {
				prompt = "Files❯ ",
				multiprocess = true,
				git_icons = true,
				file_icons = true,
				color_icons = true,
				find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
				rg_opts = "--color=never --files --hidden --follow -g '!.git'",
				fd_opts = "--color=never --type f --hidden --follow --exclude .git",
			},
			grep = {
				prompt = "Rg❯ ",
				input_prompt = "Grep For❯ ",
				multiprocess = true,
				git_icons = true,
				file_icons = true,
				color_icons = true,
				grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
				rg_glob = false,
			},
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
