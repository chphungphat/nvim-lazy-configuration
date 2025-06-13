return {
  "saghen/blink.cmp",
  dependencies = {
    "folke/lazydev.nvim",
    "fang2hou/blink-copilot", -- Updated copilot integration
    "echasnovski/mini.icons",
  },
  version = "1.*", -- Use latest 1.x stable version

  opts = {
    keymap = {
      preset = "none", -- RESTORED: Your original preset
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
      -- Enable per-filetype sources if needed
      per_filetype = {},
      -- Minimum keyword length to trigger providers
      min_keyword_length = 0,
      -- Transform items before returning (optional)
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

          -- RESTORED: Minimal filtering to allow auto-imports
          transform_items = function(_, items)
            -- Only filter out problematic items, keep most for auto-imports
            return vim.tbl_filter(function(item)
              -- Only filter out text items, keep everything else
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
          score_offset = 101, -- RESTORED: Higher than LSP like your original
          async = true,
          opts = {
            max_completions = 3, -- RESTORED: Your original setting
            max_attempts = 4,    -- RESTORED: Your original setting
            kind_name = "Copilot",
            kind_icon = "",
            debounce = 200, -- RESTORED: Your original setting
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
        range = "full", -- Important for TypeScript completions
      },

      trigger = {
        prefetch_on_insert = false, -- RESTORED: Your original setting
        show_in_snippet = false,    -- RESTORED: Your original setting
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_blocked_trigger_characters = { " ", "\n", "\t" },
        show_on_accept_on_trigger_character = true,
        show_on_insert_on_trigger_character = true,
      },

      list = {
        max_items = 50, -- Reasonable limit for performance
        selection = {
          preselect = false,
          auto_insert = false, -- Manual control over insertion
        },
        cycle = {
          from_bottom = true,
          from_top = true,
        },
      },

      accept = {
        create_undo_point = true,
        resolve_timeout_ms = 50, -- RESTORED: Your original timeout
        auto_brackets = {
          enabled = false,       -- RESTORED: Your original setting (disabled)
        },
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200, -- RESTORED: Your original delay
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
          treesitter = { "lsp" }, -- Enable treesitter highlighting
          columns = {
            { "kind_icon", gap = 1 },
            { "label",     "label_description", gap = 1 },
            { "kind" }, -- FIXED: Show completion kind instead of source_name
          },
        },
      },

      ghost_text = {
        enabled = false, -- Disable to avoid conflicts with Copilot
      },
    },

    appearance = {
      use_nvim_cmp_as_default = true, -- RESTORED: Your original setting
      nerd_font_variant = "normal",   -- RESTORED: Your original setting
      kind_icons = {
        -- RESTORED: Your original icon set
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

    -- Fuzzy matching configuration
    fuzzy = {
      -- Use Rust implementation for better performance
      implementation = "prefer_rust_with_warning",
      -- Allow typos based on query length
      max_typos = function(keyword)
        return math.floor(#keyword / 4)
      end,
      -- Enable advanced sorting features
      use_frecency = true,
      use_proximity = true,
      -- Sorting priority
      sorts = { "score", "sort_text" },
      -- Prebuilt binaries configuration
      prebuilt_binaries = {
        download = true,
        ignore_version_mismatch = false,
      },
    },
  },

  config = function(_, opts)
    require("blink.cmp").setup(opts)

    -- Handle Copilot integration
    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuOpen",
      callback = function()
        vim.b.copilot_suggestion_hidden = true
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuClose",
      callback = function()
        vim.b.copilot_suggestion_hidden = false
      end,
    })
  end,
}
