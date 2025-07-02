return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "mason-org/mason-lspconfig.nvim", dependencies = { "mason-org/mason.nvim" } },
    "stevearc/dressing.nvim",
  },
  config = function()
    local lspconfig = require("lspconfig")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if pcall(require, "blink.cmp") then
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(event)
        local opts = { buffer = event.buf, silent = true }

        -- Navigation
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
          vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition,
          vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

        -- Actions
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
          vim.tbl_extend("force", opts, { desc = "Code actions" }))
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

        -- Documentation
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover documentation" }))

        -- Diagnostics
        vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end,
          vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
        vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end,
          vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
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

    local function setup_server(server_name, custom_config)
      local config = {
        capabilities = capabilities,
        on_attach = function(client, _)
          if server_name == "ts_ls" or server_name == "lua_ls" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        end,
      }

      if custom_config then
        config = vim.tbl_deep_extend("force", config, custom_config)
      end

      lspconfig[server_name].setup(config)
    end

    setup_server("lua_ls", {
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

    setup_server("ts_ls", {
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

    local simple_servers = {
      "bashls", "jsonls", "yamlls", "html", "cssls", "marksman"
    }

    for _, server in ipairs(simple_servers) do
      setup_server(server)
    end
  end,
}
