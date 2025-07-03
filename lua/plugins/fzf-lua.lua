return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          default = "bat",
          layout = "horizontal",
          horizontal = "right:50%",
          border = "rounded",
        },
        border = "rounded",
        backdrop = 60,
      },

      keymap = {
        builtin = {
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
        fzf = {
          ["ctrl-q"] = "select-all+accept",
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-u"] = "preview-page-up",
        },
      },

      files = {
        prompt = "Files❯ ",
      },

      grep = {
        prompt = "Rg❯ ",
      },

      lsp = {
        prompt = "LSP❯ ",
        jump1 = true,
        ignore_current_line = true,
        async_or_timeout = 5000,
        file_icons = true,
        git_icons = false,
      },

      previewers = {
        bat = {
          cmd = "bat",
          args = "--color=always --style=numbers,changes",
        },
      },
    })

    fzf.register_ui_select()

    vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "Search Keymaps" })
    vim.keymap.set("n", "<leader><leader>", fzf.files, { desc = "Search Files" })
    vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Search by Grep" })
    vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Search Diagnostics" })
    vim.keymap.set("n", "<leader>sb", fzf.buffers, { desc = "Search Buffers" })
    vim.keymap.set("n", "<leader>sh", fzf.help_tags, { desc = "Search Help Tags" })
    vim.keymap.set("n", "<leader>sm", fzf.marks, { desc = "Search Marks" })
    vim.keymap.set("n", "<leader>so", fzf.oldfiles, { desc = "Search Old Files" })
  end,
}
