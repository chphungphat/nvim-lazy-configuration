if true then
	return {}
end
return {
	"L3MON4D3/LuaSnip",
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		local luasnip = require("luasnip")
		local types = require("luasnip.util.types")

		-- Load friendly-snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Basic configuration
		luasnip.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = true,
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { "●", "GruvboxOrange" } },
					},
				},
				[types.insertNode] = {
					active = {
						virt_text = { { "●", "GruvboxBlue" } },
					},
				},
			},
		})

		-- Key mappings
		-- vim.api.nvim_set_keymap(
		-- 	"i",
		-- 	"<C-k>",
		-- 	"<cmd>lua require'luasnip'.expand_or_jump()<CR>",
		-- 	{ noremap = true, silent = true }
		-- )
		-- vim.api.nvim_set_keymap(
		-- 	"s",
		-- 	"<C-k>",
		-- 	"<cmd>lua require'luasnip'.expand_or_jump()<CR>",
		-- 	{ noremap = true, silent = true }
		-- )
		-- vim.api.nvim_set_keymap(
		-- 	"i",
		-- 	"<C-j>",
		-- 	"<cmd>lua require'luasnip'.jump(-1)<CR>",
		-- 	{ noremap = true, silent = true }
		-- )
		-- vim.api.nvim_set_keymap(
		-- 	"s",
		-- 	"<C-j>",
		-- 	"<cmd>lua require'luasnip'.jump(-1)<CR>",
		-- 	{ noremap = true, silent = true }
		-- )
	end,
}
