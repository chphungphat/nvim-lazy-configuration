if true then return {} end
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    dependencies = {
      "windwp/nvim-autopairs",
    },
    config = function()
      require("copilot").setup({
        panel = {
          enabled = false, -- Disable panel to reduce conflicts
          auto_refresh = false,
        },
        suggestion = {
          enabled = false, -- IMPORTANT: Disable to avoid conflicts with blink.cmp
          auto_trigger = false,
        },
        filetypes = {
          -- Enable for specific filetypes only
          lua = true,
          javascript = true,
          typescript = true,
          javascriptreact = true,
          typescriptreact = true,
          python = true,
          rust = true,
          go = true,
          java = true,
          c = true,
          cpp = true,
          markdown = true,
          yaml = true,
          json = true,
          html = true,
          css = true,
          scss = true,
          -- Disable for problematic filetypes
          gitcommit = false,
          gitrebase = false,
          help = false,
          ["."] = false,
          [""] = false,
        },
        copilot_node_command = "node",
        server_opts_overrides = {
          trace = "off", -- Reduce logging for stability
          settings = {
            advanced = {
              -- REDUCED: Conservative settings to prevent crashes
              inlineSuggestCount = 2, -- Reduced from 3
              length = 300,           -- Reduced from 500
              listCount = 5,          -- Reduced from 10
            },
          },
        },
      })

      -- Add crash recovery autocmds
      local group = vim.api.nvim_create_augroup("CopilotStability", { clear = true })

      -- Disable Copilot during macro recording (can cause crashes)
      vim.api.nvim_create_autocmd("RecordingEnter", {
        group = group,
        callback = function()
          vim.b.copilot_suggestion_hidden = true
          pcall(require("copilot.api").stop)
        end,
      })

      vim.api.nvim_create_autocmd("RecordingLeave", {
        group = group,
        callback = function()
          vim.schedule(function()
            vim.b.copilot_suggestion_hidden = false
            pcall(require("copilot.api").start)
          end)
        end,
      })

      -- Monitor LSP health and restart if needed
      vim.api.nvim_create_autocmd("LspDetach", {
        group = group,
        pattern = "*",
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "copilot" then
            vim.notify("Copilot LSP detached, attempting restart...", vim.log.levels.WARN)
            vim.defer_fn(function()
              pcall(require("copilot.api").start)
            end, 1000)
          end
        end,
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    build = "make tiktoken",
    event = "VeryLazy",
    config = function()
      local chat = require("CopilotChat")

      chat.setup({
        debug = false,
        show_help = false,
        model = "claude-sonnet-4",
        agent = "copilot",
        context = nil,
        temperature = 0.1,

        -- Conservative window configuration
        window = {
          layout = "vertical",
          width = 0.4,
          height = 0.8,
          relative = "editor",
          border = "rounded",
          title = "Copilot Chat",
        },

        selection = function(source)
          local select = require("CopilotChat.select")
          return select.visual(source) or select.line(source)
        end,

        -- Stable prompts configuration
        prompts = {
          Explain = {
            prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
          },
          Review = {
            prompt = "/COPILOT_REVIEW Review the selected code.",
          },
          Fix = {
            prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to fix the problem.",
          },
          Optimize = {
            prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readability.",
          },
          Docs = {
            prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.",
          },
          Tests = {
            prompt = "/COPILOT_GENERATE Please generate tests for my code.",
          },
          FixDiagnostic = {
            prompt = "Please assist with the following diagnostic issue in file:",
            selection = function(source)
              return require("CopilotChat.select").diagnostics(source)
            end,
          },
        },

        -- Conservative mappings
        mappings = {
          complete = {
            insert = "<Tab>",
          },
          close = {
            normal = "q",
            insert = "<C-c>",
          },
          reset = {
            normal = "<C-r>",
            insert = "<C-r>",
          },
          submit_prompt = {
            normal = "<CR>",
            insert = "<C-s>",
          },
          accept_diff = {
            normal = "<C-y>",
            insert = "<C-y>",
          },
          yank_diff = {
            normal = "gy",
            register = '"',
          },
          show_diff = {
            normal = "gd",
          },
          show_info = {
            normal = "gi",
          },
          show_context = {
            normal = "gc",
          },
        },
      })

      -- Safer keymaps with error handling
      local function safe_map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = true
        opts.silent = true
        vim.keymap.set(mode, lhs, function()
          local ok, err = pcall(rhs)
          if not ok then
            vim.notify("CopilotChat error: " .. tostring(err), vim.log.levels.ERROR)
          end
        end, opts)
      end

      -- Basic commands
      safe_map("n", "<leader>cco", function() vim.cmd("CopilotChatOpen") end, { desc = "Open Copilot Chat" })
      safe_map("n", "<leader>ccc", function() vim.cmd("CopilotChatClose") end, { desc = "Close Copilot Chat" })
      safe_map("n", "<leader>cct", function() vim.cmd("CopilotChatToggle") end, { desc = "Toggle Copilot Chat" })
      safe_map("n", "<leader>ccr", function() vim.cmd("CopilotChatReset") end, { desc = "Reset Copilot Chat" })

      -- Quick actions with error handling
      safe_map("n", "<leader>cce", function() vim.cmd("CopilotChatExplain") end, { desc = "Explain code" })
      safe_map("n", "<leader>ccf", function() vim.cmd("CopilotChatFix") end, { desc = "Fix code" })
      safe_map("n", "<leader>ccv", function() vim.cmd("CopilotChatReview") end, { desc = "Review code" })

      -- Visual mode mappings
      safe_map("v", "<leader>cce", function() vim.cmd("CopilotChatExplain") end, { desc = "Explain selection" })
      safe_map("v", "<leader>ccf", function() vim.cmd("CopilotChatFix") end, { desc = "Fix selection" })

      -- Quick chat with enhanced error handling
      safe_map("n", "<leader>ccq", function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          local ok, err = pcall(function()
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end)
          if not ok then
            vim.notify("CopilotChat error: " .. tostring(err), vim.log.levels.ERROR)
          end
        end
      end, { desc = "Quick chat" })
    end,
  },
}
