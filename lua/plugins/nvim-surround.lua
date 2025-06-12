return {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("nvim-surround").setup({
			-- Much easier keymaps to remember!
			keymaps = {
				-- Insert mode (rarely used)
				insert = false, -- Disable to avoid conflicts
				insert_line = false,

				-- Normal mode - using <leader>s prefix for "surround"
				normal = "<leader>sa", -- "surround add" - Add surround around motion
				normal_cur = "<leader>sal", -- "surround add line" - Add surround around current line
				normal_line = "<leader>sA", -- "surround Add" (visual line version)
				normal_gcur_gline = false, -- Disable this complex one

				-- Visual mode - super intuitive
				visual = "<leader>sa", -- "surround add" - Add surround around selection
				visual_line = "<leader>sA", -- "surround Add" (line version)

				-- The main ones you'll use most:
				delete = "<leader>sd", -- "surround delete" - Delete surrounding chars
				change = "<leader>sc", -- "surround change" - Change surrounding chars
				change_line = "<leader>sC", -- "surround Change" (line version)
			},

			-- Add some helpful surrounds
			surrounds = {
				-- Custom surrounds for common patterns
				["*"] = {
					add = { "*", "*" },
					find = "%*.-%*",
					delete = "^(.)().-(.)()$",
				},
				["_"] = {
					add = { "_", "_" },
					find = "_.-_",
					delete = "^(.)().-(.)()$",
				},
				-- Markdown code blocks
				["c"] = {
					add = { "```", "```" },
					find = "```.-```",
					delete = "^(...)().-()(...)",
				},
				-- HTML/JSX tags (will prompt for tag name)
				["T"] = {
					add = function()
						local tag = vim.fn.input("Tag: ")
						return { "<" .. tag .. ">", "</" .. tag .. ">" }
					end,
					find = "<[^>]+>.-</[^>]+>",
					delete = "^(<[^>]+>)().-(</[^>]+>)()$",
				},
			},
		})

		-- Additional helpful keymaps
		local keymap = vim.keymap.set

		-- Quick surround shortcuts for common patterns
		keymap("n", "<leader>s(", "ysiw)", { desc = "Surround word with ()" })
		keymap("n", "<leader>s[", "ysiw]", { desc = "Surround word with []" })
		keymap("n", "<leader>s{", "ysiw}", { desc = "Surround word with {}" })
		keymap("n", "<leader>s'", "ysiw'", { desc = "Surround word with ''" })
		keymap("n", '<leader>s"', 'ysiw"', { desc = 'Surround word with ""' })
		keymap("n", "<leader>s`", "ysiw`", { desc = "Surround word with ``" })

		-- Visual mode shortcuts
		keymap("v", "<leader>s(", "S)", { desc = "Surround selection with ()" })
		keymap("v", "<leader>s[", "S]", { desc = "Surround selection with []" })
		keymap("v", "<leader>s{", "S}", { desc = "Surround selection with {}" })
		keymap("v", "<leader>s'", "S'", { desc = "Surround selection with ''" })
		keymap("v", '<leader>s"', 'S"', { desc = 'Surround selection with ""' })
		keymap("v", "<leader>s`", "S`", { desc = "Surround selection with ``" })

		-- Function to show surround help
		local function show_surround_help()
			local help_text = [[
🎯 NVIM-SURROUND QUICK REFERENCE

MAIN OPERATIONS:
  <leader>sd + char    →  Delete surrounding char (e.g. <leader>sd" deletes quotes)
  <leader>sc + old + new → Change surrounding (e.g. <leader>sc"' changes " to ')
  <leader>sa + motion + char → Add surround (e.g. <leader>saiw" surrounds word with ")

QUICK SHORTCUTS:
  <leader>s(   →  Surround current word with ()
  <leader>s[   →  Surround current word with []  
  <leader>s{   →  Surround current word with {}
  <leader>s'   →  Surround current word with ''
  <leader>s"   →  Surround current word with ""
  <leader>s`   →  Surround current word with ``

VISUAL MODE:
  Select text, then <leader>s( or <leader>s" etc to surround selection

EXAMPLES:
  - Change "hello" to 'hello'  →  <leader>sc"'
  - Delete (parentheses)       →  <leader>sd(  
  - Add quotes to word         →  <leader>s" (cursor on word)
  - Surround line with {}      →  <leader>sal}

CUSTOM SURROUNDS:
  <leader>sd*  →  Delete *bold* markdown
  <leader>sc_* →  Change _italic_ to *bold*
  <leader>sdc  →  Delete ```code blocks```
  <leader>sdT  →  Delete <html> tags
]]
			vim.notify(help_text, vim.log.levels.INFO, { title = "Surround Help" })
		end

		keymap("n", "<leader>s?", show_surround_help, { desc = "Show surround help" })
	end,
}
