if true then return {} end
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- Completion sources
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",

    -- Snippets
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",

    -- Icons
    "onsails/lspkind.nvim",

    -- Copilot integration
    "zbirenbaum/copilot-cmp",
  },

  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- Load friendly snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      -- KEEP YOUR EXACT KEYMAPS
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- Your original mapping
        ["<C-j>"] = cmp.mapping.select_next_item(), -- Your original mapping
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),    -- Your original mapping
        ["<C-f>"] = cmp.mapping.scroll_docs(4),     -- Your original mapping
        ["<C-Space>"] = cmp.mapping.complete(),     -- Your original mapping
        ["<CR>"] = cmp.mapping.confirm({            -- Your original mapping
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,                           -- Don't auto-select first item
        }),

        -- Additional useful mappings
        -- ["<C-e>"] = cmp.mapping.abort(),
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   elseif luasnip.expand_or_jumpable() then
        --     luasnip.expand_or_jump()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   elseif luasnip.jumpable(-1) then
        --     luasnip.jump(-1)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
      }),

      -- KEEP YOUR SOURCES WITH OFFSETS
      sources = cmp.config.sources({
        {
          name = "copilot",
          priority = 101, -- Your original score_offset equivalent
          group_index = 1,
        },
        {
          name = "nvim_lsp",
          priority = 100, -- Your original score_offset
          group_index = 1,
        },
        {
          name = "lazydev",
          priority = 100, -- Your original score_offset
          group_index = 1,
        },
        {
          name = "luasnip",
          priority = 50,
          group_index = 2,
        },
        {
          name = "path",
          priority = 90, -- Your original score_offset
          group_index = 2,
        },
      }, {
        {
          name = "buffer",
          priority = -3, -- Your original score_offset (lowest priority)
          group_index = 3,
          option = {
            get_bufnrs = function()
              return vim.tbl_filter(function(buf)
                return vim.bo[buf].buftype ~= "nofile"
              end, vim.api.nvim_list_bufs())
            end
          }
        },
      }),

      -- APPEARANCE MATCHING YOUR BLINK CONFIG
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text", -- Show both symbol and text
          maxwidth = 50,
          ellipsis_char = "...",

          -- KEEP YOUR EXACT ICONS
          symbol_map = {
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

          before = function(entry, vim_item)
            -- Show source name
            vim_item.menu = ({
              copilot = "[Copilot]",
              nvim_lsp = "[LSP]",
              lazydev = "[LazyDev]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]

            return vim_item
          end,
        })
      },

      -- WINDOW CONFIGURATION (BORDERLESS)
      window = {
        completion = {
          border = "none",
          scrollbar = true,
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        },
        documentation = {
          border = "none",
          scrollbar = true,
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        },
      },

      -- BEHAVIOR SETTINGS
      experimental = {
        ghost_text = false, -- Disable to avoid conflicts with Copilot
      },

      completion = {
        completeopt = "menu,menuone,noselect",
      },

      -- PERFORMANCE SETTINGS
      performance = {
        debounce = 60,
        throttle = 30,
        fetching_timeout = 500,
        confirm_resolve_timeout = 80,
        async_budget = 1,
        max_view_entries = 50, -- Match your blink config
      },

      -- SORTING (to maintain priority order)
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
    })

    -- CMDLINE COMPLETION (like your blink setup)
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" }
      }
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" }
      }, {
        { name = "cmdline" }
      })
    })

    -- COPILOT INTEGRATION (matching your blink setup)
    local has_copilot_cmp, copilot_cmp = pcall(require, "copilot_cmp")
    if has_copilot_cmp then
      copilot_cmp.setup()
    end

    -- DISABLE COPILOT WHEN CMP MENU IS OPEN (your original behavior)
    local cmp_group = vim.api.nvim_create_augroup("CmpCopilotIntegration", { clear = true })

    vim.api.nvim_create_autocmd("User", {
      group = cmp_group,
      pattern = "CmpMenuOpen",
      callback = function()
        vim.b.copilot_suggestion_hidden = true
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = cmp_group,
      pattern = "CmpMenuClose",
      callback = function()
        vim.b.copilot_suggestion_hidden = false
      end,
    })
  end,
}
