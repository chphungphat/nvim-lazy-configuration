return {
	"stevearc/dressing.nvim",
	opts = {
		input = {
			enabled = true,
			default_prompt = "Input:",
			prompt_align = "left",
			insert_only = true,
			start_in_insert = true,
			border = "rounded",
			relative = "cursor",
		},
		select = {
			enabled = true,
			backend = { "telescope", "fzf", "builtin" },
		},
	},
}
