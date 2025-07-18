return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile", "BufWritePost" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      -- Web Development
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      vue = { "eslint_d" },

      -- Styles
      css = { "stylelint" },
      scss = { "stylelint" },

      -- Shell
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },

      -- Config files
      dockerfile = { "hadolint" },
      yaml = { "yamllint" },
      json = { "jsonlint" },

      -- C/C++ (only if no LSP or additional checking needed)
      c = { "cpplint" },
      cpp = { "cpplint" },

      -- REMOVED: lua = { "selene" } - let lua_ls handle Lua diagnostics
    }

    -- Simple and safe lint function with comprehensive ignore patterns
    local function lint_current_buffer()
      -- Check if linting is globally disabled
      if vim.g.lint_disabled then
        return
      end

      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname == "" then
        return
      end

      -- Comprehensive ignore patterns to prevent linting unwanted files
      local ignore_patterns = {
        -- Version control
        "%.git/", "%.svn/", "%.hg/",

        -- Dependencies
        "node_modules/", "vendor/", "%.yarn/", "%.pnpm/",

        -- Build directories
        "target/", "build/", "dist/", "out/", "%.next/", "%.nuxt/", "%.vite/", "coverage/",

        -- Cache directories
        "%.cache/", "%.temp/", "%.tmp/", "%.turbo/",

        -- Generated and config files
        "%-lock%.json$", "%.lock$", "%.min%.js$", "%.min%.css$", "%.bundle%.js$",

        -- Config files that usually cause ESLint ignore warnings
        "%.config%.js$", "%.config%.ts$", "%.config%.mjs$",
        "tailwind%.config%.js$", "vite%.config%.js$", "vite%.config%.ts$",
        "next%.config%.js$", "webpack%.config%.js$", "rollup%.config%.js$",
        "postcss%.config%.js$", "babel%.config%.js$"
      }

      -- Check against ignore patterns
      for _, pattern in ipairs(ignore_patterns) do
        if bufname:match(pattern) then
          return
        end
      end

      -- Skip large files for performance
      local max_filesize = 1024 * 1024 -- 1MB
      local ok, stats = pcall(vim.uv.fs_stat, bufname)
      if ok and stats and stats.size and stats.size > max_filesize then
        return
      end

      -- Skip readonly files
      if vim.bo.readonly then
        return
      end

      -- Run the linter
      lint.try_lint()
    end

    -- Debounced linting for better performance
    local timer = nil
    local function debounced_lint()
      if timer then
        timer:stop()
        timer = nil
      end
      timer = vim.defer_fn(function()
        lint_current_buffer()
        timer = nil
      end, 300) -- 300ms debounce
    end

    -- Create autocommand group
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    -- Optimized autocmd events
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      group = lint_augroup,
      callback = lint_current_buffer,
    })

    -- Use debounced version for frequent events
    vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
      group = lint_augroup,
      callback = debounced_lint,
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })

    vim.keymap.set("n", "<leader>lt", function()
      vim.g.lint_disabled = not vim.g.lint_disabled
      if vim.g.lint_disabled then
        vim.notify("Linting disabled", vim.log.levels.WARN)
        -- Clear existing diagnostics from all lint namespaces
        for name, _ in pairs(lint.linters) do
          local namespace = lint.get_namespace(name)
          if namespace then
            vim.diagnostic.reset(namespace)
          end
        end
      else
        vim.notify("Linting enabled", vim.log.levels.INFO)
        lint_current_buffer()
      end
    end, { desc = "Toggle linting on/off" })

    vim.keymap.set("n", "<leader>lr", function()
      local running_linters = lint.get_running()
      if #running_linters == 0 then
        vim.notify("No linters running", vim.log.levels.INFO)
      else
        vim.notify("Running linters: " .. table.concat(running_linters, ", "), vim.log.levels.INFO)
      end
    end, { desc = "Show running linters" })
  end,
}
