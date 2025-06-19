return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    "williamboman/mason-lspconfig.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    local fzf = require("fzf-lua")
    local keymap = vim.keymap

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP references"
        keymap.set("n", "gr", fzf.lsp_references, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", fzf.lsp_definitions, opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", fzf.lsp_implementations, opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", fzf.lsp_typedefs, opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", fzf.diagnostics_document, opts)

        opts.desc = "Go to previous error"
        keymap.set("n", "[e", function()
          vim.diagnostic.jump({
            severity = vim.diagnostic.severity.ERROR,
            count = -1,
            float = true,
          })
        end, opts)

        opts.desc = "Go to next error"
        keymap.set("n", "]e", function()
          vim.diagnostic.jump({
            severity = vim.diagnostic.severity.ERROR,
            count = 1,
            float = true,
          })
        end, opts)

        opts.desc = "Go to previous warning/hint"
        keymap.set("n", "[d", function()
          vim.diagnostic.jump({
            severity = {
              min = vim.diagnostic.severity.HINT,
              max = vim.diagnostic.severity.WARN,
            },
            count = -1,
            float = true,
          })
        end, opts)

        opts.desc = "Go to next warning/hint"
        keymap.set("n", "]d", function()
          vim.diagnostic.jump({
            severity = {
              min = vim.diagnostic.severity.HINT,
              max = vim.diagnostic.severity.WARN,
            },
            count = 1,
            float = true,
          })
        end, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

        -- TypeScript organize imports (your original method)
        opts.desc = "Organize imports"
        keymap.set("n", "<leader>oi", function()
          if
              vim.bo.filetype == "typescript"
              or vim.bo.filetype == "typescriptreact"
              or vim.bo.filetype == "javascript"
              or vim.bo.filetype == "javascriptreact"
          then
            local params = {
              command = "_typescript.organizeImports",
              arguments = { vim.api.nvim_buf_get_name(0) },
              title = "",
            }
            vim.lsp.buf_request_sync(0, "workspace/executeCommand", params, 1000)
          end
        end, opts)
      end,
    })

    -- Simpler diagnostic configuration
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        },
      },
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
      float = {
        border = nil,
        source = "if_many",
        header = "",
        prefix = "",
      },
    })


    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup({
      ensure_installed = {
        "ts_ls",
        "lua_ls",
        "marksman",
        "bashls",
        "vimls",
      },
      automatic_enable = true,
    })
  end,
}
