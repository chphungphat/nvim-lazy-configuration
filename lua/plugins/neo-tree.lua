return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    -- Optional: For window picker functionality
    {
      "s1n7ax/nvim-window-picker",
      version = "2.*",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },
              buftype = { "terminal", "quickfix" },
            },
          },
        })
      end,
    },
  },
  cmd = "Neotree",
  lazy = true, -- Ensure it's lazy loaded
  keys = {
    { "<leader>ee", "<cmd>Neotree toggle<cr>",             desc = "Toggle neo-tree" },
    { "<leader>ef", "<cmd>Neotree reveal<cr>",             desc = "Focus on current file" },
    { "<leader>er", "<cmd>Neotree dir=<cr>",               desc = "Change root to global CWD" },
    { "<leader>ec", "<cmd>Neotree close<cr>",              desc = "Close neo-tree" },
    { "<leader>eh", "<cmd>Neotree toggle show_hidden<cr>", desc = "Toggle hidden files" },
  },

  config = function()
    -- Disable netrw (just like your nvim-tree config)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("neo-tree").setup({
      -- Close neo-tree if it's the last window - but don't interfere with :qa
      close_if_last_window = false, -- FIXED: Let :qa work normally

      -- Enable popup borders for better UX
      popup_border_style = "rounded",

      -- Enable file nesting (similar to your nvim-tree group_empty)
      enable_git_status = true,
      enable_diagnostics = true,
      enable_modified_markers = true, -- FIXED: Show modified file markers like nvim-tree
      enable_opened_markers = true,   -- FIXED: Show opened file markers
      enable_refresh_on_write = true, -- Auto-refresh like nvim-tree

      -- Sort configuration (matching your nvim-tree case_sensitive)
      sort_case_insensitive = false,
      sort_function = nil,

      -- Default component configs (icons and styling)
      default_component_configs = {
        container = {
          enable_character_fade = true,
          -- REMOVED: Invalid width config that was causing errors
        },

        -- Indent configuration (better spacing like nvim-tree)
        indent = {
          indent_size = 2,
          padding = 2, -- FIXED: Add more space between icons and text (like nvim-tree)
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          with_expanders = nil,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },

        -- Icon configuration (matching your enhanced nvim-tree icons)
        icon = {
          folder_closed = "󰉋",
          folder_open = "󰝰",
          folder_empty = "󰉖",
          folder_empty_open = "󰷏",
          default = "󰈔",
          highlight = "NeoTreeFileIcon",
        },

        -- Modified markers (like nvim-tree modified indicators)
        modified = {
          symbol = " ●", -- FIXED: More prominent modified marker with space
          highlight = "NeoTreeModified",
        },

        -- Name configuration
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },

        -- Git status configuration (meaningful symbols with semantic colors)
        git_status = {
          symbols = {
            -- Git status symbols (each with semantic meaning)
            added = "✓", -- Checkmark = successfully added (green)
            modified = "◐", -- Half-filled circle = partially changed (yellow)
            deleted = "", -- Trash can = deleted (red)
            renamed = "→", -- Arrow = moved/renamed (purple)
            -- Status type
            untracked = "◆", -- Diamond = new/precious (blue)
            ignored = "◌", -- Empty circle = ignored/hollow (gray)
            unstaged = "◉", -- Filled circle = needs attention (orange)
            staged = "✓", -- Checkmark = ready to go (green)
            conflict = "⚠", -- Warning = needs resolution (red)
          },
          align = "right", -- Align git status to the right like nvim-tree
        },

        -- File size
        file_size = {
          enabled = true,
          required_width = 50,
        },

        -- Type (file extension)
        type = {
          enabled = true,
          required_width = 80,
        },

        -- Last modified
        last_modified = {
          enabled = true,
          required_width = 88,
        },

        -- Created time
        created = {
          enabled = true,
          required_width = 110,
        },

        -- Diagnostics (LSP status with meaningful symbols and colors)
        diagnostics = {
          symbols = {
            hint = "💡", -- Light bulb = helpful hint (aqua)
            info = "ℹ", -- Info symbol = information (blue)
            warn = "⚠", -- Warning triangle = caution (yellow)
            error = "", -- X/cross = error (red)
          },
          highlights = {
            hint = "NeoTreeDiagnosticHintText",
            info = "NeoTreeDiagnosticInfoText",
            warn = "NeoTreeDiagnosticWarnText",
            error = "NeoTreeDiagnosticErrorText",
          },
        },

        -- Symlink target
        symlink_target = {
          enabled = false,
        },
      },

      -- Commands for custom functionality
      commands = {
        -- Copy file path to clipboard (matching your nvim-tree functionality)
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local results = {
            filepath,
            modify(filepath, ":."),
            modify(filepath, ":~"),
            filename,
            modify(filename, ":r"),
            modify(filename, ":e"),
          }

          vim.ui.select(results, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item)
              return "  " .. item
            end,
          }, function(choice)
            if choice then
              vim.fn.setreg("+", choice)
              vim.notify("Copied: " .. choice)
            end
          end)
        end,
      },

      -- Window configuration (fixed width, no dynamic expansion)
      window = {
        position = "left",
        width = 35,                -- Fixed width in columns
        height = 15,
        auto_expand_width = false, -- Disable auto expansion

        -- Mappings (keeping some familiar nvim-tree keybinds)
        mappings = {
          ["<space>"] = {
            "toggle_node",
            nowait = false,
          },
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["<esc>"] = "cancel",
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
          ["l"] = "focus_preview",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["w"] = "open_with_window_picker",
          ["C"] = "close_node",
          ["z"] = "close_all_nodes",
          ["Z"] = "expand_all_nodes",
          ["a"] = {
            "add",
            config = {
              show_path = "none",
            },
          },
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy", -- takes text input for destination
          ["m"] = "move", -- takes text input for destination
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["<"] = "prev_source",
          [">"] = "next_source",
          ["i"] = "show_file_details",
          ["Y"] = "copy_selector", -- Custom command for copying paths
        },
      },

      -- Nesting rules (similar to your nvim-tree group_empty functionality)
      nesting_rules = {},

      -- Filesystem configuration
      filesystem = {
        -- Following current file (like your nvim-tree update_focused_file)
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },

        -- Group empty directories (like your nvim-tree)
        group_empty_dirs = true,

        -- Hijack netrw (like your nvim-tree)
        hijack_netrw_behavior = "open_default",

        -- Use libuv file watcher
        use_libuv_file_watcher = true,

        -- Filtered items (matching your nvim-tree filters)
        filtered_items = {
          visible = false,
          hide_dotfiles = false,   -- Matching your config
          hide_gitignored = false, -- Matching your config
          hide_hidden = true,
          hide_by_name = {
            "node_modules", -- From your config
            ".git",
            ".cache",
          },
          hide_by_pattern = {},
          always_show = {
            ".env",
            ".gitignore", -- From your config
          },
          never_show = {
            ".DS_Store", -- From your config
            "thumbs.db", -- From your config
          },
        },

        -- Window configuration for filesystem
        window = {
          -- REMOVED: Invalid width config at filesystem level
          mappings = {
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["D"] = "fuzzy_finder_directory",
            ["#"] = "fuzzy_sorter",
            ["f"] = "filter_on_submit",
            ["<c-x>"] = "clear_filter",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["og"] = { "order_by_git_status", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          },
          fuzzy_finder_mappings = {
            ["<down>"] = "move_cursor_down",
            ["<C-n>"] = "move_cursor_down",
            ["<up>"] = "move_cursor_up",
            ["<C-p>"] = "move_cursor_up",
          },
        },

        -- Commands
        commands = {},
      },

      -- Buffers configuration (additional feature not in nvim-tree)
      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = true,
        show_unloaded = true,
        window = {
          mappings = {
            ["bd"] = "buffer_delete",
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          },
        },
      },

      -- Git status configuration (additional feature)
      git_status = {
        window = {
          position = "float",
          mappings = {
            ["A"] = "git_add_all",
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",
            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          },
        },
      },
    })

    -- Enhanced highlight groups with your color theming
    local function set_neo_tree_highlights()
      local scheme = vim.g.colors_name or "gruvbox-material"

      local palettes = {
        ["gruvbox-material"] = {
          fg = "#d4be98",     -- Main foreground (gruvbox-material fg)
          bg = "#282828",     -- Main background (gruvbox-material bg)
          bg0 = "#1d2021",    -- Darker background
          bg1 = "#282828",    -- Standard background
          bg2 = "#32302f",    -- Lighter background
          fg0 = "#fbf1c7",    -- Bright foreground
          fg1 = "#ebdbb2",    -- Standard foreground
          gray = "#928374",   -- Gray (comments)
          red = "#ea6962",    -- Red (errors, deleted)
          green = "#a9b665",  -- Green (added, strings)
          yellow = "#d8a657", -- Yellow (warnings, modified)
          blue = "#7daea3",   -- Blue (functions, directories)
          purple = "#d3869b", -- Purple (keywords)
          aqua = "#89b482",   -- Aqua (operators)
          orange = "#e78a4e", -- Orange (numbers)
        },
        ["kanagawa"] = {
          fg = "#C5C9C5",
          bg = "#1F1F28",
          bg0 = "#16161D",
          bg1 = "#1F1F28",
          bg2 = "#2A2A37",
          fg0 = "#D5CEE3",
          fg1 = "#C8C093",
          gray = "#727169",
          red = "#E82424",
          green = "#98BB6C",
          yellow = "#DCA561",
          blue = "#7E9CD8",
          purple = "#957FB8",
          aqua = "#7AA89F",
          orange = "#FFA066",
        },
      }

      local c = palettes[scheme] or palettes["gruvbox-material"]

      local highlights = {
        -- Git highlights (semantic colors for each status)
        { name = "NeoTreeGitAdded",            fg = c.green,  bold = true },   -- ✓ Green = success/added
        { name = "NeoTreeGitConflict",         fg = c.red,    bold = true },   -- ⚠ Red = danger/conflict
        { name = "NeoTreeGitDeleted",          fg = c.red,    bold = true },   --  Red = deleted/removed
        { name = "NeoTreeGitIgnored",          fg = c.gray,   italic = true }, -- ◌ Gray = ignored/inactive
        { name = "NeoTreeGitModified",         fg = c.yellow, bold = true },   -- ◐ Yellow = changed/modified
        { name = "NeoTreeGitUnstaged",         fg = c.orange, bold = true },   -- ◉ Orange = needs attention
        { name = "NeoTreeGitUntracked",        fg = c.blue,   bold = true },   -- ◆ Blue = new/untracked
        { name = "NeoTreeGitStaged",           fg = c.green,  bold = true },   -- ✓ Green = ready/staged
        { name = "NeoTreeGitRenamed",          fg = c.purple, bold = true },   -- → Purple = moved/renamed

        -- Buffer modification (distinct from git)
        { name = "NeoTreeModified",            fg = c.orange, bold = true }, -- ● Orange = unsaved buffer changes
        { name = "NeoTreeFileNameOpened",      fg = c.green,  bold = true }, -- Currently opened files

        -- LSP Diagnostics (semantic colors)
        { name = "NeoTreeDiagnosticErrorText", fg = c.red,    bold = true }, --  Red = error
        { name = "NeoTreeDiagnosticWarnText",  fg = c.yellow, bold = true }, -- ⚠ Yellow = warning
        { name = "NeoTreeDiagnosticInfoText",  fg = c.blue,   bold = true }, -- ℹ Blue = info
        { name = "NeoTreeDiagnosticHintText",  fg = c.aqua,   bold = true }, -- 💡 Aqua = hint

        -- Tree structure elements
        { name = "NeoTreeExpander",            fg = c.gray },
        { name = "NeoTreeIndentMarker",        fg = c.gray },

        -- Directory highlights (proper gruvbox-material blue)
        { name = "NeoTreeDirectoryName",       fg = c.blue,   bold = true },
        { name = "NeoTreeDirectoryIcon",       fg = c.blue },
        { name = "NeoTreeRootName",            fg = c.blue,   bold = true,  underline = true },

        -- File name highlights (default and special cases)
        { name = "NeoTreeFileName",            fg = c.fg1 },
        { name = "NeoTreeFileIcon",            fg = c.fg1 },

        -- Symlinks
        { name = "NeoTreeSymbolicLinkTarget",  fg = c.purple, italic = true },

        -- Special UI elements
        { name = "NeoTreeFloatBorder",         fg = c.gray },
        { name = "NeoTreeFloatTitle",          fg = c.orange, bold = true },
        { name = "NeoTreeTitleBar",            fg = c.orange, bold = true },
        { name = "NeoTreeWindowsHidden",       fg = c.gray,   italic = true },
        { name = "NeoTreeCursorLine",          bg = c.bg2 },

        -- Background and UI consistency
        { name = "NeoTreeNormal",              fg = c.fg1,    bg = c.bg1 },
        { name = "NeoTreeNormalNC",            fg = c.fg1,    bg = c.bg1 },
        { name = "NeoTreeSignColumn",          bg = c.bg1 },
        { name = "NeoTreeEndOfBuffer",         fg = c.bg1,    bg = c.bg1 },

        -- Status line in neo-tree
        { name = "NeoTreeStatusLine",          fg = c.fg1,    bg = c.bg2 },
        { name = "NeoTreeStatusLineNC",        fg = c.gray,   bg = c.bg1 },
      }

      for _, h in ipairs(highlights) do
        local name = h.name
        h.name = nil
        vim.api.nvim_set_hl(0, name, h)
      end
    end

    -- Apply highlights immediately and on colorscheme change
    set_neo_tree_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_neo_tree_highlights)
      end,
    })

    -- Enhanced auto-commands (fixed :qa behavior)
    local neo_tree_augroup = vim.api.nvim_create_augroup("NeoTreeEnhanced", { clear = true })

    -- FIXED: Prevent neo-tree from expanding beyond fixed width
    vim.api.nvim_create_autocmd("BufEnter", {
      group = neo_tree_augroup,
      pattern = "*neo-tree*",
      callback = function()
        local win = vim.api.nvim_get_current_win()
        if vim.bo.filetype == "neo-tree" then
          vim.schedule(function()
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_set_width(win, 35) -- Force width to 35
            end
          end)
        end
      end,
    })

    -- REMOVED: Auto-close autocmd that was interfering with :qa
    -- Let user manually close neo-tree or use :qa normally

    -- Notification for successful setup
    vim.notify("✅ Enhanced neo-tree loaded successfully!", vim.log.levels.INFO)
  end,
}
