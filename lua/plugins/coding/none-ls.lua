if true then
  return {}
end
return {
  "nvimtools/none-ls.nvim",
  ft = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    local eslint_disable_rule = {
      method = null_ls.methods.CODE_ACTION,
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
      generator = {
        fn = function(params)
          local actions = {}

          -- Get diagnostics for current line
          local diagnostics = vim.diagnostic.get(params.bufnr, {
            lnum = params.row - 1
          })

          for _, diagnostic in ipairs(diagnostics) do
            if diagnostic.source == "eslint" and diagnostic.code then
              local rule = tostring(diagnostic.code)

              -- Action to disable rule for next line
              table.insert(actions, {
                title = "Disable ESLint rule '" .. rule .. "' for this line",
                action = function()
                  local line_num = params.row
                  local comment = "// eslint-disable-next-line " .. rule
                  vim.api.nvim_buf_set_lines(params.bufnr, line_num - 1, line_num - 1, false, { comment })
                end,
              })

              -- Action to disable rule for entire file
              table.insert(actions, {
                title = "Disable ESLint rule '" .. rule .. "' for entire file",
                action = function()
                  local comment = "/* eslint-disable " .. rule .. " */"
                  vim.api.nvim_buf_set_lines(params.bufnr, 0, 0, false, { comment, "" })
                end,
              })

              -- Action to open ESLint documentation
              table.insert(actions, {
                title = "Open ESLint documentation for '" .. rule .. "'",
                action = function()
                  local url = "https://eslint.org/docs/rules/" .. rule
                  local open_cmd
                  if vim.fn.has("mac") == 1 then
                    open_cmd = "open"
                  elseif vim.fn.has("unix") == 1 then
                    open_cmd = "xdg-open"
                  elseif vim.fn.has("win32") == 1 then
                    open_cmd = "start"
                  end

                  if open_cmd then
                    vim.fn.system(open_cmd .. " " .. url)
                    vim.notify("Opening ESLint docs for: " .. rule, vim.log.levels.INFO)
                  end
                end,
              })
            end
          end

          return actions
        end,
      },
    }

    null_ls.setup({
      sources = {
        -- ESLint diagnostics and code actions
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.code_actions.eslint_d,

        -- Custom ESLint disable rule actions
        eslint_disable_rule,

        -- Formatting
        null_ls.builtins.formatting.prettier,
      },

      -- Enhanced on_attach for better ESLint integration
      on_attach = function(client, bufnr)
        -- Auto-format on save if formatter is available
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(c)
                  return c.name == "null-ls"
                end,
              })
            end,
          })
        end
      end,
    })

    -- Quick keymap for ESLint-specific actions
    vim.keymap.set("n", "<leader>ce", function()
      local line = vim.fn.line(".")
      local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })
      local eslint_diagnostic = nil

      for _, d in ipairs(diagnostics) do
        if d.source == "eslint" and d.code then
          eslint_diagnostic = d
          break
        end
      end

      if not eslint_diagnostic then
        vim.notify("No ESLint rule found on current line", vim.log.levels.WARN)
        return
      end

      local rule = tostring(eslint_diagnostic.code)
      local choices = {
        "Disable for this line",
        "Disable for entire file",
        "Open documentation",
      }

      vim.ui.select(choices, {
        prompt = "ESLint rule '" .. rule .. "':",
        format_item = function(item)
          return "🔧 " .. item
        end,
      }, function(choice)
        if not choice then return end

        if choice:match("this line") then
          local comment = "// eslint-disable-next-line " .. rule
          vim.api.nvim_buf_set_lines(0, line - 1, line - 1, false, { comment })
        elseif choice:match("entire file") then
          local comment = "/* eslint-disable " .. rule .. " */"
          vim.api.nvim_buf_set_lines(0, 0, 0, false, { comment, "" })
        elseif choice:match("documentation") then
          local url = "https://eslint.org/docs/rules/" .. rule
          local open_cmd = vim.fn.has("mac") == 1 and "open" or
              vim.fn.has("unix") == 1 and "xdg-open" or
              vim.fn.has("win32") == 1 and "start" or nil
          if open_cmd then
            vim.fn.system(open_cmd .. " " .. url)
            vim.notify("Opening ESLint docs for: " .. rule, vim.log.levels.INFO)
          end
        end
      end)
    end, { desc = "ESLint rule actions" })
  end,
}
