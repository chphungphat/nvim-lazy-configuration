return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = function()
		vim.fn.system("cd app && yarn install")
	end,
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	keys = {
		{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
	},
	config = function()
		vim.g.mkdp_auto_start = 0
		vim.g.mkdp_auto_close = 1
		vim.g.mkdp_refresh_slow = 0
		vim.g.mkdp_browser = ""
		vim.g.mkdp_port = ""
		vim.g.mkdp_refresh_slow = 0
		vim.g.mkdp_markdown_css = ""
		vim.g.mkdp_highlight_css = ""
		vim.g.mkdp_preview_options = {
			sync_scroll_type = "middle",
			reload_sync = 1000,
		}
	end,
}
