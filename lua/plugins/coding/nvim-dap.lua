return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mason-org/mason.nvim",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")

      -- Codelldb adapter setup
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          -- Mason installs codelldb here
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      -- C/C++ configurations
      dap.configurations.cpp = {
        {
          name = "Launch C++ Program",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},

          -- Console setup
          console = "integratedTerminal",

          -- Environment variables
          env = function()
            local variables = {}
            for k, v in pairs(vim.fn.environ()) do
              table.insert(variables, string.format("%s=%s", k, v))
            end
            return variables
          end,
        },
        {
          name = "Launch with Arguments",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            local args_input = vim.fn.input("Arguments: ")
            return vim.split(args_input, " ")
          end,
          console = "integratedTerminal",
        },
        {
          name = "Attach to Process",
          type = "codelldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          args = {},
        },
      }

      -- Use the same configuration for C
      dap.configurations.c = dap.configurations.cpp

      -- Keymaps
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to Cursor" })
      vim.keymap.set("n", "<leader>dg", dap.goto_, { desc = "Go to line (no execute)" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>dj", dap.down, { desc = "Down" })
      vim.keymap.set("n", "<leader>dk", dap.up, { desc = "Up" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
      vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
      vim.keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "Pause" })
      vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
      vim.keymap.set("n", "<leader>ds", dap.session, { desc = "Session" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })

      -- Custom debug session for single file C/C++ programs
      vim.keymap.set("n", "<leader>dq", function()
        local filetype = vim.bo.filetype
        if filetype ~= "c" and filetype ~= "cpp" then
          vim.notify("Not a C/C++ file", vim.log.levels.ERROR)
          return
        end

        local filename = vim.fn.expand("%:t:r") -- filename without extension
        local filepath = vim.fn.expand("%:p")   -- full path to current file

        -- Compile command based on filetype
        local compile_cmd
        if filetype == "c" then
          compile_cmd = string.format("gcc -g -o %s %s", filename, filepath)
        else
          compile_cmd = string.format("g++ -g -std=c++17 -o %s %s", filename, filepath)
        end

        -- Compile the program
        vim.notify("Compiling: " .. compile_cmd)
        local result = vim.fn.system(compile_cmd)

        if vim.v.shell_error ~= 0 then
          vim.notify("Compilation failed:\n" .. result, vim.log.levels.ERROR)
          return
        end

        vim.notify("Compilation successful!")

        -- Start debugging
        dap.run({
          name = "Quick Debug",
          type = "codelldb",
          request = "launch",
          program = vim.fn.getcwd() .. "/" .. filename,
          cwd = vim.fn.getcwd(),
          stopOnEntry = false,
          args = {},
          console = "integratedTerminal",
        })
      end, { desc = "Quick Debug (compile & debug current file)" })
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks",      size = 0.25 },
              { id = "watches",     size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      -- Auto open/close dap-ui
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Keymaps for dap-ui
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle Debug UI" })
      vim.keymap.set("n", "<leader>de", dapui.eval, { desc = "Evaluate Expression" })
      vim.keymap.set("v", "<leader>de", dapui.eval, { desc = "Evaluate Selection" })
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        virt_text_pos = "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })
    end,
  },
}
