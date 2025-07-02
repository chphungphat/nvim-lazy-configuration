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
      auto_reload_on_write = true,
      hijack_cursor = false,
      disable_netrw = false,
      hijack_netrw = true,

      view = {
        width = 30,
        side = "left",
        preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        cursorline = true,
        debounce_delay = 15,
      },

      renderer = {
        add_trailing = false,
        group_empty = false,
        full_name = false,
        root_folder_label = ":~:s?$?/..?",
        indent_width = 2,

        highlight_git = "name",         -- Only highlight file names, no icons
        highlight_diagnostics = "name", -- Only highlight file names, no icons
        highlight_opened_files = "none",
        highlight_modified = "none",
        highlight_bookmarks = "none",
        highlight_clipboard = "none",

        icons = {
          git_placement = "after",
          modified_placement = "after",
          padding = " ",
          symlink_arrow = " ➛ ",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,         -- Disable git icons
            modified = false,    -- Disable modified icons
            diagnostics = false, -- Disable diagnostic icons
            bookmarks = false,
            hidden = false,
          },
          glyphs = {
            default = "󰈔",
            symlink = "󰌷",
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
          },
        },

        decorators = {
          "Git",         -- Enable git highlighting
          "Diagnostics", -- Enable diagnostic highlighting
          "Open",        -- Keep open file highlighting
        },

        -- Minimal special files
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
      },

      -- Git integration - minimal but functional
      git = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false, -- Performance optimization
        disable_for_dirs = {},
        timeout = 400,
      },

      -- Diagnostics integration - minimal but functional
      diagnostics = {
        enable = true,
        show_on_dirs = false,      -- Performance optimization
        show_on_open_dirs = false, -- Performance optimization
        debounce_delay = 50,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
      },

      -- Minimal filters
      filters = {
        git_ignored = false,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        custom = {},
        exclude = {},
      },

      -- Disable expensive features for better performance
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = false, -- Performance optimization
      },

      -- Minimal actions
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = false,
        },
        expand_all = {
          max_folder_discovery = 300,
          exclude = { ".git", "target", "build", "node_modules" },
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
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
        remove_file = {
          close_window = true,
        },
      },

      -- Performance optimizations
      notify = {
        threshold = vim.log.levels.WARN, -- Reduce notifications
        absolute_path = false,           -- Performance optimization
      },

      ui = {
        confirm = {
          remove = true,
          trash = true,
          default_yes = false,
        },
      },

      -- Disable expensive features
      tab = {
        sync = {
          open = false,  -- Disable for performance
          close = false, -- Disable for performance
        },
      },

      -- Disable logging for performance
      log = {
        enable = false,
      },
    })

    -- ============================================================================
    -- GRUVBOX-MATERIAL MINIMAL HIGHLIGHTS
    -- ============================================================================

    local function setup_highlights()
      local scheme = vim.g.colors_name or "gruvbox-material"

      -- Gruvbox-material color palette
      local colors = {
        fg = "#d4be98",
        bg = "#282828",

        -- Git colors (gruvbox-material theme)
        git_add = "#a9b665",    -- Green for new files
        git_modify = "#d8a657", -- Yellow for modified files
        git_delete = "#ea6962", -- Red for deleted files
        git_stage = "#7daea3",  -- Aqua for staged files
        git_rename = "#d3869b", -- Purple for renamed files
        git_ignore = "#928374", -- Gray for ignored files

        -- Diagnostic colors (semantic but minimal)
        diag_error = "#ea6962", -- Red for errors
        diag_warn = "#d8a657",  -- Yellow for warnings
        diag_info = "#7daea3",  -- Aqua for info
        diag_hint = "#a9b665",  -- Green for hints
      }

      -- Git file highlighting (name only, no icons)
      vim.api.nvim_set_hl(0, "NvimTreeGitFileNewHL", { fg = colors.git_add })
      vim.api.nvim_set_hl(0, "NvimTreeGitFileDirtyHL", { fg = colors.git_modify })
      vim.api.nvim_set_hl(0, "NvimTreeGitFileDeletedHL", { fg = colors.git_delete })
      vim.api.nvim_set_hl(0, "NvimTreeGitFileStagedHL", { fg = colors.git_stage })
      vim.api.nvim_set_hl(0, "NvimTreeGitFileRenamedHL", { fg = colors.git_rename })
      vim.api.nvim_set_hl(0, "NvimTreeGitFileIgnoredHL", { fg = colors.git_ignore })

      -- Diagnostic file highlighting (name only, no icons, underline for errors)
      vim.api.nvim_set_hl(0, "NvimTreeDiagnosticErrorFileHL", {
        fg = colors.diag_error,
        underline = true -- Underline for errors as requested
      })
      vim.api.nvim_set_hl(0, "NvimTreeDiagnosticWarnFileHL", { fg = colors.diag_warn })
      vim.api.nvim_set_hl(0, "NvimTreeDiagnosticInfoFileHL", { fg = colors.diag_info })
      vim.api.nvim_set_hl(0, "NvimTreeDiagnosticHintFileHL", { fg = colors.diag_hint })

      -- Ensure normal file names use default foreground
      vim.api.nvim_set_hl(0, "NvimTreeNormal", { fg = colors.fg, bg = colors.bg })
      vim.api.nvim_set_hl(0, "NvimTreeFileName", { fg = colors.fg })
      vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = colors.fg })
      vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = colors.fg })
      vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = colors.git_add, bold = true })

      -- Clean endofbuffer
      vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { fg = colors.bg, bg = colors.bg })
    end

    -- Apply highlights immediately and on colorscheme change
    setup_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        if vim.g.colors_name == "gruvbox-material" then
          vim.schedule(setup_highlights)
        end
      end,
    })

    -- ============================================================================
    -- MINIMAL KEYMAPS
    -- ============================================================================

    vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle nvim-tree" })
    vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<cr>", { desc = "Focus current file" })
    vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<cr>", { desc = "Collapse all" })
    vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<cr>", { desc = "Refresh tree" })

    -- ============================================================================
    -- PERFORMANCE OPTIMIZATIONS
    -- ============================================================================

    local nvim_tree_augroup = vim.api.nvim_create_augroup("NvimTreeOptimized", { clear = true })

    -- Optimize for large directories
    vim.api.nvim_create_autocmd("User", {
      group = nvim_tree_augroup,
      pattern = "NvimTreeSetup",
      callback = function()
        -- Additional performance settings can be added here if needed
      end,
    })

    -- Clean exit handling
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = nvim_tree_augroup,
      callback = function()
        pcall(require("nvim-tree.api").tree.close)
      end,
    })
  end,
}
