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
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters (existing)
          "stylua",
          "prettier",
          "shfmt",
          "clang_format",
          "black",
          "isort",

          -- Linters (new additions)
          "eslint_d",     -- JavaScript/TypeScript linter (faster than eslint)
          "pylint",       -- Python linter
          "ruff",         -- Python linter/formatter (very fast)
          "shellcheck",   -- Shell script linter
          "jsonlint",     -- JSON linter
          "yamllint",     -- YAML linter
          "markdownlint", -- Markdown linter
          "luacheck",     -- Lua linter
          "stylelint",    -- CSS/SCSS linter
          "hadolint",     -- Dockerfile linter
          "cppcheck",     -- C/C++ linter
        },

        auto_update = true,
        run_on_start = true,
        start_delay = 3000,
        debounce_hours = 24,
      })
    end,
  },
}
