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

        -- Core highlighting - simplified for modern treesitter
        highlight = {
          enable = true,
          -- IMPORTANT: Disable additional_vim_regex_highlighting to prevent conflicts
          additional_vim_regex_highlighting = false,
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

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldcolumn = "0"
      vim.opt.foldtext = ""
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true

      -- Handle treesitter errors gracefully with modern APIs
      local group = vim.api.nvim_create_augroup("TreesitterModern", { clear = true })

      -- Better file type detection for treesitter
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(event)
          local buf = event.buf
          local filetype = vim.bo[buf].filetype

          -- Skip for empty or special buffers
          if filetype == "" or vim.bo[buf].buftype ~= "" then
            return
          end

          -- Let treesitter handle async parsing
          -- No need to manually call vim.treesitter.start() in modern versions
        end,
      })

      -- Handle colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = function()
          -- Treesitter highlighting refreshes automatically in modern versions
          -- No manual intervention needed
        end,
      })
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
        return vim.bo[buf].filetype ~= "help"
            and vim.bo[buf].filetype ~= "alpha"
            and vim.bo[buf].buftype == ""
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
