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
      -- Enhanced view configuration
      view = {
        adaptive_size = true,
        width = { min = 30, max = 100 },
        side = "left",
        preserve_window_proportions = true,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        -- Add floating window option (optional)
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
        sorter = "case_sensitive", -- Better than "name"
        folders_first = true,
        files_first = false,
      },

      -- Enhanced renderer with better icons and performance
      renderer = {
        add_trailing = false,
        group_empty = true, -- Group empty folders
        full_name = false,
        highlight_git = "name",
        highlight_diagnostics = "name",
        highlight_opened_files = "name",
        highlight_modified = "name",
        highlight_bookmarks = "none",
        highlight_clipboard = "name",

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
          "tsconfig.json",
          "jsconfig.json",
          "vite.config.ts",
          "vite.config.js",
          "tailwind.config.js",
          "tailwind.config.ts",
          ".env",
          ".env.local",
          "docker-compose.yml",
          "Dockerfile",
        },
      },

      -- Enhanced hijack configuration
      hijack_directories = {
        enable = false,
        auto_open = false,
      },

      -- Enhanced update configuration
      update_focused_file = {
        enable = false,
        update_root = {
          enable = true,
          ignore_list = {},
        },
        exclude = false,
      },

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
        custom = { "^\\.git$", "node_modules", "\\.cache" },
        exclude = { ".env", ".gitignore" },
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
          exclude = { ".git", "target", "build", "node_modules" },
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
          resize_window = true,
          window_picker = {
            enable = true,
            picker = "default",
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
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

      -- Enhanced experimental features
      experimental = {
        actions = {
          open_file = {
            relative_path = true,
          },
        },
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
          aqua = "#89b482",
          yellow = "#d8a657",
          orange = "#e78a4e",
          red = "#ea6962",
          gray = "#928374",
          blue = "#7daea3",
          purple = "#d3869b",
        },
        ["kanagawa"] = {
          fg = "#C5C9C5",
          bg = "#1F1F28",
          green = "#98BB6C",
          aqua = "#7AA89F",
          yellow = "#DCA561",
          orange = "#FFA066",
          red = "#E82424",
          gray = "#727169",
          blue = "#7E9CD8",
          purple = "#957FB8",
        },
      }

      local c = palettes[scheme] or palettes["gruvbox-material"]

      local highlights = {
        -- Git highlights
        { name = "NvimTreeGitNewHL",                fg = c.green,  bold = true },
        { name = "NvimTreeGitFolderNewHL",          fg = c.green,  bold = true },
        { name = "NvimTreeGitDirtyHL",              fg = c.yellow, bold = true },
        { name = "NvimTreeGitFolderDirtyHL",        fg = c.yellow, bold = true },
        { name = "NvimTreeGitDeletedHL",            fg = c.red,    bold = true },
        { name = "NvimTreeGitFolderDeletedHL",      fg = c.red,    bold = true },
        { name = "NvimTreeGitStagedHL",             fg = c.aqua,   bold = true },
        { name = "NvimTreeGitFolderStagedHL",       fg = c.aqua,   bold = true },
        { name = "NvimTreeGitRenamedHL",            fg = c.purple, bold = true },
        { name = "NvimTreeGitFolderRenamedHL",      fg = c.purple, bold = true },
        { name = "NvimTreeGitIgnoredHL",            fg = c.gray,   italic = true },
        { name = "NvimTreeGitFolderIgnoredHL",      fg = c.gray,   italic = true },

        -- Diagnostic highlights
        { name = "NvimTreeDiagnosticErrorFileHL",   fg = c.red,    underline = true },
        { name = "NvimTreeDiagnosticErrorFolderHL", fg = c.red,    bold = true },
        { name = "NvimTreeDiagnosticWarnFileHL",    fg = c.yellow, underline = true },
        { name = "NvimTreeDiagnosticWarnFolderHL",  fg = c.yellow, bold = true },
        { name = "NvimTreeDiagnosticInfoFileHL",    fg = c.blue,   underline = true },
        { name = "NvimTreeDiagnosticInfoFolderHL",  fg = c.blue,   bold = true },
        { name = "NvimTreeDiagnosticHintFileHL",    fg = c.aqua,   underline = true },
        { name = "NvimTreeDiagnosticHintFolderHL",  fg = c.aqua,   bold = true },

        -- Other highlights
        { name = "NvimTreeIndentMarker",            fg = c.gray },
        { name = "NvimTreeWindowPicker",            fg = c.bg,     bg = c.orange,   bold = true },
        { name = "NvimTreeSpecialFile",             fg = c.orange, bold = true,     underline = true },
        { name = "NvimTreeSymlink",                 fg = c.purple, italic = true },
        { name = "NvimTreeModifiedFile",            fg = c.yellow, bold = true },
        { name = "NvimTreeBookmark",                fg = c.blue,   bold = true },
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

    -- Smart toggle function (enhanced version of your original)
    -- local function smart_tree_toggle()
    --   local nvim_tree_view = require("nvim-tree.view")
    --   local current_buf = vim.api.nvim_get_current_buf()
    --   local current_buf_ft = vim.api.nvim_get_option_value("filetype", { buf = current_buf })
    --
    --   if current_buf_ft == "NvimTree" then
    --     tree_api.tree.close()
    --   elseif nvim_tree_view.is_visible() then
    --     tree_api.tree.focus()
    --   else
    --     tree_api.tree.open()
    --   end
    -- end

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

    -- Enhanced keymaps
    vim.keymap.set("n", "<leader>ee", function() tree_api.tree.toggle() end, { desc = "Simple toggle tree" })
    vim.keymap.set("n", "<leader>ef", focus_on_current_file, { desc = "Focus on current file" })
    vim.keymap.set("n", "<leader>er", change_root_to_global_cwd, { desc = "Change root to global CWD" })
    vim.keymap.set("n", "<leader>ec", collapse_all, { desc = "Collapse all folders" })
    vim.keymap.set("n", "<leader>ey", copy_path_to_clipboard, { desc = "Copy file path" })

    vim.keymap.set("n", "<leader>eh", function() tree_api.tree.toggle_hidden_filter() end,
      { desc = "Toggle hidden files" })





    -- Enhanced auto-commands
    local nvim_tree_augroup = vim.api.nvim_create_augroup("NvimTreeEnhanced", { clear = true })

    -- Set statusline to show the tree name
    vim.api.nvim_create_autocmd("FileType", {
      group = nvim_tree_augroup,
      pattern = "NvimTree",
      callback = function()
        vim.opt_local.statusline = "%#NvimTreeStatusline# 󰙅 Explorer %#NvimTreeStatuslineNC#"
      end,
    })

    -- Auto-close if last window
    vim.api.nvim_create_autocmd("QuitPre", {
      group = nvim_tree_augroup,
      callback = function()
        local wins = vim.api.nvim_list_wins()
        -- Count non-nvim-tree windows
        local count = 0
        for _, w in ipairs(wins) do
          local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
          if bufname:match("NvimTree_") == nil then
            count = count + 1
          end
        end
        -- If only nvim-tree windows are left, close nvim-tree
        if count == 1 then
          tree_api.tree.close()
        end
      end,
    })

    -- Notification for successful setup
    vim.notify("✅ Enhanced nvim-tree loaded successfully!", vim.log.levels.INFO)
  end,
}
