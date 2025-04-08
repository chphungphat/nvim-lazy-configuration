return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local scheme = vim.g.colors_name or "kanagawa"

		local palette = {
			["gruvbox-material"] = {
				chunk_style = "#d47d26",
			},
			["kanagawa"] = {
				chunk_style = "#FFA066",
			},
		}

		local color = (palette[scheme] or palette["gruvbox-material"]).chunk_style

		require("hlchunk").setup({
			indent = {
				enable = true,
				priority = 10,
				chars = { "│" },
				exclude_filetypes = {
					oil_preview = true,
					oil = true,
					TelescopePrompt = true,
					notify = true,
					copilot_chat = true,
					fidget = true,
					NvimTree = true,
					NeogitStatus = true,
				},
			},
			chunk = {
				enable = true,
				priority = 15,
				chars = {
					horizontal_line = "─",
					vertical_line = "│",
					left_top = "┌",
					left_bottom = "└",
					right_arrow = "─",
				},
				style = color,
				duration = 50,
				delay = 50,
			},
		})

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.schedule(function()
					vim.cmd("silent! lua require('hlchunk').disable()")
					vim.cmd("silent! lua require('hlchunk').enable()")
				end)
			end,
		})
	end,
}
