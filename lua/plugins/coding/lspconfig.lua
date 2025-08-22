-- lua/plugins/coding/lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "mason-org/mason-lspconfig.nvim", dependencies = { "mason-org/mason.nvim" } },
  },
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if pcall(require, "blink.cmp") then
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(event)
        local opts = { buffer = event.buf, silent = true }

        vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions jump_to_single_result=true ignore_current_line=true<cr>",
          vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gD", "<cmd>FzfLua lsp_declarations jump_to_single_result=true ignore_current_line=true<cr>",
          vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<cr>",
          vim.tbl_extend("force", opts, { desc = "Show references" }))
        vim.keymap.set("n", "gi",
          "<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>",
          vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        vim.keymap.set("n", "gt", "<cmd>FzfLua lsp_typedefs jump_to_single_result=true ignore_current_line=true<cr>",
          vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

        vim.keymap.set("n", "<leader>cs", "<cmd>FzfLua lsp_document_symbols<cr>",
          vim.tbl_extend("force", opts, { desc = "Document symbols" }))
        vim.keymap.set("n", "<leader>cS", "<cmd>FzfLua lsp_workspace_symbols<cr>",
          vim.tbl_extend("force", opts, { desc = "Workspace symbols" }))
        vim.keymap.set("n", "<leader>cf", "<cmd>FzfLua lsp_finder<cr>",
          vim.tbl_extend("force", opts, { desc = "LSP Finder (all locations)" }))

        vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>",
          vim.tbl_extend("force", opts, { desc = "Code actions" }))
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover documentation" }))

        vim.keymap.set("n", "[e", function()
          vim.diagnostic.jump({
            severity = vim.diagnostic.severity.ERROR,
            count = -1,
          })
        end, vim.tbl_extend("force", opts, { desc = "Previous Error" }))
        vim.keymap.set("n", "]e", function()
          vim.diagnostic.jump({
            severity = vim.diagnostic.severity.ERROR,
            count = 1,
          })
        end, vim.tbl_extend("force", opts, { desc = "Next Error" }))

        vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump({
              severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.HINT, vim.diagnostic.severity.INFO },
              count = -1,
            })
          end,
          vim.tbl_extend("force", opts, { desc = "Previous Warning/Info/Hint" }))
        vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump({
              severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.HINT, vim.diagnostic.severity.INFO },
              count = 1,
            })
          end,
          vim.tbl_extend("force", opts, { desc = "Next Warning/Info/Hint" }))

        vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float,
          vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))

        local client = vim.lsp.get_client_by_id(event.data.client_id)
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

    vim.diagnostic.config({
      virtual_text = {
        spacing = 4,
        prefix = "●",
        source = "if_many",
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
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    })

    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })

    vim.lsp.config('ts_ls', {
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
        },
      },
    })

    vim.lsp.config('clangd', {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
      },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
      capabilities = vim.tbl_extend("force", capabilities, {
        offsetEncoding = { "utf-16" },
      }),
    })

    vim.lsp.config('bashls', {})

    vim.lsp.config('jsonls', {})

    vim.lsp.config('yamlls', {})

    vim.lsp.config('html', {})

    vim.lsp.config('cssls', {})

    vim.lsp.config('marksman', {})

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
      automatic_enable = true,
    })
  end,
}
