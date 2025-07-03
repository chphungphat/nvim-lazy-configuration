return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
          border = "rounded",
        },

        PATH = "prepend",

        install_root_dir = vim.fn.stdpath("data") .. "/mason",

        max_concurrent_installers = 4,
      })

      vim.keymap.set("n", "<leader>mm", "<cmd>Mason<CR>", { desc = "Open Mason" })
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "bashls",
          "jsonls",
          "yamlls",
          "html",
          "cssls",
          "marksman",
          "clangd",
        },

        automatic_installation = true,
        automatic_setup = false,
      })
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "prettier",
          "shfmt",
          "black",
          "isort",

          "shellcheck",

          "clang-format",
          "codelldb",
        },

        auto_update = false,
        run_on_start = false,
        start_delay = 3000,
        debounce_hours = 24,
      })
    end,
  },
}
