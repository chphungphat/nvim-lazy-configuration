return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "VeryLazy" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "javascript", "typescript", "tsx", "bash", "c",
          "html", "lua", "luadoc", "markdown", "vim", "vimdoc", "query"
        },
        auto_install = true,
        sync_install = false,

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,

          disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > max_filesize
          end,
        },

        indent = {
          enable = true,
          disable = { "python", "yaml" },
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            node_decremental = "<BS>",
          },
        },
      })

      -- Modern folding setup (Neovim 0.11+)
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldcolumn = "0"
      vim.opt.foldtext = ""
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true

      -- Single autocmd for large file handling
      local treesitter_group = vim.api.nvim_create_augroup("TreesitterOptimized", { clear = true })

      vim.api.nvim_create_autocmd("BufReadPre", {
        group = treesitter_group,
        callback = function(event)
          local buf = event.buf
          local filename = vim.api.nvim_buf_get_name(buf)

          if filename == "" then return end

          local ok, stats = pcall(vim.uv.fs_stat, filename)
          if ok and stats and stats.size > 1024 * 1024 then -- 1MB
            -- Disable expensive features for large files
            vim.bo[buf].swapfile = false
            vim.bo[buf].undofile = false
            vim.wo.foldenable = false

            if stats.size > 5 * 1024 * 1024 then -- 5MB
              vim.b[buf].ts_highlight = false
            end
          end
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
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
}
