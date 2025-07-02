return {
  "saghen/blink.cmp",
  dependencies = {
    "folke/lazydev.nvim",
    "echasnovski/mini.icons",
  },
  version = "1.*",
  build = "cargo build --release",

  opts = {
    keymap = {
      preset = "none",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-Space>"] = { "show", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
    },

    sources = {
      default = { "lsp", "path", "buffer", "lazydev" },
      min_keyword_length = 1,

      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },

    completion = {
      accept = {
        auto_brackets = { enabled = false },
      },

      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
          max_width = 80,
          max_height = 20,
        },
      },


      menu = {
        border = "rounded",
        draw = {
          columns = {
            { "kind_icon", gap = 1 },
            { "label",     "label_description", gap = 1 },
            { "kind" },
          },
        },
      },

      ghost_text = { enabled = false },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "normal",
    },

    fuzzy = {
      sorts = { "score", "sort_text" },
    },
  },

  config = function(_, opts)
    require("blink.cmp").setup(opts)

    local function setup_highlights()
      if vim.g.colors_name ~= "gruvbox-material" then
        return
      end

      local colors = {
        menu_bg = "#282828",
        selection_bg = "#3c3836",
        border_fg = "#504945",

        lsp_fg = "#a9b665",
        function_fg = "#d3869b",
        keyword_fg = "#d8a657",
        variable_fg = "#83a598",
      }

      vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = colors.menu_bg })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = colors.selection_bg })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = colors.border_fg })
      vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = colors.menu_bg })
      vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = colors.border_fg })

      vim.api.nvim_set_hl(0, "BlinkCmpKindFunction", { fg = colors.function_fg })
      vim.api.nvim_set_hl(0, "BlinkCmpKindMethod", { fg = colors.function_fg })
      vim.api.nvim_set_hl(0, "BlinkCmpKindKeyword", { fg = colors.keyword_fg })
      vim.api.nvim_set_hl(0, "BlinkCmpKindVariable", { fg = colors.variable_fg })
      vim.api.nvim_set_hl(0, "BlinkCmpKindClass", { fg = colors.lsp_fg })
      vim.api.nvim_set_hl(0, "BlinkCmpKindInterface", { fg = colors.lsp_fg })
    end

    setup_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(setup_highlights)
      end,
    })
  end,
}
