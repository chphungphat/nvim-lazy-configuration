-- ==============================================================================
-- MINI.NVIM NEOVIM CONFIGURATION
-- Complete replacement using mini.nvim ecosystem
-- ==============================================================================

-- ==============================================================================
-- BOOTSTRAP MINI.DEPS (Package Manager)
-- ==============================================================================

-- Clone 'mini.nvim' manually and set up 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

if not (vim.uv or vim.loop).fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps'
require('mini.deps').setup({ path = { package = path_package } })

-- Use 'mini.deps' shorthand
local add = MiniDeps.add

-- ==============================================================================
-- CORE NEOVIM OPTIONS (Updated for latest version)
-- ==============================================================================

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modern font and UI
vim.g.have_nerd_font = true
vim.o.termguicolors = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4

-- Clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Modern completion settings
vim.opt.completeopt = "menuone,noselect"

-- Mouse support
vim.opt.mouse = "a"

-- UI improvements
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.cursorline = false -- Will be managed by mini modules

-- Text handling
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.wrap = false
vim.opt.linebreak = true

-- Search improvements
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Performance and timing
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500

-- Window behavior
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 10

-- List and whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "-", nbsp = "␣" }

-- Command line
vim.opt.inccommand = "split"

-- Tab and indentation (consistent with your config)
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true

-- File handling
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Disable netrw (will use mini.files instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Status line (global)
vim.o.laststatus = 3

-- Performance
vim.o.lazyredraw = true

-- Background
vim.o.background = "dark"

-- ==============================================================================
-- COLORSCHEME SETUP
-- ==============================================================================

add({
  source = 'sainnhe/gruvbox-material',
  hooks = {
    post_checkout = function()
      -- Configure gruvbox-material
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_foreground = 'mix'
      vim.g.gruvbox_material_disable_italic_comment = 0
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_enable_bold = 1
      
      -- Load the colorscheme
      vim.cmd('colorscheme gruvbox-material')
      
      -- Custom background modifications (matching your original config)
      local function override_backgrounds()
        local bg = "#282828" -- Standard gruvbox-material hard
        local cursorline_bg = "#32302f"
        
        -- Override backgrounds
        vim.api.nvim_set_hl(0, "Normal", { bg = bg })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = bg })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bg })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = bg })
        vim.api.nvim_set_hl(0, "LineNr", { bg = bg })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = cursorline_bg })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fabd2f", bold = true })
      end
      
      -- Apply on colorscheme load
      override_backgrounds()
      
      -- Reapply on colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "gruvbox-material",
        callback = function()
          vim.defer_fn(override_backgrounds, 10)
        end,
      })
    end
  }
})

-- ==============================================================================
-- EXTERNAL DEPENDENCIES (LSP and tools)
-- ==============================================================================

-- Add LSP configurations
add({
  source = 'neovim/nvim-lspconfig',
  depends = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' }
})

-- Add Mason for LSP server management
add('williamboman/mason.nvim')
add('williamboman/mason-lspconfig.nvim')

-- Add Treesitter for syntax highlighting (mini.nvim doesn't replace this)
add({
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = {
    post_checkout = function() vim.cmd('TSUpdate') end,
  },
})

-- ==============================================================================
-- MINI.NVIM MODULES SETUP
-- ==============================================================================

-- Core editing experience
require('mini.ai').setup()          -- Enhanced text objects (a/i)
require('mini.surround').setup({    -- Surround operations (replaces nvim-surround)
  mappings = {
    add = '<leader>sa',            -- Add surround (keeping your keymap)
    delete = '<leader>sd',         -- Delete surround 
    find = '<leader>sf',           -- Find surround
    find_left = '<leader>sF',      -- Find left surround
    highlight = '<leader>sh',      -- Highlight surround
    replace = '<leader>sc',        -- Change surround (keeping your keymap)
    update_n_lines = '<leader>sn', -- Update n_lines
  },
})
require('mini.comment').setup()     -- Commenting (replaces Comment.nvim)
require('mini.pairs').setup()       -- Auto pairs (replaces nvim-autopairs)

-- Navigation and workflow
require('mini.pick').setup({        -- Fuzzy finder (replaces fzf-lua)
  window = {
    config = {
      border = 'rounded',
      height = math.floor(0.618 * vim.o.lines),
      width = math.floor(0.618 * vim.o.columns),
    },
  },
})

require('mini.extra').setup()       -- Extra utilities and pickers

require('mini.files').setup({       -- File explorer (replaces neo-tree)
  content = {
    filter = function(entry) 
      -- Show hidden files but hide .git
      return entry.name ~= '.git' 
    end,
    sort = function(entries)
      -- Sort: directories first, then files
      local dirs, files = {}, {}
      for _, entry in ipairs(entries) do
        if entry.fs_type == 'directory' then
          table.insert(dirs, entry)
        else
          table.insert(files, entry)
        end
      end
      -- Sort each group by name
      table.sort(dirs, function(a, b) return a.name < b.name end)
      table.sort(files, function(a, b) return a.name < b.name end)
      
      -- Combine
      local result = {}
      for _, entry in ipairs(dirs) do table.insert(result, entry) end
      for _, entry in ipairs(files) do table.insert(result, entry) end
      return result
    end,
  },
  windows = {
    preview = true,
    width_focus = 30,
    width_nofocus = 15,
    width_preview = 50,
  },
  options = {
    permanent_delete = true,
    use_as_default_explorer = true,
  },
})

-- Completion and snippets  
require('mini.completion').setup({  -- Completion (replaces blink.cmp)
  delay = { completion = 100, info = 100, signature = 50 },
  window = {
    info = { height = 25, width = 80, border = 'rounded' },
    signature = { height = 25, width = 80, border = 'rounded' },
  },
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = true,
    process_items = function(items, base)
      return vim.tbl_filter(function(item)
        return vim.startswith(item.word or '', base)
      end, items)
    end,
  },
  fallback_action = '<C-n>',
  mappings = {
    force_twostep = '<C-Space>',
    force_fallback = '<A-Space>',
  },
})

require('mini.snippets').setup()    -- Snippets support

-- Appearance and UI
require('mini.icons').setup()       -- Icons (replaces nvim-web-devicons)

require('mini.statusline').setup({  -- Statusline (replaces slimline)
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git = MiniStatusline.section_git({ trunc_width = 40 })
      local diff = MiniStatusline.section_diff({ trunc_width = 75 })
      local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      local location = MiniStatusline.section_location({ trunc_width = 75 })
      local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

      return MiniStatusline.combine_groups({
        { hl = mode_hl,                 strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl,                 strings = { search, location } },
      })
    end,
    inactive = function()
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      return MiniStatusline.combine_groups({
        { hl = 'MiniStatuslineInactive', strings = { filename } },
      })
    end,
  },
  use_icons = true,
  set_vim_settings = false,
})

require('mini.indentscope').setup({ -- Indentation guides (replaces hlchunk)
  symbol = "│",
  options = { try_as_border = true },
  draw = {
    delay = 50,
    animation = function() return 0 end, -- Disable animation for performance
  },
})

require('mini.cursorword').setup()  -- Highlight word under cursor (replaces stcursorword)

-- Git integration
require('mini.git').setup()         -- Git integration (part of git workflow)
require('mini.diff').setup({        -- Git diff signs (replaces gitsigns)
  view = {
    style = 'sign',
    signs = { add = '▎', change = '▎', delete = '' },
    priority = 199,
  },
  source = nil, -- Use default Git source
  delay = { text_change = 200 },
  mappings = {
    apply = 'gh',
    reset = 'gr',
    textobject = 'gh',
    goto_first = '[H',
    goto_prev = '[h',
    goto_next = ']h',
    goto_last = ']H',
  },
})

-- Navigation helpers
require('mini.bracketed').setup()   -- Navigation with bracket mappings (enhanced unimpaired)
require('mini.jump').setup()        -- Enhanced f/F/t/T motions
require('mini.jump2d').setup()      -- Two-character search for quick navigation

-- Additional useful modules
-- Setup mini.clue (simplified to avoid loading issues)
require('mini.clue').setup({
  triggers = {
    -- Leader key mappings
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },
    
    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },
    
    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },
    
    -- Window commands
    { mode = 'n', keys = '<C-w>' },
    
    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  },
  
  clues = {
    -- Custom clues for your leader mappings
    { mode = 'n', keys = '<Leader>c', desc = '+Code' },
    { mode = 'n', keys = '<Leader>f', desc = '+Find/Format' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<Leader>s', desc = '+Search/Surround' },
    { mode = 'n', keys = '<Leader>e', desc = '+Explorer' },
    { mode = 'n', keys = '<Leader>h', desc = '+Help' },
    { mode = 'n', keys = '<Leader>t', desc = '+Toggle/Treesitter' },
    { mode = 'n', keys = '<Leader>x', desc = '+Execute/Trouble' },
    
    -- Basic window commands
    { mode = 'n', keys = '<C-w>s', desc = 'Split below' },
    { mode = 'n', keys = '<C-w>v', desc = 'Split right' },
    { mode = 'n', keys = '<C-w>c', desc = 'Close window' },
    { mode = 'n', keys = '<C-w>o', desc = 'Close other windows' },
    
    -- Basic g commands
    { mode = 'n', keys = 'gg', desc = 'Go to first line' },
    { mode = 'n', keys = 'gf', desc = 'Go to file under cursor' },
    { mode = 'n', keys = 'gd', desc = 'Go to definition' },
    { mode = 'n', keys = 'gr', desc = 'Go to references' },
  },
  
  window = {
    delay = 500,
    config = {
      width = 'auto',
      border = 'rounded',
    },
  },
})

require('mini.trailspace').setup()  -- Highlight and remove trailing spaces
require('mini.move').setup()        -- Move lines and selections

-- ==============================================================================
-- TREESITTER CONFIGURATION
-- ==============================================================================

MiniDeps.now(function()
  local configs = require("nvim-treesitter.configs")
  
  configs.setup({
    ensure_installed = {
      "javascript", "typescript", "tsx", "bash", "c",
      "diff", "html", "lua", "luadoc", "markdown", 
      "vim", "vimdoc", "query", "python", "rust", "go"
    },
    auto_install = true,
    sync_install = false,
    
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    
    indent = {
      enable = true,
      disable = { "python", "yaml" },
    },
    
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<BS>",
      },
    },
  })
  
  -- Modern folding setup
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.opt.foldcolumn = "0"
  vim.opt.foldtext = ""
  vim.opt.foldlevel = 99
  vim.opt.foldlevelstart = 99
  vim.opt.foldenable = true
end)

-- ==============================================================================
-- LSP CONFIGURATION (Simplified for Neovim 0.11+)
-- ==============================================================================

MiniDeps.now(function()
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")
  
  -- Setup Mason
  mason.setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜", 
        package_uninstalled = "✗"
      }
    }
  })
  
  -- Setup Mason LSP Config
  mason_lspconfig.setup({
    ensure_installed = {
      "ts_ls",      -- TypeScript
      "lua_ls",     -- Lua
      "bashls",     -- Bash  
      "vimls",      -- Vim
      "marksman",   -- Markdown
      "jsonls",     -- JSON
      "yamlls",     -- YAML
      "html",       -- HTML
      "cssls",      -- CSS
      "pyright",    -- Python
    },
    automatic_installation = true,
  })
  
  -- Modern diagnostic configuration (no deprecated options)
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "",
      },
    },
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    severity_sort = true,
    float = {
      border = "rounded",
      source = "if_many",
      header = "",
      prefix = "",
    },
  })
  
  -- LSP Attach autocommand with your exact keymaps
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      local opts = { buffer = ev.buf, silent = true }
      
      -- Your original keymaps preserved
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, 
        vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
      
      -- Use MiniPick for LSP navigation (with fallback)
      vim.keymap.set("n", "gr", function() 
        if MiniPick and MiniPick.builtin then
          MiniPick.builtin.lsp({ scope = 'references' })
        else
          vim.lsp.buf.references()
        end
      end, vim.tbl_extend("force", opts, { desc = "Show LSP references" }))
      
      vim.keymap.set("n", "gd", function() 
        if MiniPick and MiniPick.builtin then
          MiniPick.builtin.lsp({ scope = 'definition' })
        else
          vim.lsp.buf.definition()
        end
      end, vim.tbl_extend("force", opts, { desc = "Show LSP definitions" }))
      
      vim.keymap.set("n", "gi", function() 
        if MiniPick and MiniPick.builtin then
          MiniPick.builtin.lsp({ scope = 'implementation' })
        else
          vim.lsp.buf.implementation()
        end
      end, vim.tbl_extend("force", opts, { desc = "Show LSP implementations" }))
      
      vim.keymap.set("n", "gt", function() 
        if MiniPick and MiniPick.builtin then
          MiniPick.builtin.lsp({ scope = 'type_definition' })
        else
          vim.lsp.buf.type_definition()
        end
      end, vim.tbl_extend("force", opts, { desc = "Show LSP type definitions" }))
      
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, 
        vim.tbl_extend("force", opts, { desc = "See available code actions" }))
      
      vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, 
        vim.tbl_extend("force", opts, { desc = "Smart rename" }))
      
      vim.keymap.set("n", "<leader>D", function() 
        if MiniPick and MiniPick.builtin then
          MiniPick.builtin.diagnostic({ scope = 'current' })
        else
          vim.diagnostic.setloclist()
        end
      end, vim.tbl_extend("force", opts, { desc = "Show buffer diagnostics" }))
      
      -- Navigation with modern vim.diagnostic.jump (no deprecated functions)
      vim.keymap.set("n", "[e", function()
        vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
      end, vim.tbl_extend("force", opts, { desc = "Go to previous error" }))
      
      vim.keymap.set("n", "]e", function()
        vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
      end, vim.tbl_extend("force", opts, { desc = "Go to next error" }))
      
      vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ 
          count = -1, 
          severity = { min = vim.diagnostic.severity.HINT, max = vim.diagnostic.severity.WARN },
          float = true 
        })
      end, vim.tbl_extend("force", opts, { desc = "Go to previous warning/hint" }))
      
      vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ 
          count = 1, 
          severity = { min = vim.diagnostic.severity.HINT, max = vim.diagnostic.severity.WARN },
          float = true 
        })
      end, vim.tbl_extend("force", opts, { desc = "Go to next warning/hint" }))
      
      vim.keymap.set("n", "K", vim.lsp.buf.hover, 
        vim.tbl_extend("force", opts, { desc = "Show documentation for what is under cursor" }))
      
      vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", 
        vim.tbl_extend("force", opts, { desc = "Restart LSP" }))
      
      -- TypeScript organize imports (preserved from your config)
      vim.keymap.set("n", "<leader>oi", function()
        if vim.tbl_contains({"typescript", "typescriptreact", "javascript", "javascriptreact"}, vim.bo.filetype) then
          local params = {
            command = "_typescript.organizeImports",
            arguments = { vim.api.nvim_buf_get_name(0) },
            title = "",
          }
          vim.lsp.buf_request_sync(0, "workspace/executeCommand", params, 1000)
        end
      end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
    end,
  })
  
  -- Setup individual LSP servers (simplified)
  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME }
          },
        },
      },
    },
    ts_ls = {},
    bashls = {},
    vimls = {},
    marksman = {},
    jsonls = {},
    yamlls = {},
    html = {},
    cssls = {},
    pyright = {},
  }
  
  for server, config in pairs(servers) do
    require('lspconfig')[server].setup(config)
  end
end)

-- ==============================================================================
-- KEY MAPPINGS (Preserving your original mappings)
-- ==============================================================================

-- Window navigation (preserved)
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Window splits (preserved)
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>\\", "<C-w>v", { desc = "Split vertical" })

-- Clear search highlight
vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<CR>")

-- Diagnostics (preserved)
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostic Error messages" })
vim.keymap.set("n", "<leader>ca", vim.diagnostic.setloclist, { desc = "Open diagnostic Quickfix list" })

-- Terminal (preserved)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Help (preserved)
vim.keymap.set("n", "<leader>hh", ":tab help<Space>", { desc = "Tab help" })

-- ==============================================================================
-- MINI.PICK KEYMAPS (Replacing fzf-lua mappings)  
-- ==============================================================================

-- Set up pick keymaps after modules are loaded
MiniDeps.now(function()
  vim.keymap.set("n", "<leader>sk", function() MiniPick.builtin.help() end, { desc = "Search Keymaps" })
  vim.keymap.set("n", "<leader><leader>", function() MiniPick.builtin.files() end, { desc = "Search Files" })
  vim.keymap.set("n", "<leader>/", function() MiniPick.builtin.grep_live() end, { desc = "Search by Grep" })
  vim.keymap.set("n", "<leader>sd", function() MiniPick.builtin.diagnostic() end, { desc = "Search Diagnostics" })
  vim.keymap.set("n", "<leader>sb", function() MiniPick.builtin.buffers() end, { desc = "Search Buffers" })
  vim.keymap.set("n", "<leader>sh", function() MiniPick.builtin.help() end, { desc = "Search Help Tags" })
  vim.keymap.set("n", "<leader>sm", function() MiniExtra.pickers.marks() end, { desc = "Search Marks" })
  vim.keymap.set("n", "<leader>so", function() MiniExtra.pickers.oldfiles() end, { desc = "Search Old Files" })

  -- Additional useful pickers
  vim.keymap.set("n", "<leader>sc", function() MiniExtra.pickers.commands() end, { desc = "Search Commands" })
  vim.keymap.set("n", "<leader>sH", function() MiniExtra.pickers.hl_groups() end, { desc = "Search Highlight Groups" })
  vim.keymap.set("n", "<leader>sr", function() MiniPick.builtin.resume() end, { desc = "Resume picker" })
end)

-- ==============================================================================
-- MINI.FILES KEYMAPS (Replacing neo-tree mappings)
-- ==============================================================================

-- Set up files keymaps after modules are loaded
MiniDeps.now(function()
  vim.keymap.set("n", "<leader>ee", function() 
    MiniFiles.open(vim.api.nvim_buf_get_name(0)) 
  end, { desc = "Toggle file explorer" })

  vim.keymap.set("n", "<leader>ef", function() 
    MiniFiles.open(vim.api.nvim_buf_get_name(0)) 
  end, { desc = "Focus on current file" })

  vim.keymap.set("n", "<leader>er", function() 
    MiniFiles.open(vim.fn.getcwd()) 
  end, { desc = "Open explorer at root" })

  vim.keymap.set("n", "<leader>ec", function() 
    MiniFiles.close() 
  end, { desc = "Close file explorer" })
end)

-- ==============================================================================
-- MINI.DIFF KEYMAPS (Replacing gitsigns mappings)
-- ==============================================================================

-- Set up git keymaps after modules are loaded
MiniDeps.now(function()
  -- Git actions using mini.diff and mini.git
  vim.keymap.set("n", "gsb", function()
    -- Toggle blame line (using mini.git)
    vim.cmd('lua MiniGit.show_at_cursor()')
  end, { desc = "Show git blame at cursor" })

  vim.keymap.set("n", "gsr", function()
    -- Reset hunk under cursor
    MiniDiff.operator('reset')()
  end, { desc = "Reset hunk" })

  vim.keymap.set("n", "gss", function()
    -- Stage hunk (this would need git command)
    local line = vim.fn.line('.')
    vim.cmd('!' .. 'git add -N ' .. vim.fn.expand('%') .. ' && git add --patch ' .. vim.fn.expand('%'))
  end, { desc = "Stage hunk" })
end)

-- ==============================================================================
-- FORMATTING (Using LSP built-in formatting)
-- ==============================================================================

-- Basic formatting keymap using LSP
vim.keymap.set({ "n", "v" }, "<leader>ff", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format file or range" })

vim.keymap.set("n", "<leader>F", function()
  vim.lsp.buf.format({ async = true })
  vim.cmd("write")
end, { desc = "Format and save" })

-- ==============================================================================
-- AUTOCOMMANDS AND FINAL SETUP
-- ==============================================================================

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Modern cursor line management (fixed for latest Neovim)
local cursorline_group = vim.api.nvim_create_augroup("CursorLineManagement", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
  group = cursorline_group,
  callback = function()
    local ft = vim.bo.filetype
    local bt = vim.bo.buftype
    
    local excluded_filetypes = {
      "TelescopePrompt", "fzf", "oil_preview", "oil", "copilot-chat",
      "minifiles", "minipick", "help", "terminal", "prompt", "nofile",
    }
    
    if vim.tbl_contains(excluded_filetypes, ft) or vim.tbl_contains(excluded_filetypes, bt) then
      vim.wo.cursorline = false
    else
      vim.wo.cursorline = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
  group = cursorline_group,
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- Setup enhanced Tab completion after mini.completion loads
MiniDeps.now(function()
  -- Enhanced Tab completion for mini.completion
  vim.keymap.set('i', '<Tab>', function()
    if vim.fn.pumvisible() ~= 0 then
      return '<C-n>'
    else
      return '<Tab>'
    end
  end, { expr = true, desc = "Next completion or tab" })
  
  vim.keymap.set('i', '<S-Tab>', function()
    if vim.fn.pumvisible() ~= 0 then
      return '<C-p>'
    else
      return '<S-Tab>'
    end
  end, { expr = true, desc = "Previous completion or shift-tab" })
end)

-- Success message
vim.defer_fn(function()
  vim.notify("🎉 Mini.nvim configuration loaded successfully!", vim.log.levels.INFO)
end, 500)
