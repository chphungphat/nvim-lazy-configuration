return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzf = require("fzf-lua")

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
			},
			keymap = {
				-- These override the default tables completely
				-- no need to set to `false` to disable a bind
				-- delete or modify is sufficient
				builtin = {
					-- neovim `:tmap` mappings for the fzf win
					["<F1>"] = "toggle-help",
					["<F2>"] = "toggle-fullscreen",
					-- Only valid with the 'builtin' previewer
					["<F3>"] = "toggle-preview-wrap",
					["<F4>"] = "toggle-preview",
					-- Rotate preview clockwise/counter-clockwise
					["<F5>"] = "toggle-preview-ccw",
					["<F6>"] = "toggle-preview-cw",
					["<S-down>"] = "preview-page-down",
					["<S-up>"] = "preview-page-up",
					["<S-left>"] = "preview-page-reset",
				},
				fzf = {
					-- fzf '--bind=' options
					["ctrl-z"] = "abort",
					["ctrl-u"] = "unix-line-discard",
					["ctrl-f"] = "half-page-down",
					["ctrl-b"] = "half-page-up",
					["ctrl-a"] = "beginning-of-line",
					["ctrl-e"] = "end-of-line",
					["alt-a"] = "toggle-all",
					-- Only valid with fzf previewers (bat/cat/git/etc)
					["f3"] = "toggle-preview-wrap",
					["f4"] = "toggle-preview",
					["shift-down"] = "preview-page-down",
					["shift-up"] = "preview-page-up",
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
					theme = "Coldark-Dark", -- bat preview theme (bat --list-themes)
					config = nil, -- nil uses $BAT_CONFIG_PATH
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
					syntax = true, -- preview syntax highlight?
					syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
					syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
					limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
					-- previewer treesitter options
					treesitter = {
						enable = true,
						enable_hl = true,
					},
				},
			},
			-- Custom options for specific commands
			files = {
				-- previewer      = "bat",          -- uncomment to override previewer
				prompt = "Files❯ ",
				multiprocess = true, -- run command in a separate process
				git_icons = true, -- show git icons?
				file_icons = true, -- show file icons?
				color_icons = true, -- colorize file|git icons
				-- executed command priority is 'cmd' (if exists)
				-- otherwise auto-detect prioritizes `fd`:`rg`:`find`
				-- default options are controlled by 'fd|rg|find|_opts'
				-- NOTE: 'find -printf' requires GNU find
				-- cmd            = "find . -type f -printf '%P\n'",
				find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
				rg_opts = "--color=never --files --hidden --follow -g '!.git'",
				fd_opts = "--color=never --type f --hidden --follow --exclude .git",
			},
			grep = {
				prompt = "Rg❯ ",
				input_prompt = "Grep For❯ ",
				multiprocess = true, -- run command in a separate process
				git_icons = true, -- show git icons?
				file_icons = true, -- show file icons?
				color_icons = true, -- colorize file|git icons
				-- executed command priority is 'cmd' (if exists)
				-- otherwise auto-detect prioritizes `rg` over `grep`
				-- default options are controlled by 'rg|grep_opts'
				-- cmd            = "rg --vimgrep",
				grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
				-- set to 'true' to always parse globs in both 'grep' and 'live_grep'
				-- search strings will be split using the 'glob_separator' and translated
				-- to '--iglob=' arguments, requires 'rg'
				-- can still be used when 'false' by calling 'live_grep_glob' directly
				rg_glob = false, -- default to glob parsing?
				glob_flag = "--iglob", -- for case sensitive globs use '--glob'
				glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
			},
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "Search Keymaps" })
		vim.keymap.set("n", "<leader><leader>", fzf.files, { desc = "Search Files" })
		vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Search by Grep" })
		vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Search Diagnostics" })

		-- Additional useful mappings
		vim.keymap.set("n", "<leader>sb", fzf.buffers, { desc = "Search Buffers" })
		vim.keymap.set("n", "<leader>sh", fzf.help_tags, { desc = "Search Help Tags" })
		vim.keymap.set("n", "<leader>sm", fzf.marks, { desc = "Search Marks" })
		vim.keymap.set("n", "<leader>so", fzf.oldfiles, { desc = "Search Old Files" })
	end,
}
