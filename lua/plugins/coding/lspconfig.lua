return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "mason-org/mason-lspconfig.nvim", dependencies = { "mason-org/mason.nvim" } },
  },
  config = function()
    local lspconfig = require("lspconfig")

    -- Enhanced capabilities for better completion
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if pcall(require, "blink.cmp") then
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    end

    -- Performance optimizations
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { "documentation", "detail", "additionalTextEdits" }
    }

    -- LSP attach function with optimized keymaps and error handling
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(event)
        local opts = { buffer = event.buf, silent = true }
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Safety check
        if not client then
          return
        end

        -- Navigation with fzf-lua (faster than built-in)
        vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>",
          vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gD", "<cmd>FzfLua lsp_declarations jump1=true ignore_current_line=true<cr>",
          vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>",
          vim.tbl_extend("force", opts, { desc = "Show references" }))
        vim.keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>",
          vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        vim.keymap.set("n", "gt", "<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>",
          vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

        -- Symbols
        vim.keymap.set("n", "<leader>cs", "<cmd>FzfLua lsp_document_symbols<cr>",
          vim.tbl_extend("force", opts, { desc = "Document symbols" }))
        vim.keymap.set("n", "<leader>cS", "<cmd>FzfLua lsp_workspace_symbols<cr>",
          vim.tbl_extend("force", opts, { desc = "Workspace symbols" }))
        vim.keymap.set("n", "<leader>cf", "<cmd>FzfLua lsp_finder<cr>",
          vim.tbl_extend("force", opts, { desc = "LSP Finder (all locations)" }))

        -- Actions
        vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>",
          vim.tbl_extend("force", opts, { desc = "Code actions" }))
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename,
          vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

        -- Documentation
        vim.keymap.set("n", "K", vim.lsp.buf.hover,
          vim.tbl_extend("force", opts, { desc = "Show hover documentation" }))

        -- Improved diagnostic navigation
        vim.keymap.set("n", "[e", function()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -1 })
        end, vim.tbl_extend("force", opts, { desc = "Previous Error" }))

        vim.keymap.set("n", "]e", function()
          vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1 })
        end, vim.tbl_extend("force", opts, { desc = "Next Error" }))

        vim.keymap.set("n", "[d", function()
          vim.diagnostic.jump({
            severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.HINT, vim.diagnostic.severity.INFO },
            count = -1,
          })
        end, vim.tbl_extend("force", opts, { desc = "Previous Warning/Info/Hint" }))

        vim.keymap.set("n", "]d", function()
          vim.diagnostic.jump({
            severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.HINT, vim.diagnostic.severity.INFO },
            count = 1,
          })
        end, vim.tbl_extend("force", opts, { desc = "Next Warning/Info/Hint" }))

        vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float,
          vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))

        -- Language-specific keymaps
        if client and client.name == "ts_ls" then
          vim.keymap.set("n", "<leader>oi", function()
            local params = {
              command = "_typescript.organizeImports",
              arguments = { vim.api.nvim_buf_get_name(0) },
              title = "Organize Imports",
            }
            vim.lsp.buf_request(0, "workspace/executeCommand", params)
          end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
        end

        -- C/C++ specific keymaps
        if client and client.name == "clangd" then
          vim.keymap.set("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>",
            vim.tbl_extend("force", opts, { desc = "Switch Source/Header (C/C++)" }))
        end
      end,
    })

    -- Optimized diagnostic configuration
    vim.diagnostic.config({
      virtual_text = {
        spacing = 4,
        prefix = "●",
        source = "if_many",
        severity = { min = vim.diagnostic.severity.WARN }, -- Hide hints in virtual text
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        },
      },
      underline = true,
      update_in_insert = false, -- Better performance
      severity_sort = true,
      float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
        focusable = false, -- Prevent accidental focus
      },
    })

    -- Server configurations
    local server_configs = {
      lua_ls = {
        settings = {
          Lua = {
            -- Enhanced Lua settings for better Neovim development
            diagnostics = {
              globals = { "vim" },
              disable = { "missing-fields" }, -- Reduce noise
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
            telemetry = { enable = false },
            completion = {
              callSnippet = "Replace",
              keywordSnippet = "Replace",
            },
          },
        },
      },

      ts_ls = {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "literal",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = false,
              includeInlayVariableTypeHints = false,
              includeInlayPropertyDeclarationTypeHints = false,
              includeInlayFunctionLikeReturnTypeHints = false,
              includeInlayEnumMemberValueHints = false,
            },
            preferences = {
              importModuleSpecifier = "relative",
            },
          },
          javascript = {
            preferences = {
              importModuleSpecifier = "relative",
            },
          },
        },
      },

      clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
          "--pch-storage=memory", -- Performance optimization
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        capabilities = vim.tbl_extend("force", capabilities, {
          offsetEncoding = { "utf-16" },
        }),
      },
    }

    -- Servers that should not provide formatting (handled by conform.nvim)
    local disable_formatting = {
      "ts_ls",
      "lua_ls",
      "clangd",
      "jsonls",
      "yamlls",
      "html",
      "cssls",
    }

    -- Mason LSP setup with performance optimizations
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
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
      handlers = {
        function(server_name)
          local config = {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              -- Safety check
              if not client or not client.server_capabilities then
                return
              end

              -- Disable formatting for specific servers
              if vim.tbl_contains(disable_formatting, server_name) then
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
              end

              -- Performance: safely disable hover for very large files
              local bufname = vim.api.nvim_buf_get_name(bufnr)
              local ok, stats = pcall(vim.uv.fs_stat, bufname)
              if ok and stats and stats.size > 500 * 1024 then -- 500KB
                if client.server_capabilities.hoverProvider then
                  client.server_capabilities.hoverProvider = false
                end
              end
            end,
          }

          -- Merge server-specific configurations
          if server_configs[server_name] then
            config = vim.tbl_deep_extend("force", config, server_configs[server_name])
          end

          lspconfig[server_name].setup(config)
        end,
      },
    })

    -- Performance: reduce LSP log level
    vim.lsp.set_log_level("WARN")
  end,
}
