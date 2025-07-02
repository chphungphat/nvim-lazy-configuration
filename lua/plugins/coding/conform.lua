return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>ff",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer or selection",
    },
  },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },

        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },

        -- Python
        python = { "isort", "black" },

        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },

        -- Fallbacks for any file
        ["_"] = { "trim_whitespace" }, -- Clean up whitespace for all files
      },

      -- Smart format on save - only when formatters are available
      format_on_save = function(bufnr)
        -- Skip for large files (>1MB)
        local max_filesize = 1024 * 1024
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size and stats.size > max_filesize then
          return
        end

        -- Skip for readonly files
        if vim.bo[bufnr].readonly then
          return
        end

        -- Skip for certain paths
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local ignore_patterns = { "node_modules", "%.git/", "vendor/", "target/" }
        for _, pattern in ipairs(ignore_patterns) do
          if bufname:match(pattern) then
            return
          end
        end

        return {
          timeout_ms = 1000,
          lsp_fallback = true,
          quiet = true,
        }
      end,

      formatters = {
        prettier = {
          condition = function(_, ctx)
            local cwd = vim.fs.dirname(ctx.filename)
            local prettier_files = {
              ".prettierrc", ".prettierrc.json", ".prettierrc.js",
              ".prettierrc.yml", ".prettierrc.yaml", "prettier.config.js"
            }

            for _, file in ipairs(prettier_files) do
              if vim.uv.fs_stat(cwd .. "/" .. file) ~= nil then
                return true
              end
            end

            local package_json = cwd .. "/package.json"
            if vim.uv.fs_stat(package_json) ~= nil then
              local ok, content = pcall(vim.fn.readfile, package_json)
              if ok and content then
                local json_str = table.concat(content, "\n")
                return json_str:match('"prettier"') ~= nil
              end
            end

            return true
          end,
        },

        stylua = {
          condition = function(_, ctx)
            local cwd = vim.fs.dirname(ctx.filename)
            return vim.uv.fs_stat(cwd .. "/stylua.toml") ~= nil or
                vim.uv.fs_stat(cwd .. "/.stylua.toml") ~= nil
          end,
        },

        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
      },

      format_after_save = {
        lsp_fallback = true,
      },

      notify_on_error = true,
      notify_no_formatters = false,
    })

    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, lsp_fallback = true, range = range })
    end, { range = true, desc = "Format buffer or range" })

    vim.api.nvim_create_user_command("FormatToggle", function()
      if vim.g.disable_autoformat then
        vim.g.disable_autoformat = false
        vim.notify("Format on save enabled", vim.log.levels.INFO)
      else
        vim.g.disable_autoformat = true
        vim.notify("Format on save disabled", vim.log.levels.WARN)
      end
    end, { desc = "Toggle format on save" })
  end,
}
