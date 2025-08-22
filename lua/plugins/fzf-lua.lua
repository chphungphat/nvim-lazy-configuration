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
        cwd_prompt = false,
        actions = {
          ["default"] = require("fzf-lua.actions").file_edit,
        },
      },

      grep = {
        prompt = "Rg❯ ",
        input_prompt = "Grep For❯ ",
        actions = {
          ["default"] = require("fzf-lua.actions").file_edit,
        },
      },

      lsp = {
        prompt_postfix = "❯ ",
        jump_to_single_result = true,
        ignore_current_line = true,
        async_or_timeout = 5000,
        file_icons = true,
        git_icons = false,
        symbols = {
          async_or_timeout = true,
          symbol_style = 1,
        },
        code_actions = {
          previewer = "codeaction_native",
          preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS",
        },
      },

      previewers = {
        bat = {
          cmd = "bat",
          args = "--color=always --style=numbers,changes",
          theme = "gruvbox-dark",
        },
        builtin = {
          syntax = true,
          syntax_limit_l = 0,
          syntax_limit_b = 1024 * 1024, -- 1MB
          limit_b = 1024 * 1024 * 10,   -- 10MB
          treesitter = { enabled = true },
        },
      },

      buffers = {
        prompt = "Buffers❯ ",
        file_icons = true,
        color_icons = true,
        sort_lastused = true,
        actions = {
          ["default"] = require("fzf-lua.actions").buf_edit,
          ["ctrl-d"] = require("fzf-lua.actions").buf_del,
        },
      },

      oldfiles = {
        prompt = "Recent❯ ",
        cwd_only = false,
        stat_file = true,
        include_current_session = true,
      },

      quickfix = {
        file_icons = true,
        git_icons = false,
      },

      defaults = {
        file_icons = true,
        git_icons = true,
        color_icons = true,
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

    vim.keymap.set("n", "<leader>sg", fzf.git_files, { desc = "Search Git Files" })
    vim.keymap.set("n", "<leader>sc", fzf.grep_cword, { desc = "Search Word Under Cursor" })
    vim.keymap.set("n", "<leader>sC", fzf.grep_cWORD, { desc = "Search WORD Under Cursor" })
    vim.keymap.set("v", "<leader>sv", fzf.grep_visual, { desc = "Search Visual Selection" })
    vim.keymap.set("n", "<leader>sr", fzf.resume, { desc = "Resume Last Search" })

    vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git Status" })
    vim.keymap.set("n", "<leader>gc", fzf.git_commits, { desc = "Git Commits" })
    vim.keymap.set("n", "<leader>gb", fzf.git_bcommits, { desc = "Git Buffer Commits" })

    vim.keymap.set("n", "<leader>sq", fzf.quickfix, { desc = "Quickfix List" })
    vim.keymap.set("n", "<leader>sl", fzf.loclist, { desc = "Location List" })
  end,
}
