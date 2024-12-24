return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	version = "*",
	build = function()
		-- Get the installation path
		local install_path = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim"
		local app_path = install_path .. "/app"

		-- Clean up existing node_modules if present
		if vim.fn.isdirectory(app_path .. "/node_modules") == 1 then
			if vim.fn.has("win32") == 1 then
				vim.fn.system("rmdir /s /q " .. vim.fn.shellescape(app_path .. "/node_modules"))
			else
				vim.fn.system({ "rm", "-rf", app_path .. "/node_modules" })
			end
		end

		-- Perform fresh installation
		vim.fn.system({
			"npm",
			"install",
			"--prefix",
			app_path,
		})
	end,
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }

		-- Ensure node is available (useful for NVM environments)
		if vim.fn.executable("node") == 1 then
			vim.g.mkdp_node_host_proc = vim.fn.exepath("node")
		end

		-- Create a more robust update command
		vim.api.nvim_create_user_command("MarkdownPreviewUpdate", function()
			-- Get the installation path
			local install_path = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim"

			-- Remove the installation directory if it exists
			if vim.fn.isdirectory(install_path) == 1 then
				if vim.fn.has("win32") == 1 then
					vim.fn.system("rmdir /s /q " .. vim.fn.shellescape(install_path))
				else
					vim.fn.system({ "rm", "-rf", install_path })
				end
			end

			-- Schedule the reload of the plugin
			vim.schedule(function()
				-- Load Lazy properly
				local lazy = require("lazy")
				-- Use Lazy's API to reload the plugin
				lazy.reload({ plugins = { "markdown-preview.nvim" } })
			end)
		end, {})
	end,
	ft = { "markdown" },
	keys = {
		{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
	},
	config = function()
		-- Basic configuration
		vim.g.mkdp_auto_start = 0
		vim.g.mkdp_auto_close = 1
		vim.g.mkdp_refresh_slow = 0

		-- Browser settings
		vim.g.mkdp_browser = ""
		vim.g.mkdp_port = ""

		-- Preview window settings
		vim.g.mkdp_preview_options = {
			sync_scroll_type = "middle",
			reload_sync = 1000,
		}

		-- Command settings
		vim.g.mkdp_command_for_global = 0
		vim.g.mkdp_open_to_the_world = 0

		-- Page title settings
		vim.g.mkdp_page_title = "「${name}」"

		vim.g.mkdp_open_ip = ""
		vim.g.mkdp_echo_preview_url = 1
	end,
}
