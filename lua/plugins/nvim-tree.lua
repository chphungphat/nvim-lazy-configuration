return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      view = {
        adaptive_size = false,
        width = 35,
        side = "left",
        preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",

        float = {
          enable = false,
          quit_on_focus_loss = true,
          open_win_config = {
            relative = "editor",
            border = "rounded",
            width = 50,
            height = 40,
            row = 1,
            col = 1,
          },
        },
      },

      -- Enhanced sorting
      sort = {
        sorter = "case_sensitive",
        folders_first = true,
        files_first = false,
      },

      -- Enhanced renderer with better icons and performance
      renderer = {
        add_trailing = false,
        group_empty = true,
        full_name = false,
        highlight_git = "name",
        highlight_diagnostics = "name",
        highlight_opened_files = "name",
        highlight_modified = "name",
        highlight_bookmarks = "none",
        highlight_clipboard = "name",
        root_folder_label = ":~:s?$?/..?",

        -- Enhanced indent markers
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },

        -- Enhanced icons configuration
        icons = {
          git_placement = "after",
          modified_placement = "after",
          padding = " ",
          symlink_arrow = " ➛ ",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
            modified = true,
            diagnostics = true,
            bookmarks = true,
          },
          glyphs = {
            default = "󰈔",
            symlink = "󰌷",
            bookmark = "󰆤",
            modified = "●",
            hidden = "󰀚",
            folder = {
              arrow_closed = "",
              arrow_open = "",
              default = "󰉋",
              open = "󰝰",
              empty = "󰉖",
              empty_open = "󰷏",
              symlink = "󰉒",
              symlink_open = "󰉒",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "󰘬",
              renamed = "➜",
              untracked = "★",
              deleted = "󰍴",
              ignored = "◌",
            },
          },
        },

        -- Enhanced special files configuration
        special_files = {
          "Cargo.toml",
          "Makefile",
          "README.md",
          "readme.md",
          "package.json",
          "package-lock.json",
          "yarn.lock",
          "tsconfig.json",
          "jsconfig.json",
          "vite.config.ts",
          "vite.config.js",
          "tailwind.config.js",
          "tailwind.config.ts",
          ".env",
          ".env.local",
          ".env.production",
          "docker-compose.yml",
          "Dockerfile",
          ".gitignore",
          "init.lua",
        },
      },

      -- Enhanced hijack configuration
      hijack_directories = {
        enable = false,
        auto_open = false,
      },

      -- Enhanced update configuration
      update_focused_file = {
        enable = true,
        update_root = {
          enable = false,
          ignore_list = {},
        },
        exclude = false,
      },

      -- Git integration
      git = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        disable_for_dirs = {},
        timeout = 400,
        cygwin_support = false,
      },

      -- Enhanced diagnostics
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        debounce_delay = 50,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
        icons = {
          hint = "󰠠",
          info = "󰋼",
          warning = "󰀪",
          error = "󰅚",
        },
      },

      -- Enhanced modified files tracking
      modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
      },

      -- Enhanced filters
      filters = {
        git_ignored = false,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        custom = { "^\\.git$", "node_modules", "\\.cache", "__pycache__" },
        exclude = { ".env", ".gitignore", ".editorconfig" },
      },

      -- Enhanced live filter
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = true,
      },

      -- Enhanced actions
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = false,
        },
        expand_all = {
          max_folder_discovery = 300,
          exclude = { ".git", "target", "build", "node_modules", ".next", "dist" },
        },
        file_popup = {
          open_win_config = {
            col = 1,
            row = 1,
            relative = "cursor",
            border = "rounded",
            style = "minimal",
          },
        },
        open_file = {
          quit_on_open = false,
          eject = true,
          resize_window = false,
          window_picker = {
            enable = true,
            picker = "default",
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame", "Trouble" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
        remove_file = {
          close_window = true,
        },
      },

      -- Enhanced trash configuration
      trash = {
        cmd = "gio trash",
      },

      -- Enhanced tab configuration
      tab = {
        sync = {
          open = false,
          close = false,
          ignore = {},
        },
      },

      -- Enhanced notifications
      notify = {
        threshold = vim.log.levels.INFO,
        absolute_path = true,
      },

      -- Enhanced UI
      ui = {
        confirm = {
          remove = true,
          trash = true,
          default_yes = false,
        },
      },

      -- System open configuration
      system_open = {
        cmd = nil,
        args = {},
      },

      -- Log configuration
      log = {
        enable = false,
        truncate = false,
        types = {
          all = false,
          config = false,
          copy_paste = false,
          dev = false,
          diagnostics = false,
          git = false,
          profile = false,
          watcher = false,
        },
      },
    })

    -- ============================================================================
    -- CRITICAL: :qa FIX - THIS ENSURES :qa ALWAYS WORKS
    -- ============================================================================

    local tree_api = require("nvim-tree.api")
    local quit_group = vim.api.nvim_create_augroup("NvimTreeQuitFix", { clear = true })

    -- Method 1: Create alternative quit commands (uppercase as required)
    vim.api.nvim_create_user_command("QA", function()
      tree_api.tree.close()
      vim.schedule(function()
        vim.cmd("qall!")
      end)
    end, {
      desc = "Quit all (handles nvim-tree)",
      bang = true
    })

    vim.api.nvim_create_user_command("QuitAll", function()
      tree_api.tree.close()
      vim.schedule(function()
        vim.cmd("qall!")
      end)
    end, {
      desc = "Quit all (handles nvim-tree)",
      bang = true
    })

    -- Method 1b: Create command alias using cnoreabbrev
    vim.cmd("cnoreabbrev qa QA")
    vim.cmd("cnoreabbrev qall QuitAll")

    -- Method 2: Handle VimLeavePre (before Vim exits)
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = quit_group,
      callback = function()
        pcall(tree_api.tree.close)
      end,
    })

    -- Method 3: Handle QuitPre (when user runs :q or :qa)
    vim.api.nvim_create_autocmd("QuitPre", {
      group = quit_group,
      callback = function()
        local wins = vim.api.nvim_list_wins()
        local normal_wins = 0

        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          local buf_name = vim.api.nvim_buf_get_name(buf)
          if not buf_name:match("NvimTree_") then
            normal_wins = normal_wins + 1
          end
        end

        -- If only one normal window left or we're dying, close tree
        if normal_wins <= 1 or vim.v.dying > 0 then
          pcall(tree_api.tree.close)
        end
      end,
    })

    -- Method 4: Handle WinClosed (when windows are closed)
    vim.api.nvim_create_autocmd("WinClosed", {
      group = quit_group,
      callback = function()
        vim.schedule(function()
          local wins = vim.api.nvim_list_wins()
          local has_normal_wins = false

          for _, win in ipairs(wins) do
            if vim.api.nvim_win_is_valid(win) then
              local buf = vim.api.nvim_win_get_buf(win)
              local buf_name = vim.api.nvim_buf_get_name(buf)
              if not buf_name:match("NvimTree_") then
                has_normal_wins = true
                break
              end
            end
          end

          -- If only nvim-tree windows remain, close them
          if not has_normal_wins then
            pcall(tree_api.tree.close)
          end
        end)
      end,
    })

    -- ============================================================================
    -- ENHANCED KEYMAPS AND FUNCTIONS
    -- ============================================================================

    -- Auto-open nvim-tree when Neovim starts (configurable)
    local function auto_open_tree()
      if not vim.g.nvim_tree_auto_open then
        return
      end

      if vim.fn.argc(-1) == 0 then
        tree_api.tree.open()
      elseif vim.fn.argc(-1) == 1 then
        local arg = vim.fn.argv(0)
        if vim.fn.isdirectory(arg) == 1 then
          tree_api.tree.open()
          tree_api.tree.find_file(arg)
        end
      end
    end

    -- Enhanced focus on current file
    local function focus_on_current_file()
      local current_file = vim.fn.expand("%:p")
      if current_file and current_file ~= "" then
        tree_api.tree.find_file(current_file)
      else
        tree_api.tree.focus()
      end
    end

    -- Enhanced root directory change
    local function change_root_to_global_cwd()
      local global_cwd = vim.fn.getcwd(-1, -1)
      tree_api.tree.change_root(global_cwd)
      vim.notify("Changed root to: " .. global_cwd, vim.log.levels.INFO)
    end

    -- Collapse all folders
    local function collapse_all()
      tree_api.tree.collapse_all(false)
    end

    -- Copy file path to clipboard
    local function copy_path_to_clipboard()
      local node = tree_api.tree.get_node_under_cursor()
      if node then
        local path = node.absolute_path
        vim.fn.setreg("+", path)
        vim.notify("Copied path: " .. path, vim.log.levels.INFO)
      end
    end

    -- Show tree info
    local function show_tree_info()
      local stats = tree_api.tree.get_nodes()
      if stats then
        vim.notify(string.format("Files: %d", #stats), vim.log.levels.INFO)
      end
    end

    -- ============================================================================
    -- KEYMAPS
    -- ============================================================================

    -- Basic nvim-tree keymaps
    vim.keymap.set("n", "<leader>ee", function() tree_api.tree.toggle() end, { desc = "Toggle nvim-tree" })
    vim.keymap.set("n", "<leader>ef", focus_on_current_file, { desc = "Focus on current file" })
    vim.keymap.set("n", "<leader>er", change_root_to_global_cwd, { desc = "Change root to global CWD" })
    vim.keymap.set("n", "<leader>ec", collapse_all, { desc = "Collapse all folders" })
    vim.keymap.set("n", "<leader>ey", copy_path_to_clipboard, { desc = "Copy file path" })
    vim.keymap.set("n", "<leader>ei", show_tree_info, { desc = "Show tree info" })
    vim.keymap.set("n", "<leader>eo", auto_open_tree, { desc = "Auto-open tree" })
    vim.keymap.set("n", "<leader>eh", function() tree_api.tree.toggle_hidden_filter() end,
      { desc = "Toggle hidden files" })

    -- Enhanced quit keymaps that always work
    vim.keymap.set("n", "<leader>qq", function()
      tree_api.tree.close()
      vim.cmd("qa")
    end, { desc = "Quit all (close tree first)" })

    vim.keymap.set("n", "ZZ", function()
      vim.cmd("wa") -- Save all first
      tree_api.tree.close()
      vim.cmd("qa")
    end, { desc = "Save and quit all (handles nvim-tree)" })

    vim.keymap.set("n", "ZQ", function()
      tree_api.tree.close()
      vim.cmd("qa!")
    end, { desc = "Quit without saving (handles nvim-tree)" })

    -- ============================================================================
    -- THEME SYSTEM (GREEN/YELLOW)
    -- ============================================================================

    -- Enhanced highlight groups with theme system
    local function set_nvim_tree_highlight()
      local scheme = vim.g.colors_name or "gruvbox-material"

      local palettes = {
        ["gruvbox-material"] = {
          fg = "#d4be98",
          bg = "#282828",
          green = "#a9b665",
          green_bright = "#b8bb26",
          green_soft = "#98971a",
          yellow = "#d8a657",
          yellow_bright = "#fabd2f",
          yellow_soft = "#d79921",
          orange = "#e78a4e",
          red = "#ea6962",
          gray = "#928374",
          gray_light = "#a89984",
          purple = "#d3869b",
        },
      }

      local c = palettes[scheme] or palettes["gruvbox-material"]

      -- Theme selection (default to green)
      local theme = vim.g.nvim_tree_theme or "green"

      local theme_colors = {}
      if theme == "green" then
        theme_colors = {
          primary = c.green,
          primary_bright = c.green_bright,
          primary_soft = c.green_soft,
          secondary = c.yellow,
          accent = c.orange,
        }
      elseif theme == "yellow" then
        theme_colors = {
          primary = c.yellow,
          primary_bright = c.yellow_bright,
          primary_soft = c.yellow_soft,
          secondary = c.green,
          accent = c.orange,
        }
      end

      local highlights = {
        -- Git highlights with chosen theme
        { name = "NvimTreeGitNew",                    fg = theme_colors.primary_bright, bold = true },
        { name = "NvimTreeGitDirty",                  fg = theme_colors.secondary,      bold = true },
        { name = "NvimTreeGitDeleted",                fg = c.red,                       bold = true },
        { name = "NvimTreeGitStaged",                 fg = theme_colors.primary,        bold = true },
        { name = "NvimTreeGitRenamed",                fg = c.purple,                    bold = true },
        { name = "NvimTreeGitIgnored",                fg = c.gray,                      italic = true },

        -- Diagnostic highlights (keeping logical colors)
        { name = "NvimTreeLspDiagnosticsError",       fg = c.red,                       bold = true },
        { name = "NvimTreeLspDiagnosticsWarning",     fg = c.yellow_bright,             bold = true },
        { name = "NvimTreeLspDiagnosticsInformation", fg = theme_colors.primary,        bold = true },
        { name = "NvimTreeLspDiagnosticsHint",        fg = theme_colors.primary_soft,   bold = true },

        -- File type highlights
        { name = "NvimTreeIndentMarker",              fg = c.gray },
        { name = "NvimTreeWindowPicker",              fg = c.bg,                        bg = theme_colors.accent, bold = true },
        { name = "NvimTreeSpecialFile",               fg = theme_colors.accent,         bold = true,              underline = true },
        { name = "NvimTreeSymlink",                   fg = c.purple,                    italic = true },
        { name = "NvimTreeImageFile",                 fg = c.purple },
        { name = "NvimTreeMarkdownFile",              fg = theme_colors.primary },
        { name = "NvimTreeExecFile",                  fg = theme_colors.primary_bright, bold = true },

        -- Folder highlights with chosen theme
        { name = "NvimTreeFolderName",                fg = theme_colors.primary,        bold = true },
        { name = "NvimTreeRootFolder",                fg = theme_colors.primary_bright, bold = true,              underline = true },
        { name = "NvimTreeOpenedFolderName",          fg = theme_colors.primary_bright, bold = true },
        { name = "NvimTreeEmptyFolderName",           fg = theme_colors.primary_soft },

        -- Status highlights
        { name = "NvimTreeModifiedFile",              fg = theme_colors.secondary,      bold = true },
        { name = "NvimTreeBookmark",                  fg = theme_colors.primary,        bold = true },
        { name = "NvimTreeHiddenFile",                fg = c.gray,                      italic = true },

        -- Additional file name highlights
        { name = "NvimTreeFileName",                  fg = c.fg },
        { name = "NvimTreeFileNameOpened",            fg = theme_colors.primary },

        -- Normal files and background
        { name = "NvimTreeNormal",                    fg = c.fg,                        bg = c.bg },
        { name = "NvimTreeEndOfBuffer",               fg = c.bg,                        bg = c.bg },
      }

      for _, h in ipairs(highlights) do
        local name = h.name
        h.name = nil
        vim.api.nvim_set_hl(0, name, h)
      end
    end

    -- Apply highlights immediately and on colorscheme change
    set_nvim_tree_highlight()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(set_nvim_tree_highlight)
      end,
    })

    -- ============================================================================
    -- AUTO-COMMANDS
    -- ============================================================================

    local nvim_tree_augroup = vim.api.nvim_create_augroup("NvimTreeEnhanced", { clear = true })

    -- Auto-open nvim-tree on startup
    vim.api.nvim_create_autocmd("VimEnter", {
      group = nvim_tree_augroup,
      callback = function()
        if vim.g.nvim_tree_auto_open then
          vim.schedule(auto_open_tree)
        end
      end,
    })

    -- Better window management
    vim.api.nvim_create_autocmd("BufEnter", {
      group = nvim_tree_augroup,
      pattern = "NvimTree_*",
      callback = function()
        local win = vim.api.nvim_get_current_win()
        if vim.api.nvim_win_is_valid(win) then
          vim.schedule(function()
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_set_width(win, 35)
            end
          end)
        end
      end,
    })

    -- ============================================================================
    -- USER COMMANDS
    -- ============================================================================

    -- Auto-open control commands
    vim.api.nvim_create_user_command("NvimTreeAutoOpenEnable", function()
      vim.g.nvim_tree_auto_open = true
      vim.notify("nvim-tree auto-open enabled", vim.log.levels.INFO)
    end, { desc = "Enable nvim-tree auto-open on startup" })

    vim.api.nvim_create_user_command("NvimTreeAutoOpenDisable", function()
      vim.g.nvim_tree_auto_open = false
      vim.notify("nvim-tree auto-open disabled", vim.log.levels.INFO)
    end, { desc = "Disable nvim-tree auto-open on startup" })

    vim.api.nvim_create_user_command("NvimTreeAutoOpenToggle", function()
      vim.g.nvim_tree_auto_open = not vim.g.nvim_tree_auto_open
      local status = vim.g.nvim_tree_auto_open and "enabled" or "disabled"
      vim.notify("nvim-tree auto-open " .. status, vim.log.levels.INFO)
    end, { desc = "Toggle nvim-tree auto-open on startup" })

    -- Theme switching commands
    vim.api.nvim_create_user_command("NvimTreeThemeGreen", function()
      vim.g.nvim_tree_theme = "green"
      set_nvim_tree_highlight()
      vim.notify("nvim-tree theme set to GREEN", vim.log.levels.INFO)
    end, { desc = "Set nvim-tree theme to green" })

    vim.api.nvim_create_user_command("NvimTreeThemeYellow", function()
      vim.g.nvim_tree_theme = "yellow"
      set_nvim_tree_highlight()
      vim.notify("nvim-tree theme set to YELLOW", vim.log.levels.INFO)
    end, { desc = "Set nvim-tree theme to yellow" })

    vim.api.nvim_create_user_command("NvimTreeThemeToggle", function()
      local current = vim.g.nvim_tree_theme or "green"
      vim.g.nvim_tree_theme = (current == "green") and "yellow" or "green"
      set_nvim_tree_highlight()
      vim.notify("nvim-tree theme switched to " .. string.upper(vim.g.nvim_tree_theme), vim.log.levels.INFO)
    end, { desc = "Toggle nvim-tree theme between green and yellow" })

    -- Theme switching keymap
    vim.keymap.set("n", "<leader>et", "<cmd>NvimTreeThemeToggle<CR>", { desc = "Toggle nvim-tree theme" })

    -- ============================================================================
    -- GLOBAL CONFIGURATION
    -- ============================================================================

    -- Set default theme if not already set
    if vim.g.nvim_tree_theme == nil then
      vim.g.nvim_tree_theme = "green" -- Change this to "yellow" if you prefer yellow by default
    end

    -- Set auto-open default if not already set
    if vim.g.nvim_tree_auto_open == nil then
      vim.g.nvim_tree_auto_open = true -- Change to false if you don't want auto-open
    end
  end,
}
