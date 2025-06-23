return {
  "saghen/blink.cmp",
  dependencies = {
    "folke/lazydev.nvim",
    "fang2hou/blink-copilot",
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

      min_keyword_length = 1,

      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },

        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          score_offset = 100,
          async = true,

          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              return item.kind ~= require('blink.cmp.types').CompletionItemKind.Text
            end, items)
          end,
        },

        path = {
          module = "blink.cmp.sources.path",
          score_offset = 90,
          opts = {
            trailing_slash = true,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = false,
          },
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
            max_attempts = 3,
            debounce = 200,
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
        prefetch_on_insert = true,
        show_in_snippet = false,
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_blocked_trigger_characters = { " ", "\n", "\t" },
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
          enabled = false, -- Keep disabled for stability
        },
      },

      -- FIXED: Re-enable documentation with safe settings
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        update_delay_ms = 50,
        treesitter_highlighting = true,
        window = {
          min_width = 10,
          max_width = 80,
          max_height = 20,
          border = "rounded",
          scrollbar = true,
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
        },
      },

      menu = {
        enabled = true,
        auto_show = true,
        scrollbar = true,

        draw = {
          treesitter = { "lsp" }, -- Enable treesitter for LSP only
          columns = {
            { "kind_icon", gap = 1 },
            { "label",     "label_description", gap = 1 },
            { "kind" },
          },

          -- FIXED: Simplified components without problematic configurations
          components = {
            kind_icon = {
              text = function(ctx)
                return ctx.kind_icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                return "BlinkCmpKind" .. ctx.kind
              end,
            },

            label = {
              text = function(ctx)
                return ctx.label .. (ctx.label_detail or "")
              end,
              highlight = function(ctx)
                local highlights = {
                  { 0, #ctx.label, group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel" },
                }

                if ctx.label_detail then
                  table.insert(highlights, {
                    #ctx.label,
                    #ctx.label + #ctx.label_detail,
                    group = "BlinkCmpLabelDetail"
                  })
                end

                -- Add matched indices highlights
                for _, idx in ipairs(ctx.label_matched_indices or {}) do
                  table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                end

                return highlights
              end,
            },

            label_description = {
              text = function(ctx)
                return ctx.label_description
              end,
              highlight = "BlinkCmpLabelDescription",
            },

            kind = {
              text = function(ctx)
                return ctx.kind
              end,
              highlight = function(ctx)
                return "BlinkCmpKind" .. ctx.kind
              end,
            },
          },
        },

        window = {
          border = "rounded",
          scrollbar = true,
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection",
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

    -- FIXED: Simplified fuzzy configuration
    fuzzy = {
      implementation = "rust", -- Use rust by default, fallback to lua if needed
      sorts = {
        "score",
        "sort_text",
      },
    },
  },

  config = function(_, opts)
    require("blink.cmp").setup(opts)

    -- FIXED: Enhanced highlight groups with modern approach
    local function setup_highlights()
      local scheme = vim.g.colors_name or "gruvbox-material"

      local colors = {
        ["gruvbox-material"] = {
          menu_bg = "#282828",
          menu_border = "#504945",
          menu_selection = "#3c3836",
          doc_bg = "#32302f",
          doc_border = "#665c54",

          copilot = "#7daea3",        -- Aqua for Copilot
          lsp = "#a9b665",            -- Green for LSP
          function_color = "#d3869b", -- Purple for functions
          keyword_color = "#d8a657",  -- Yellow for keywords
          variable_color = "#83a598", -- Blue for variables
          string_color = "#b8bb26",   -- Green for strings
        },
      }

      local c = colors[scheme] or colors["gruvbox-material"]

      -- Blink.cmp menu styling
      vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = c.menu_bg })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = c.menu_border })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = c.menu_selection })

      -- Documentation window styling
      vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = c.doc_bg })
      vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = c.doc_border })

      -- Enhanced completion item styling
      vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = "#d4be98" })
      vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", { fg = "#928374", strikethrough = true })
      vim.api.nvim_set_hl(0, "BlinkCmpLabelDetail", { fg = "#928374", italic = true })
      vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { fg = "#928374", italic = true })
      vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#fabd2f", bold = true })

      -- Kind-specific highlighting (Enhanced with italic and colors)
      vim.api.nvim_set_hl(0, "BlinkCmpKindCopilot", { fg = c.copilot, italic = true })
      vim.api.nvim_set_hl(0, "BlinkCmpKindFunction", { fg = c.function_color, italic = true })
      vim.api.nvim_set_hl(0, "BlinkCmpKindMethod", { fg = c.function_color, italic = true })
      vim.api.nvim_set_hl(0, "BlinkCmpKindKeyword", { fg = c.keyword_color, bold = true })
      vim.api.nvim_set_hl(0, "BlinkCmpKindVariable", { fg = c.variable_color })
      vim.api.nvim_set_hl(0, "BlinkCmpKindText", { fg = c.string_color })
      vim.api.nvim_set_hl(0, "BlinkCmpKindClass", { fg = c.lsp, bold = true })
      vim.api.nvim_set_hl(0, "BlinkCmpKindInterface", { fg = c.lsp, bold = true })
      vim.api.nvim_set_hl(0, "BlinkCmpKindModule", { fg = c.lsp })
      vim.api.nvim_set_hl(0, "BlinkCmpKindProperty", { fg = c.variable_color })
      vim.api.nvim_set_hl(0, "BlinkCmpKindField", { fg = c.variable_color })
      vim.api.nvim_set_hl(0, "BlinkCmpKindConstructor", { fg = c.function_color, bold = true })
      vim.api.nvim_set_hl(0, "BlinkCmpKindEnum", { fg = c.keyword_color })
      vim.api.nvim_set_hl(0, "BlinkCmpKindEnumMember", { fg = c.keyword_color })
      vim.api.nvim_set_hl(0, "BlinkCmpKindStruct", { fg = c.lsp, bold = true })
      vim.api.nvim_set_hl(0, "BlinkCmpKindValue", { fg = c.string_color })
      vim.api.nvim_set_hl(0, "BlinkCmpKindConstant", { fg = c.keyword_color, bold = true })
      vim.api.nvim_set_hl(0, "BlinkCmpKindSnippet", { fg = c.copilot, italic = true })
    end

    setup_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(setup_highlights)
      end,
    })
  end,
}
