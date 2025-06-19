return {
  "nvim-focus/focus.nvim",
  version = "*", -- Use latest stable version
  event = "VeryLazy",
  config = function()
    require("focus").setup({
      enable = true,                  -- Enable module
      commands = true,                -- Create Focus commands
      autoresize = {
        enable = true,                -- Enable or disable auto-resizing of splits
        width = 0,                    -- Force width for the focused window (0 = golden ratio)
        height = 0,                   -- Force height for the focused window (0 = golden ratio)
        minwidth = 20,                -- Force minimum width for the unfocused window
        minheight = 5,                -- Force minimum height for the unfocused window
        focusedwindow_minwidth = 30,  -- Force minimum width for the focused window
        focusedwindow_minheight = 10, -- Force minimum height for the focused window
        height_quickfix = 10,         -- Set the height of quickfix panel
      },
      split = {
        bufnew = false, -- Create blank buffer for new split windows
        tmux = false,   -- Create tmux splits instead of neovim splits
      },
      ui = {
        number = false,                    -- Display line numbers in the focussed window only
        relativenumber = false,            -- Display relative line numbers in the focussed window only
        hybridnumber = false,              -- Display hybrid line numbers in the focussed window only
        absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocussed windows
        cursorline = true,                 -- Display a cursorline in the focussed window only
        cursorcolumn = false,              -- Display cursorcolumn in the focussed window only
        colorcolumn = {
          enable = false,                  -- Display colorcolumn in the foccused window only
          list = "+1",                     -- Set the comma-separated list for the colorcolumn
        },
        signcolumn = true,                 -- Display signcolumn in the focussed window only
        winhighlight = false,              -- Auto highlighting for focussed/unfocussed windows
      },
    })

    -- Disable focus for specific filetypes and buftypes that shouldn't be auto-resized
    -- UPDATED: Changed "NvimTree" to "neo-tree" and "NeogitStatus" references
    local ignore_filetypes = {
      "NvimTree",
      "neo-tree",
      "neo-tree-popup",
      "TelescopePrompt",
      "oil",
      "oil_preview",
      "copilot-chat",
      "NeogitStatus",
      "fzf",
      "qf", -- quickfix
      "help",
      "man",
      "lspinfo",
      "lsp-installer",
      "null-ls-info",
      "checkhealth",
    }

    local ignore_buftypes = {
      "nofile",
      "prompt",
      "popup",
      "terminal",
      "quickfix",
      "help",
    }

    local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

    -- Disable focus for certain buffer types
    vim.api.nvim_create_autocmd("WinEnter", {
      group = augroup,
      callback = function(_)
        if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
          vim.w.focus_disable = true
        else
          vim.w.focus_disable = false
        end
      end,
      desc = "Disable focus autoresize for BufType",
    })

    -- Disable focus for certain file types
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      callback = function(_)
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
          vim.b.focus_disable = true
        else
          vim.b.focus_disable = false
        end
      end,
      desc = "Disable focus autoresize for FileType",
    })
  end,

  keys = {
    {
      "<leader>wf",
      "<cmd>FocusToggle<CR>",
      desc = "Toggle Focus autoresize",
    },
  },
}
