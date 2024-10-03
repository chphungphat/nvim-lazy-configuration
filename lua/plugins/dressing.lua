return {
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	config = function()
		require("dressing").setup({
			backend = { "fzf_lua", "fzf", "builtin" },
			select = {
				-- Options for built-in selector
				builtin = {
					width = 0.8,
					height = 0.8,
					border = "rounded",
					relative = "editor",
				},
				-- Options for fzf-lua selector
				fzf_lua = {
					winopts = {
						width = 0.8,
						height = 0.8,
						preview = {
							layout = "vertical",
							vertical = "up:40%",
						},
					},
				},
			},
			input = {
				-- Set to false to disable the vim.ui.input implementation
				enabled = true,

				-- Default prompt string
				default_prompt = "Input:",

				-- Can be 'left', 'right', or 'center'
				prompt_align = "left",

				-- When true, <Esc> will close the modal
				insert_only = true,

				-- These are passed to nvim_open_win
				border = "rounded",
				-- 'editor' and 'win' will default to being centered
				relative = "cursor",

				-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				prefer_width = 40,
				width = nil,
				-- min_width and max_width can be a list of mixed types.
				-- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
				max_width = { 140, 0.9 },
				min_width = { 20, 0.2 },

				-- Window transparency (0-100)
				winblend = 10,
				-- Change default highlight groups (see :help winhl)
				winhighlight = "",
			},
		})
	end,
}
