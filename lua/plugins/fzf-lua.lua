return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      global_resume = true,
      global_resume_query = true,

      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          default = "bat",
          vertical = "down:45%",
          horizontal = "right:50%",
          layout = "horizontal",
          flip_columns = 100,
          border = "rounded",
        },
        border = "rounded",
        backdrop = 60,
      },

      -- FIXED: Replace winopts.hl with hls (removed deprecation warning)
      hls = {
        normal = "Normal",
        border = "FloatBorder",
        title = "FloatTitle",
        preview_normal = "Normal",
        preview_border = "FloatBorder",
        preview_title = "FloatTitle",
        cursor = "Cursor",
        cursorline = "CursorLine",
        search = "IncSearch",
        scrollbar_e = "PmenuSbar",
        scrollbar_f = "PmenuThumb",
      },

      -- Enhanced key bindings for better UX
      keymap = {
        builtin = {
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
          ["<C-j>"] = "down",
          ["<C-k>"] = "up",
        },
        fzf = {
          ["ctrl-q"] = "select-all+accept",
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-u"] = "preview-page-up",
        },
      },

      -- FIXED: Enhanced fzf_colors with proper gruvbox-material theming (static config)
      fzf_colors = {
        ["fg"] = "#d4be98",
        ["bg"] = "#282828",
        ["hl"] = "#fabd2f",
        ["fg+"] = "#fbf1c7",
        ["bg+"] = "#3c3836",
        ["hl+"] = "#fabd2f",
        ["info"] = "#83a598",
        ["prompt"] = "#d3869b",
        ["pointer"] = "#ea6962",
        ["marker"] = "#a9b665",
        ["spinner"] = "#d8a657",
        ["header"] = "#928374",
        ["gutter"] = "#282828",
      },

      -- ENHANCED: Better LSP configurations for definitions/references
      lsp = {
        code_actions = {
          previewer = "codeaction_native",
          preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS",
          winopts = {
            preview = { layout = "reverse" }
          },
        },

        definitions = {
          previewer = "bat",
          prompt = "Definitions❯ ",
          winopts = {
            preview = {
              layout = "reverse",
              border = "rounded",
            }
          },
        },

        references = {
          previewer = "bat",
          prompt = "References❯ ",
          winopts = {
            preview = {
              layout = "reverse",
              border = "rounded",
            }
          },
        },

        implementations = {
          previewer = "bat",
          prompt = "Implementations❯ ",
          winopts = {
            preview = {
              layout = "reverse",
              border = "rounded",
            }
          },
        },
      },

      -- Enhanced file search
      files = {
        previewer = "bat",
        prompt = "Files❯ ",
        winopts = {
          preview = {
            border = "rounded",
          }
        },
      },

      -- Enhanced grep
      grep = {
        previewer = "bat",
        prompt = "Rg❯ ",
        winopts = {
          preview = {
            border = "rounded",
          }
        },
      },

      -- ENHANCED: Better previewers configuration for proper gruvbox theming
      previewers = {
        bat = {
          cmd = "bat",
          args = "--color=always --style=numbers,changes",
          -- FIXED: Use static theme instead of function to avoid warnings
          theme = "gruvbox-dark",
        },
        head = {
          cmd = "head",
          args = nil,
        },
        git_diff = {
          cmd_deleted = "git show HEAD~1:{}",
          cmd_modified = "git show HEAD:{}",
          cmd_untracked = "head",
        },
        man = {
          cmd = "man %s | col -bx",
        },
        builtin = {
          syntax = true,
          syntax_limit_l = 0,
          syntax_limit_b = 1024 * 1024,
          limit_b = 1024 * 1024 * 10,
          -- FIXED: Replace deprecated 'enable/disable' with 'enabled/disabled'
          treesitter = { enabled = true, disabled = {} },
          extensions = {
            ["png"] = { "ueberzug" },
            ["jpg"] = { "ueberzug" },
            ["jpeg"] = { "ueberzug" },
            ["gif"] = { "ueberzug" },
            ["webp"] = { "ueberzug" },
          },
          ueberzug_scaler = "fit_contain",
        },
      },
    })

    -- ENHANCED: Setup better highlight groups with color scheme support
    local function setup_fzf_highlights()
      local scheme = vim.g.colors_name or "gruvbox-material"

      local colors = {
        ["gruvbox-material"] = {
          bg = "#282828",
          border = "#7c6f64",
          title = "#fabd2f",
          selection = "#3c3836",
          preview_bg = "#1d2021", -- Darker background for preview
          preview_border = "#665c54",
        },
      }

      local c = colors[scheme] or colors["gruvbox-material"]

      -- Main FZF window highlights
      vim.api.nvim_set_hl(0, "FzfLuaNormal", { bg = c.bg })
      vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = c.border, bg = c.bg })
      vim.api.nvim_set_hl(0, "FzfLuaTitle", { fg = c.title, bg = c.bg, bold = true })
      vim.api.nvim_set_hl(0, "FzfLuaCursorLine", { bg = c.selection })

      -- ENHANCED: Preview window highlights with better contrast
      vim.api.nvim_set_hl(0, "FzfLuaPreviewNormal", { bg = c.preview_bg })
      vim.api.nvim_set_hl(0, "FzfLuaPreviewBorder", { fg = c.preview_border, bg = c.preview_bg })
      vim.api.nvim_set_hl(0, "FzfLuaPreviewTitle", { fg = c.title, bg = c.preview_bg, bold = true })
    end

    -- ENHANCED: Dynamic fzf colors update based on colorscheme
    local function update_fzf_colors()
      local scheme = vim.g.colors_name or "gruvbox-material"

      local fzf_color_schemes = {
        ["gruvbox-material"] = {
          ["fg"] = "#d4be98",
          ["bg"] = "#282828",
          ["hl"] = "#fabd2f",
          ["fg+"] = "#fbf1c7",
          ["bg+"] = "#3c3836",
          ["hl+"] = "#fabd2f",
          ["info"] = "#83a598",
          ["prompt"] = "#d3869b",
          ["pointer"] = "#ea6962",
          ["marker"] = "#a9b665",
          ["spinner"] = "#d8a657",
          ["header"] = "#928374",
          ["gutter"] = "#282828",
        },
      }

      local new_colors = fzf_color_schemes[scheme] or fzf_color_schemes["gruvbox-material"]

      -- Update fzf-lua's fzf_colors
      require("fzf-lua").setup({ fzf_colors = new_colors })
    end

    setup_fzf_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(function()
          setup_fzf_highlights()
          update_fzf_colors()
        end)
      end,
    })

    -- Keymaps (keeping your existing ones)
    vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "Search Keymaps" })
    vim.keymap.set("n", "<leader><leader>", fzf.files, { desc = "Search Files" })
    vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Search by Grep" })
    vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Search Diagnostics" })
    vim.keymap.set("n", "<leader>sb", fzf.buffers, { desc = "Search Buffers" })
    vim.keymap.set("n", "<leader>sh", fzf.help_tags, { desc = "Search Help Tags" })
    vim.keymap.set("n", "<leader>sm", fzf.marks, { desc = "Search Marks" })
    vim.keymap.set("n", "<leader>so", fzf.oldfiles, { desc = "Search Old Files" })
  end,
}
