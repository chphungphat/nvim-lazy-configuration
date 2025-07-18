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
          width = 0.8,
          height = 0.8,
        },

        PATH = "prepend",
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
        max_concurrent_installers = 6,

        log_level = vim.log.levels.INFO,
        pip = {
          upgrade_pip = false,
        },
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
          "stylua", --
          "prettier",
          "shfmt",
          "clang-format", --
        },

        auto_update = true,
        run_on_start = true,
        start_delay = 5000,
        debounce_hours = 48,
      })
    end,
  },

  {
    "rshkarin/mason-nvim-lint",
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-lint",
    },
    config = function()
      require("mason-nvim-lint").setup({
        automatic_installation = true,

        ensure_installed = {
          "eslint_d",
          "shellcheck",
          "yamllint", --
          "jsonlint", --

          "stylelint",

          "cpplint",

          "hadolint",

        },

        quiet_mode = true,
      })
    end,
  },
}
