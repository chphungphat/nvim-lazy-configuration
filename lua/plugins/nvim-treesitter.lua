return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "VeryLazy" },
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        -- Parser installation
        ensure_installed = {
          "javascript",
          "typescript",
          "tsx",
          "bash",
          "c",
          "diff",
          "html",
          "lua",
          "luadoc",
          "markdown",
          "vim",
          "vimdoc",
          "query", -- Important for treesitter queries
        },
        auto_install = true,
        sync_install = false, -- Install asynchronously

        -- Core highlighting - optimized for modern treesitter
        highlight = {
          enable = true,
          -- IMPORTANT: Disable additional_vim_regex_highlighting to prevent conflicts
          additional_vim_regex_highlighting = false,

          -- Enhanced disable function for better compatibility
          disable = function(_, buf)
            -- Disable for very large files
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end

            -- Disable for specific problematic buffers
            local bufname = vim.api.nvim_buf_get_name(buf)
            if bufname:match("NeogitStatus") or bufname:match("fugitive://") then
              return true
            end

            -- Check buffer-local disable flag
            if vim.b[buf].ts_highlight == false then
              return true
            end

            return false
          end,
        },

        -- Indentation
        indent = {
          enable = true,
          -- Disable for problematic languages
          disable = { "python", "yaml" },
        },

        -- Incremental selection
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false, -- Disabled to avoid confusion
            node_decremental = "<BS>", -- Backspace to go back
          },
        },
      })

      -- ============================================================================
      -- FOLDING CONFIGURATION (Modern approach)
      -- ============================================================================

      -- Use the new async folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldcolumn = "0"
      vim.opt.foldtext = ""
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true

      -- ============================================================================
      -- MODERN TREESITTER ERROR HANDLING
      -- ============================================================================

      local group = vim.api.nvim_create_augroup("TreesitterModern", { clear = true })

      -- Handle async treesitter loading with error recovery
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(event)
          local buf = event.buf
          local filetype = vim.bo[buf].filetype

          -- Skip for empty or special buffers
          if filetype == "" or vim.bo[buf].buftype ~= "" then
            return
          end

          -- Skip for excluded filetypes
          local excluded_fts = {
            "help", "man", "qf", "fugitive", "git",
            "NvimTree", "neo-tree", "oil", "lazy", "mason",
            "NeogitStatus", "NeogitCommitMessage"
          }

          if vim.tbl_contains(excluded_fts, filetype) then
            return
          end

          -- Enhanced treesitter startup with error handling
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf) then
              local ok, parser = pcall(vim.treesitter.get_parser, buf, filetype)
              if ok and parser then
                -- Ensure highlighting starts properly
                local success = pcall(vim.treesitter.start, buf, filetype)
                if not success then
                  -- Retry once after a delay
                  vim.defer_fn(function()
                    if vim.api.nvim_buf_is_valid(buf) then
                      pcall(vim.treesitter.start, buf, filetype)
                    end
                  end, 100)
                end
              end
            end
          end)
        end,
      })

      -- Handle colorscheme changes with modern API
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = function()
          -- Modern treesitter handles highlighting refresh automatically
          -- Just ensure any custom highlights are maintained
          vim.schedule(function()
            -- Refresh treesitter for all visible buffers if needed
            local current_time = vim.uv.hrtime()
            if not vim.g._last_colorscheme_change or
                (current_time - vim.g._last_colorscheme_change) > 1000000000 then -- 1 second
              vim.g._last_colorscheme_change = current_time

              for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_is_valid(win) then
                  local buf = vim.api.nvim_win_get_buf(win)
                  if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
                    local ft = vim.bo[buf].filetype
                    if ft and ft ~= "" then
                      -- Just trigger a redraw rather than restarting
                      vim.api.nvim_buf_call(buf, function()
                        vim.cmd("redraw")
                      end)
                    end
                  end
                end
              end
            end
          end)
        end,
      })

      -- ============================================================================
      -- NEOGIT INTEGRATION FIXES
      -- ============================================================================

      -- Better handling for neogit file navigation
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "NeogitStatusRefresh",
        callback = function()
          -- Neogit has refreshed, ensure treesitter is stable
          vim.schedule(function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_is_valid(win) then
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
                  local bufname = vim.api.nvim_buf_get_name(buf)
                  if bufname and bufname ~= "" and not bufname:match("NeogitStatus") then
                    local ft = vim.bo[buf].filetype
                    if ft and ft ~= "" then
                      -- Gentle refresh
                      pcall(vim.treesitter.start, buf, ft)
                    end
                  end
                end
              end
            end
          end)
        end,
      })

      -- Handle buffer changes that might be from neogit navigation
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = group,
        callback = function(event)
          local buf = event.buf
          local bufname = vim.api.nvim_buf_get_name(buf)

          -- If this looks like a file opened from neogit
          if bufname and bufname ~= "" and not bufname:match("NeogitStatus") then
            local ft = vim.bo[buf].filetype
            if ft and ft ~= "" then
              -- Small delay to let window management settle
              vim.defer_fn(function()
                if vim.api.nvim_buf_is_valid(buf) then
                  local highlighter = vim.treesitter.highlighter.active[buf]
                  if not highlighter then
                    -- Start treesitter if it's not active
                    pcall(vim.treesitter.start, buf, ft)
                  end
                end
              end, 50)
            end
          end
        end,
      })

      -- ============================================================================
      -- TROUBLESHOOTING COMMANDS
      -- ============================================================================

      -- Enhanced troubleshooting commands
      vim.api.nvim_create_user_command("TSDebugBuffer", function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo[buf].filetype

        print("=== Treesitter Debug Info ===")
        print("Buffer:", buf)
        print("Filetype:", ft)
        print("Buffer valid:", vim.api.nvim_buf_is_valid(buf))
        print("Buffer type:", vim.bo[buf].buftype)

        -- Check parser
        local ok, parser = pcall(vim.treesitter.get_parser, buf)
        if ok and parser then
          print("Parser found:", parser:lang())
          local trees = parser:parse()
          print("Trees parsed:", #trees)
        else
          print("No parser found")
        end

        -- Check highlighting
        local highlighter = vim.treesitter.highlighter.active[buf]
        print("Highlighter active:", highlighter ~= nil)

        -- Check for extmarks
        local marks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { limit = 5 })
        print("Extmarks found:", #marks)

        -- Check async setting
        print("Force sync parsing:", vim.g._ts_force_sync_parsing)

        print("=== End Debug Info ===")
      end, { desc = "Debug treesitter for current buffer" })

      vim.api.nvim_create_user_command("TSFixCurrent", function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo[buf].filetype

        if ft and ft ~= "" then
          print("Restarting treesitter for current buffer...")
          pcall(vim.treesitter.stop, buf)
          vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(buf) then
              pcall(vim.treesitter.start, buf, ft)
              print("Treesitter restarted")
            end
          end, 100)
        else
          print("No filetype detected")
        end
      end, { desc = "Fix treesitter for current buffer" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]A"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[A"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true,
      max_lines = 3,
      min_window_height = 20,
      line_numbers = true,
      multiline_threshold = 10,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
      on_attach = function(buf)
        -- Enhanced filtering for modern neovim
        local bt = vim.bo[buf].buftype
        local ft = vim.bo[buf].filetype

        -- Skip for special buffer types
        if bt ~= "" then
          return false
        end

        -- Skip for excluded filetypes
        local excluded = {
          "help", "alpha", "neo-tree", "NeogitStatus",
          "lazy", "mason", "oil", "TelescopePrompt"
        }

        return not vim.tbl_contains(excluded, ft)
      end,
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)

      vim.keymap.set("n", "<leader>tc", function()
        require("treesitter-context").toggle()
      end, { desc = "Toggle treesitter context" })
    end,
  },
}
