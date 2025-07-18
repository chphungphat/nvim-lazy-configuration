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
        preserve_window_proportions = true,
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

        highlight_git = "name",
        highlight_diagnostics = "name",
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
            git = false,
            modified = false,
            diagnostics = false,
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
          "Git",
          "Diagnostics",
          "Open",
        },

        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
      },

      git = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
        disable_for_dirs = {},
        timeout = 400,
      },

      diagnostics = {
        enable = true,
        show_on_dirs = false,
        show_on_open_dirs = false,
        debounce_delay = 50,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
      },

      filters = {
        git_ignored = false,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        custom = {},
        exclude = {},
      },

      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = false,
      },

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

      notify = {
        threshold = vim.log.levels.WARN,
        absolute_path = false,
      },

      ui = {
        confirm = {
          remove = true,
          trash = true,
          default_yes = false,
        },
      },

      tab = {
        sync = {
          open = false,
          close = false,
        },
      },

      log = {
        enable = false,
      },

      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
        vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
        vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info'))
        vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
        vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
        vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
        vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
        vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
        vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
        vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
        vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
        vim.keymap.set('n', '.', api.node.run.cmd, opts('Run Command'))
        vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
        vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
        vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
        vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer'))
        vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
        vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
        vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
        vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
        vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
        vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
        vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
        vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
        vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
        vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
        vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
        vim.keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
        vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
        vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
        vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
        vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
        vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
        vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
        vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
        vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
        vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
        vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
        vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
        vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
        vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
        vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
        vim.keymap.set('n', 'S', api.tree.search_node, opts('Search'))
        vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden'))
        vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
        vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
        vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
        vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))

        vim.keymap.set('n', '<C-y>', api.fs.copy.absolute_path, opts('Copy Absolute Path to System Clipboard'))
        vim.keymap.set('n', '<leader>y', function()
          api.fs.copy.absolute_path()
          vim.notify("Absolute path copied to system clipboard", vim.log.levels.INFO)
        end, opts('Copy Absolute Path (with notification)'))

        vim.keymap.set('n', '<leader>p', function()
          local clipboard_content = require("nvim-tree.api").fs.print_clipboard()
          if clipboard_content and clipboard_content ~= "" then
            api.fs.paste()
            vim.notify("Files pasted successfully", vim.log.levels.INFO)
          else
            vim.notify("Nothing in clipboard to paste", vim.log.levels.WARN)
          end
        end, opts('Paste with confirmation'))

        vim.keymap.set('n', '<leader>cb', api.fs.print_clipboard, opts('Show Clipboard'))
        vim.keymap.set('n', '<leader>cc', api.fs.clear_clipboard, opts('Clear Clipboard'))
      end,
    })

    local function setup_highlights()
      local colors = {
        fg = "#d4be98",
        bg = "#282828",

        git_add = "#a9b665",
        git_modify = "#d8a657",
        git_delete = "#ea6962",
        git_stage = "#7daea3",
        git_rename = "#d3869b",
        git_ignore = "#928374",

        diag_error = "#ea6962",
        diag_warn = "#d8a657",
        diag_info = "#7daea3",
        diag_hint = "#a9b665",
      }

      vim.api.nvim_set_hl(0, "NvimTreeGitFileNewHL", { fg = colors.git_add })
      vim.api.nvim_set_hl(0, "NvimTreeGitFileDirtyHL", { fg = colors.git_modify })
      vim.api.nvim_set_hl(0, "NvimTreeGitFileDeletedHL", { fg = colors.git_delete })
      vim.api.nvim_set_hl(0, "NvimTreeGitFileStagedHL", { fg = colors.git_stage })
      vim.api.nvim_set_hl(0, "NvimTreeGitFileRenamedHL", { fg = colors.git_rename })
      vim.api.nvim_set_hl(0, "NvimTreeGitFileIgnoredHL", { fg = colors.git_ignore })

      vim.api.nvim_set_hl(0, "NvimTreeDiagnosticErrorFileHL", {
        fg = colors.diag_error,
        underline = true
      })
      vim.api.nvim_set_hl(0, "NvimTreeDiagnosticWarnFileHL", { fg = colors.diag_warn })
      vim.api.nvim_set_hl(0, "NvimTreeDiagnosticInfoFileHL", { fg = colors.diag_info })
      vim.api.nvim_set_hl(0, "NvimTreeDiagnosticHintFileHL", { fg = colors.diag_hint })

      vim.api.nvim_set_hl(0, "NvimTreeNormal", { fg = colors.fg, bg = colors.bg })
      vim.api.nvim_set_hl(0, "NvimTreeFileName", { fg = colors.fg })
      vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = colors.fg })
      vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = colors.fg })
      vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = colors.git_add, bold = true })

      vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { fg = colors.bg, bg = colors.bg })
    end

    setup_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        if vim.g.colors_name == "gruvbox-material" then
          vim.schedule(setup_highlights)
        end
      end,
    })

    vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle nvim-tree" })
    vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<cr>", { desc = "Focus current file" })
    vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<cr>", { desc = "Collapse all" })
    vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<cr>", { desc = "Refresh tree" })

    vim.g.nvim_tree_auto_resize = vim.g.nvim_tree_auto_resize or true
    vim.g.nvim_tree_width_mode = vim.g.nvim_tree_width_mode or "fixed"

    local function resize_tree(size)
      vim.cmd("NvimTreeResize " .. size)
    end

    local function resize_tree_relative(delta)
      vim.cmd("NvimTreeResize " .. (delta > 0 and "+" or "") .. delta)
    end

    local function calculate_optimal_width()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "NvimTree" then
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          local max_length = 0

          for _, line in ipairs(lines) do
            if line:match("%S") then
              local display_width = vim.fn.strdisplaywidth(line)
              max_length = math.max(max_length, display_width)
            end
          end

          local padding = 8
          local optimal_width = math.min(math.max(max_length + padding, 25), 100)
          return optimal_width
        end
      end
      return 30
    end

    local function auto_resize_now()
      if not vim.g.nvim_tree_auto_resize then return end

      vim.schedule(function()
        local optimal_width = calculate_optimal_width()
        resize_tree(optimal_width)
      end)
    end

    vim.keymap.set("n", "<leader>e1", function() resize_tree(20) end, { desc = "Resize tree to 20" })
    vim.keymap.set("n", "<leader>e2", function() resize_tree(30) end, { desc = "Resize tree to 30" })
    vim.keymap.set("n", "<leader>e3", function() resize_tree(40) end, { desc = "Resize tree to 40" })
    vim.keymap.set("n", "<leader>e4", function() resize_tree(50) end, { desc = "Resize tree to 50" })

    vim.keymap.set("n", "<leader>e+", function() resize_tree_relative(5) end, { desc = "Increase tree width" })
    vim.keymap.set("n", "<leader>e-", function() resize_tree_relative(-5) end, { desc = "Decrease tree width" })
    vim.keymap.set("n", "<leader>e=", function() resize_tree_relative(10) end, { desc = "Increase tree width (large)" })
    vim.keymap.set("n", "<leader>e_", function() resize_tree_relative(-10) end, { desc = "Decrease tree width (large)" })

    vim.keymap.set("n", "<leader>ea", function()
      if vim.g.nvim_tree_width_mode == "fixed" then
        require("nvim-tree").setup({
          view = {
            width = {
              min = 20,
              max = 60,
            }
          }
        })
        vim.g.nvim_tree_width_mode = "adaptive"
        vim.notify("Tree width: Adaptive (20-60)", vim.log.levels.INFO)
      else
        require("nvim-tree").setup({
          view = {
            width = 30
          }
        })
        vim.g.nvim_tree_width_mode = "fixed"
        vim.notify("Tree width: Fixed (30)", vim.log.levels.INFO)
      end
    end, { desc = "Toggle adaptive/fixed width" })

    vim.keymap.set("n", "<leader>ew", function()
      local optimal_width = calculate_optimal_width()
      resize_tree(optimal_width)
      vim.notify("Tree resized to fit content: " .. optimal_width, vim.log.levels.INFO)
    end, { desc = "Auto-resize to fit content (manual)" })

    vim.keymap.set("n", "<leader>et", function()
      vim.g.nvim_tree_auto_resize = not vim.g.nvim_tree_auto_resize
      if vim.g.nvim_tree_auto_resize then
        vim.notify("Auto-resize ON: Tree will resize when folders open", vim.log.levels.INFO)
        auto_resize_now()
      else
        vim.notify("Auto-resize OFF: Manual resizing only", vim.log.levels.INFO)
      end
    end, { desc = "Toggle auto-resize on folder open" })

    local nvim_tree_augroup = vim.api.nvim_create_augroup("NvimTreeOptimized", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      group = nvim_tree_augroup,
      pattern = "NvimTree*",
      callback = function()
        if vim.g.nvim_tree_auto_resize then
          vim.defer_fn(auto_resize_now, 100)
        end
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = nvim_tree_augroup,
      pattern = "NvimTreeRefresh",
      callback = function()
        if vim.g.nvim_tree_auto_resize then
          vim.defer_fn(auto_resize_now, 100)
        end
      end,
    })

    vim.api.nvim_create_autocmd("VimResized", {
      group = nvim_tree_augroup,
      callback = function()
        if vim.g.nvim_tree_width_mode == "adaptive" then
          vim.schedule(function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == "NvimTree" then
                local total_width = vim.o.columns
                local optimal_width = math.min(math.max(math.floor(total_width * 0.2), 20), 60)
                resize_tree(optimal_width)
                break
              end
            end
          end)
        end
      end,
    })

    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = nvim_tree_augroup,
      callback = function()
        pcall(require("nvim-tree.api").tree.close)
      end,
    })
  end,
}
