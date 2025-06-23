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

    -- MODERN: Enhanced diagnostic configuration (removes deprecation warnings)
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

      -- MODERN: Enhanced floating window styling
      float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
        max_width = 80,
        max_height = 20,
        style = "minimal",
        focusable = true,
      },
    })

    -- FIXED: Enhanced LSP highlight groups with better contrast
    local function setup_lsp_highlights()
      local scheme = vim.g.colors_name or "gruvbox-material"

      local colors = {
        ["gruvbox-material"] = {
          -- ENHANCED: Better contrast for LSP floating windows
          float_bg = "#1d2021",     -- Much darker background
          float_border = "#7c6f64", -- Brighter border for visibility
          float_title = "#fabd2f",  -- Bright yellow title

          normal_bg = "#282828",    -- Your main background

          -- Diagnostic colors
          error_fg = "#fb4934",
          warn_fg = "#fabd2f",
          info_fg = "#83a598",
          hint_fg = "#8ec07c",

          -- LSP references/definitions
          reference_bg = "#45403d",
          definition_bg = "#45403d",
        },
      }

      local c = colors[scheme] or colors["gruvbox-material"]

      -- FIXED: Much better contrast for LSP floating windows
      vim.api.nvim_set_hl(0, "NormalFloat", {
        bg = c.float_bg,
        fg = "#ebdbb2" -- Bright foreground for good contrast
      })
      vim.api.nvim_set_hl(0, "FloatBorder", {
        fg = c.float_border,
        bg = c.float_bg -- Same background as float for seamless border
      })
      vim.api.nvim_set_hl(0, "FloatTitle", {
        fg = c.float_title,
        bg = c.float_bg,
        bold = true
      })

      -- Ensure diagnostic floats also have good contrast
      vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = c.error_fg, bg = c.float_bg })
      vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { fg = c.warn_fg, bg = c.float_bg })
      vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { fg = c.info_fg, bg = c.float_bg })
      vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { fg = c.hint_fg, bg = c.float_bg })

      -- LSP reference/definition highlighting
      vim.api.nvim_set_hl(0, "LspReferenceText", { bg = c.reference_bg })
      vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = c.reference_bg })
      vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = c.definition_bg, bold = true })

      -- Signature help styling
      vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
        bg = c.float_bg,
        fg = c.float_title,
        bold = true,
        underline = true
      })
    end

    setup_lsp_highlights()

    -- Reapply on colorscheme change
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(setup_lsp_highlights)
      end,
    })

    -- FIXED: Modern auto-highlight references under cursor with proper API usage
    local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = highlight_group,
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- FIXED: Pass buffer as second argument (required in Neovim 0.11+)
        if client and client:supports_method("textDocument/documentHighlight", event.buf) then
          vim.api.nvim_create_autocmd("CursorHold", {
            buffer = event.buf,
            callback = function()
              vim.lsp.buf.document_highlight()
            end,
          })

          vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = event.buf,
            callback = function()
              vim.lsp.buf.clear_references()
            end,
          })
        end
      end,
    })
  end,
}
