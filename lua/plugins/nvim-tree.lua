return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- Disable netrw at the very start of your init.lua (already in your config)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      -- MODERN: Improved auto-close behavior
      -- Enhanced view configuration
      view = {
        adaptive_size = false,               -- UPDATED: Use fixed width for consistency
        width = 35,                          -- UPDATED: Fixed width matching your preference
        side = "left",
        preserve_window_proportions = false, -- UPDATED: Better window management
        number = false,
        relativenumber = false,
        signcolumn = "yes",



        -- MODERN: Enhanced float options (optional feature)
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
        sorter = "case_sensitive", -- UPDATED: Better than "name"
        folders_first = true,
        files_first = false,
      },

      -- Enhanced renderer with better icons and performance
      renderer = {
        add_trailing = false,
        group_empty = true,              -- Group empty folders
        full_name = false,
        highlight_git = "name",          -- UPDATED: Better git highlighting
        highlight_diagnostics = "name",  -- UPDATED: Show diagnostics on names
        highlight_opened_files = "name", -- UPDATED: Highlight opened files
        highlight_modified = "name",     -- UPDATED: Show modified files
        highlight_bookmarks = "none",
        highlight_clipboard = "name",
        root_folder_label = ":~:s?$?/..?", -- UPDATED: Better root display

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
            hidden = "󰀚", -- ADDED: Hidden file icon
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
          "package-lock.json", -- ADDED
          "yarn.lock",         -- ADDED
          "tsconfig.json",
          "jsconfig.json",
          "vite.config.ts",
          "vite.config.js",
          "tailwind.config.js",
          "tailwind.config.ts",
          ".env",
          ".env.local",
          ".env.production", -- ADDED
          "docker-compose.yml",
          "Dockerfile",
          ".gitignore", -- ADDED
          "init.lua",   -- ADDED
        },
      },

      -- Enhanced hijack configuration
      hijack_directories = {
        enable = false,
        auto_open = false,
      },

      -- Enhanced update configuration
      update_focused_file = {
        enable = true,    -- UPDATED: Enable for better navigation
        update_root = {
          enable = false, -- UPDATED: Don't auto-change root
          ignore_list = {},
        },
        exclude = false,
      },

      -- ENHANCED: Git integration
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
        custom = { "^\\.git$", "node_modules", "\\.cache", "__pycache__" }, -- ADDED Python cache
        exclude = { ".env", ".gitignore", ".editorconfig" },                -- ADDED .editorconfig
      },

      -- Enhanced live filter
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = true,
      },

      -- FIXED: Ensure nvim-tree closes properly with :qa
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = false,
        },
        expand_all = {
          max_folder_discovery = 300,
          exclude = { ".git", "target", "build", "node_modules", ".next", "dist" }, -- ADDED modern build dirs
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
          resize_window = false, -- UPDATED: Don't resize to maintain fixed width
          window_picker = {
            enable = true,
            picker = "default",
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame", "Trouble" }, -- ADDED Trouble
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
        cmd = "gio trash", -- Use system trash (safer than rm)
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

      -- MODERN: System open configuration
      system_open = {
        cmd = nil, -- Auto-detect based on OS
        args = {},
      },

      -- Enhanced log configuration
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

    -- Enhanced highlight groups with better theming
    local function set_nvim_tree_highlight()
      local scheme = vim.g.colors_name or "gruvbox-material"

      local palettes = {
        ["gruvbox-material"] = {
          fg = "#d4be98",
          bg = "#282828",
          green = "#a9b665",
          green_bright = "#b8bb26",  -- Brighter green
          green_soft = "#98971a",    -- Softer green
          yellow = "#d8a657",
          yellow_bright = "#fabd2f", -- Brighter yellow
          yellow_soft = "#d79921",   -- Softer yellow
          orange = "#e78a4e",
          red = "#ea6962",
          gray = "#928374",
          gray_light = "#a89984",
          purple = "#d3869b",
        },
      }

      local c = palettes[scheme] or palettes["gruvbox-material"]

      -- Choose your preferred theme: "green" or "yellow"
      -- Change this to "yellow" if you prefer yellow theme
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

        -- Enhanced file type highlights
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

        -- Additional file name highlights for better theme consistency
        { name = "NvimTreeFileName",                  fg = c.fg },
        { name = "NvimTreeFileNameOpened",            fg = theme_colors.primary },

        -- Normal files get a subtle theme tint
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

    -- Enhanced keymaps and functions
    local tree_api = require("nvim-tree.api")

    -- Auto-open nvim-tree when Neovim starts (optional)
    local function auto_open_tree()
      -- Check if auto-open is enabled
      if not vim.g.nvim_tree_auto_open then
        return
      end

      -- Only auto-open if no arguments were passed to nvim
      if vim.fn.argc(-1) == 0 then
        tree_api.tree.open()
      elseif vim.fn.argc(-1) == 1 then
        -- If opening a directory, open tree and focus on it
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

    -- Enhanced keymaps
    vim.keymap.set("n", "<leader>ee", function() tree_api.tree.toggle() end, { desc = "Toggle nvim-tree" })
    vim.keymap.set("n", "<leader>ef", focus_on_current_file, { desc = "Focus on current file" })
    vim.keymap.set("n", "<leader>er", change_root_to_global_cwd, { desc = "Change root to global CWD" })
    vim.keymap.set("n", "<leader>ec", collapse_all, { desc = "Collapse all folders" })
    vim.keymap.set("n", "<leader>ey", copy_path_to_clipboard, { desc = "Copy file path" })
    vim.keymap.set("n", "<leader>ei", show_tree_info, { desc = "Show tree info" })
    vim.keymap.set("n", "<leader>eo", auto_open_tree, { desc = "Auto-open tree" })

    vim.keymap.set("n", "<leader>eh", function() tree_api.tree.toggle_hidden_filter() end,
      { desc = "Toggle hidden files" })

    -- Global variable to control auto-open (set to false to disable)
    if vim.g.nvim_tree_auto_open == nil then
      vim.g.nvim_tree_auto_open = true
    end

    -- Enhanced auto-commands
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

    -- MODERN: Better window management
    vim.api.nvim_create_autocmd("BufEnter", {
      group = nvim_tree_augroup,
      pattern = "NvimTree_*",
      callback = function()
        -- Ensure nvim-tree maintains fixed width
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

    -- MODERN: Auto-close handling (FIXED for :qa behavior)
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = nvim_tree_augroup,
      callback = function()
        -- Always close nvim-tree before vim exits
        pcall(tree_api.tree.close)
      end,
    })

    vim.api.nvim_create_autocmd("QuitPre", {
      group = nvim_tree_augroup,
      callback = function()
        local wins = vim.api.nvim_list_wins()
        local tree_wins = {}
        local other_wins = {}

        -- Categorize windows
        for _, w in ipairs(wins) do
          local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
          if bufname:match("NvimTree_") then
            table.insert(tree_wins, w)
          else
            table.insert(other_wins, w)
          end
        end

        -- If user runs :qa or there are no other windows, close tree first
        if #other_wins <= 1 or vim.v.dying > 0 then
          pcall(tree_api.tree.close)
        end
      end,
    })

    -- Better handling for window closing
    vim.api.nvim_create_autocmd("WinClosed", {
      group = nvim_tree_augroup,
      callback = function()
        -- Delay to let other windows close first
        vim.schedule(function()
          local wins = vim.api.nvim_list_wins()
          local has_normal_wins = false

          for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if not bufname:match("NvimTree_") then
              has_normal_wins = true
              break
            end
          end

          -- If only nvim-tree windows remain, close them
          if not has_normal_wins then
            pcall(tree_api.tree.close)
          end
        end)
      end,
    })

    -- MODERN: Performance optimization for large directories
    vim.api.nvim_create_autocmd("BufReadPre", {
      group = nvim_tree_augroup,
      callback = function()
        -- Add any performance optimizations here if needed
      end,
    })
  end,
}
