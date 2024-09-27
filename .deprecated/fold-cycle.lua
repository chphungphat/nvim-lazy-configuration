return {
	"jghauser/fold-cycle.nvim",
	config = function()
		require("fold-cycle").setup({
			open_if_max_closed = true, -- Open all folds if all folds are closed
			close_if_max_opened = true, -- Close all folds if all folds are open
			softwrap_movement_fix = true, -- Adds a virtual cursor column to fix softwrap issues
		})

		-- Keymaps
		vim.keymap.set("n", "<tab>", function()
			return require("fold-cycle").open()
		end, { silent = true, desc = "Fold-cycle: open folds" })
		vim.keymap.set("n", "<s-tab>", function()
			return require("fold-cycle").close()
		end, { silent = true, desc = "Fold-cycle: close folds" })
		vim.keymap.set("n", "zC", function()
			return require("fold-cycle").close_all()
		end, { remap = true, silent = true, desc = "Fold-cycle: close all folds" })
	end,
}
