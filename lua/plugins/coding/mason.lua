return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
    },
    config = function()
      local mason = require("mason")

      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
          keymaps = {
            toggle_package_expand = "<CR>",
            install_package = "i",
            update_package = "u",
            check_package_version = "c",
            update_all_packages = "U",
            check_outdated_packages = "C",
            uninstall_package = "X",
            cancel_installation = "<C-c>",
            apply_language_filter = "<C-f>",
          },
        },
      })

      vim.keymap.set("n", "<leader>mm", "<cmd>Mason<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        -- Install these language servers through Mason
        ensure_installed = {
          "ts_ls",    -- TypeScript Language Server (reliable alternative to VTSLS)
          "lua_ls",   -- Lua language server
          "bashls",   -- Bash language server
          "vimls",    -- Vim language server
          "marksman", -- Markdown language server
          "jsonls",   -- JSON language server
          "yamlls",   -- YAML language server
          "html",     -- HTML language server
          "cssls",    -- CSS language server
          -- "eslint",   -- ESLint language server
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "prettier", -- Prettier formatter
          "stylua",   -- Lua formatter
          "shfmt",    -- Shell script formatter
          "black",    -- Python formatter
          "isort",    -- Python import sorter

          -- Linters (remove luacheck if it's causing issues)
          -- "eslint_d",   -- ESLint daemon
          "shellcheck", -- Shell script linter
          -- "luacheck", -- Lua linter (removed due to installation issues)
        },
        auto_update = false,  -- Disable auto-update to prevent issues
        run_on_start = false, -- Don't run on start to prevent startup delays
      })
    end,
  },
}
