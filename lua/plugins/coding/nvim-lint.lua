return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Configure linters by filetype
    lint.linters_by_ft = {
      -- JavaScript/TypeScript
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      vue = { "eslint_d" },
      svelte = { "eslint_d" },

      -- Python
      python = { "pylint", "ruff" },

      -- Shell scripting
      bash = { "shellcheck" },
      sh = { "shellcheck" },

      -- JSON
      json = { "jsonlint" },

      -- YAML
      yaml = { "yamllint" },

      -- Markdown
      markdown = { "markdownlint" },

      -- Lua (using luacheck if available)
      lua = { "luacheck" },

      -- CSS/SCSS
      css = { "stylelint" },
      scss = { "stylelint" },

      -- Docker
      dockerfile = { "hadolint" },

      -- C/C++
      c = { "cppcheck" },
      cpp = { "cppcheck" },
    }

    -- Customize specific linters
    -- Fix pylint for virtual environments
    if os.getenv("VIRTUAL_ENV") then
      lint.linters.pylint.cmd = "python"
      lint.linters.pylint.args = {
        "-m", "pylint",
        "-f", "json",
        "--from-stdin",
        function() return vim.api.nvim_buf_get_name(0) end
      }
    end

    -- Configure luacheck for Neovim
    lint.linters.luacheck.args = {
      "--globals", "vim",
      "--read-globals", "vim",
      "--no-max-line-length",
      "--formatter", "plain",
      "--codes",
      "--ranges",
      "-"
    }

    -- Create autocommand group for linting
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    -- Auto-lint on these events
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Only lint if the buffer is valid and has a filetype
        local bufnr = vim.api.nvim_get_current_buf()
        local ft = vim.bo[bufnr].filetype

        if ft ~= "" and vim.bo[bufnr].modifiable then
          lint.try_lint()
        end
      end,
    })

    -- Manual linting keymap
    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "Lint current file" })

    -- Show running linters in statusline (optional)
    vim.keymap.set("n", "<leader>li", function()
      local linters = lint.get_running()
      if #linters == 0 then
        vim.notify("No linters running", vim.log.levels.INFO)
      else
        vim.notify("Running linters: " .. table.concat(linters, ", "), vim.log.levels.INFO)
      end
    end, { desc = "Show running linters" })

    -- Toggle linting on/off
    vim.g.lint_enabled = true
    vim.keymap.set("n", "<leader>lt", function()
      vim.g.lint_enabled = not vim.g.lint_enabled
      if vim.g.lint_enabled then
        vim.notify("Linting enabled", vim.log.levels.INFO)
        lint.try_lint()
      else
        vim.notify("Linting disabled", vim.log.levels.WARN)
        -- Clear existing diagnostics from linters
        vim.diagnostic.reset(vim.diagnostic.get_namespace("lint"))
      end
    end, { desc = "Toggle linting" })

    -- Override try_lint to respect the toggle
    local original_try_lint = lint.try_lint
    lint.try_lint = function(...)
      if vim.g.lint_enabled then
        original_try_lint(...)
      end
    end
  end,
}
