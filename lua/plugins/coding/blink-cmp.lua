return {
  "saghen/blink.cmp",
  dependencies = {
    "folke/lazydev.nvim",
    "fang2hou/blink-copilot",
    "echasnovski/mini.icons",
  },
  version = "1.*",

  opts = {
    keymap = {
      preset = "none",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-Space>"] = { "show", "fallback" },
    },

    sources = {
      default = {
        "lsp",
        "path",
        "buffer",
        "lazydev",
        "copilot",
      },
      per_filetype = {},
      min_keyword_length = 0,
      transform_items = function(_, items)
        return items
      end,

      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },

        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          fallbacks = { "buffer" },
          async = true,
          score_offset = 100,

          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              return item.kind ~= require('blink.cmp.types').CompletionItemKind.Text
            end, items)
          end,
        },

        path = {
          module = "blink.cmp.sources.path",
          fallbacks = { "buffer" },
          opts = {
            trailing_slash = true,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = false,
          },
          score_offset = 90,
        },

        buffer = {
          module = "blink.cmp.sources.buffer",
          score_offset = -3,
          opts = {
            get_bufnrs = function()
              return vim
                  .iter(vim.api.nvim_list_wins())
                  :map(function(win) return vim.api.nvim_win_get_buf(win) end)
                  :filter(function(buf) return vim.bo[buf].buftype ~= "nofile" end)
                  :totable()
            end,
          },
        },

        copilot = {
          name = "Copilot",
          module = "blink-copilot",
          score_offset = 101,
          async = true,
          opts = {
            max_completions = 3,
            max_attempts = 4,
            kind_name = "Copilot",
            kind_icon = "",
            debounce = 200, --
            auto_refresh = {
              backward = true,
              forward = true,
            },
          },
        },
      },
    },

    completion = {
      keyword = {
        range = "full",
      },

      trigger = {
        prefetch_on_insert = false,
        show_in_snippet = false,
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_blocked_trigger_characters = { " ", "\n", "\t" },
        show_on_accept_on_trigger_character = true,
        show_on_insert_on_trigger_character = true,
      },

      list = {
        max_items = 50,
        selection = {
          preselect = false,
          auto_insert = false,
        },
        cycle = {
          from_bottom = true,
          from_top = true,
        },
      },

      accept = {
        create_undo_point = true,
        resolve_timeout_ms = 100,
        auto_brackets = {
          enabled = false,
        },
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        update_delay_ms = 50,
        treesitter_highlighting = true,
        window = {
          scrollbar = true,
        },
      },

      menu = {
        enabled = true,
        scrollbar = true,
        auto_show = true,
        draw = {
          treesitter = { "lsp" },
          columns = {
            { "kind_icon", gap = 1 },
            { "label",     "label_description", gap = 1 },
            { "kind" },
          },
        },
      },

      ghost_text = {
        enabled = false,
      },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "normal",
      kind_icons = {
        Copilot = "",
        Text = "󰉿",
        Method = "󰊕",
        Function = "󰊕",
        Constructor = "󰒓",
        Field = "󰜢",
        Variable = "󰆦",
        Property = "󰖷",
        Class = "󱡠",
        Interface = "󱡠",
        Struct = "󱡠",
        Module = "󰅩",
        Unit = "󰪚",
        Value = "󰦨",
        Enum = "󰦨",
        EnumMember = "󰦨",
        Keyword = "󰻾",
        Constant = "󰏿",
        Snippet = "󱄽",
        Color = "󰏘",
        File = "󰈔",
        Reference = "󰬲",
        Folder = "󰉋",
        Event = "󱐋",
        Operator = "󰪚",
        TypeParameter = "󰬛",
      },
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },
  },

  config = function(_, opts)
    require("blink.cmp").setup(opts)
  end,
}
