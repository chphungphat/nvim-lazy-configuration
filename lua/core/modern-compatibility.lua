local M = {}

local modern_group = vim.api.nvim_create_augroup("ModernNeovimCompat", { clear = true })

-- ============================================================================
-- WINDOW AND UI FIXES
-- ============================================================================

-- Handle the specific window ID error fixes
local function setup_window_fixes()
  -- Wrap nvim_open_win to handle invalid window references
  local original_nvim_open_win = vim.api.nvim_open_win
  vim.api.nvim_open_win = function(buffer, enter, config)
    -- Validate window config before calling
    if config and config.win and not vim.api.nvim_win_is_valid(config.win) then
      config.win = nil
    end

    return original_nvim_open_win(buffer, enter, config)
  end

  -- Additional window validation for floating windows
  local original_nvim_win_set_config = vim.api.nvim_win_set_config
  vim.api.nvim_win_set_config = function(window, config)
    if not vim.api.nvim_win_is_valid(window) then
      return
    end

    return original_nvim_win_set_config(window, config)
  end
end

-- ============================================================================
-- TREESITTER MODERN ENHANCEMENTS
-- ============================================================================

local function setup_treesitter_enhancements()
  -- Modern treesitter startup handling
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = modern_group,
    callback = function(event)
      local buf = event.buf

      -- Skip for empty or special buffers
      if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then
        return
      end

      -- Modern Neovim handles treesitter automatically, but we can optimize
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
          local ft = vim.bo[buf].filetype
          if ft and ft ~= "" then
            -- Ensure treesitter is working for this filetype
            local ok, parser = pcall(vim.treesitter.get_parser, buf, ft)
            if ok and parser then
              -- Parser exists, let treesitter handle highlighting
              local has_highlights = vim.treesitter.highlighter.active[buf]
              if not has_highlights then
                -- Try to start highlighting if it's not active
                pcall(vim.treesitter.start, buf, ft)
              end
            end
          end
        end
      end)
    end,
  })

  -- Handle treesitter errors gracefully
  vim.api.nvim_create_autocmd("User", {
    group = modern_group,
    pattern = "TSUpdate",
    callback = function()
      vim.schedule(function()
        -- Refresh all buffers after treesitter update
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
            local ft = vim.bo[buf].filetype
            if ft and ft ~= "" then
              pcall(vim.treesitter.stop, buf)
              pcall(vim.treesitter.start, buf, ft)
            end
          end
        end
      end)
    end,
  })
end

-- ============================================================================
-- LSP AND DIAGNOSTICS MODERN FEATURES
-- ============================================================================

local function setup_lsp_enhancements()
  -- Modern LSP attach improvements
  vim.api.nvim_create_autocmd("LspAttach", {
    group = modern_group,
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      local buf = event.buf

      if not client then
        return
      end

      -- Modern semantic tokens handling
      if client.server_capabilities.semanticTokensProvider then
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(buf) then
            -- Enable semantic tokens with modern API
            vim.lsp.semantic_tokens.start(buf, client.id)
          end
        end)
      end

      -- Modern inlay hints setup (Neovim 0.10+)
      if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
      end

      -- Modern diagnostic configuration per client
      if client.server_capabilities.diagnosticProvider then
        vim.diagnostic.config({
          virtual_text = {
            source = "if_many",
            prefix = "●",
          },
          signs = true,
          underline = true,
          update_in_insert = false,
          severity_sort = true,
        }, vim.lsp.diagnostic.get_namespace(client.id))
      end
    end,
  })

  -- Handle LSP errors gracefully
  vim.api.nvim_create_autocmd("LspDetach", {
    group = modern_group,
    callback = function(event)
      local buf = event.buf

      -- Clean up any client-specific configurations
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
          -- Modern cleanup - let Neovim handle most of this automatically
          vim.diagnostic.reset(nil, buf)
        end
      end)
    end,
  })
end

-- ============================================================================
-- FOLDING MODERN ENHANCEMENTS
-- ============================================================================

local function setup_folding_enhancements()
  -- Modern folding with treesitter
  vim.api.nvim_create_autocmd("FileType", {
    group = modern_group,
    callback = function(event)
      local buf = event.buf
      local ft = vim.bo[buf].filetype

      -- Skip for special filetypes
      local excluded_fts = {
        "help", "man", "qf", "fugitive", "git",
        "NvimTree", "neo-tree", "oil", "lazy", "mason"
      }

      if vim.tbl_contains(excluded_fts, ft) then
        return
      end

      -- Set up modern treesitter folding
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
          local has_ts_parser = pcall(vim.treesitter.get_parser, buf, ft)
          if has_ts_parser then
            -- Window-local options
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldenable = true
            vim.wo.foldlevel = 99

            -- Global options (set only once)
            if not vim.g.foldlevelstart_set then
              vim.opt.foldlevelstart = 99
              vim.g.foldlevelstart_set = true
            end
          end
        end
      end)
    end,
  })
end

-- ============================================================================
-- PERFORMANCE OPTIMIZATIONS
-- ============================================================================

local function setup_performance_optimizations()
  -- Modern Neovim performance improvements

  -- Optimize large file handling
  vim.api.nvim_create_autocmd("BufReadPre", {
    group = modern_group,
    callback = function(event)
      local buf = event.buf
      local filename = vim.api.nvim_buf_get_name(buf)

      if filename == "" then
        return
      end

      local ok, stats = pcall(vim.uv.fs_stat, filename)
      if ok and stats and stats.size > 1024 * 1024 then -- 1MB
        -- Disable expensive features for large files
        vim.bo[buf].swapfile = false
        vim.bo[buf].undofile = false
        vim.wo.foldenable = false

        -- Disable treesitter for very large files
        if stats.size > 5 * 1024 * 1024 then -- 5MB
          vim.treesitter.stop(buf)
        end

        vim.notify(
          string.format("Large file detected (%.1fMB), some features disabled", stats.size / 1024 / 1024),
          vim.log.levels.INFO
        )
      end
    end,
  })

  -- Optimize startup time
  vim.api.nvim_create_autocmd("VimEnter", {
    group = modern_group,
    callback = function()
      -- Defer expensive operations until after startup
      vim.schedule(function()
        -- Re-enable some features after startup if needed
      end)
    end,
  })
end

-- ============================================================================
-- ERROR RECOVERY AND HEALTH CHECKS
-- ============================================================================

local function setup_error_recovery()
  -- Modern error recovery system (less intrusive)
  vim.api.nvim_create_autocmd("User", {
    group = modern_group,
    pattern = "LazyDone",
    callback = function()
      -- Only run health check after a delay and when LSP is likely to be ready
      vim.defer_fn(function()
        -- Only run automatic health check if we're in a file that would have LSP
        local current_buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo[current_buf].filetype
        local lsp_filetypes = {
          "lua", "javascript", "typescript", "python", "rust", "go",
          "java", "c", "cpp", "html", "css", "json", "yaml"
        }

        if vim.tbl_contains(lsp_filetypes, ft) then
          local healthy = M.health_check()
          if healthy then
            vim.notify("All systems healthy", vim.log.levels.INFO, { title = "Health Check" })
          end
        end
      end, 3000) -- Wait 3 seconds for LSP to potentially start
    end,
  })

  -- Handle common errors gracefully
  vim.api.nvim_create_autocmd("VimResized", {
    group = modern_group,
    callback = function()
      -- Ensure all windows are properly sized after resize
      vim.schedule(function()
        vim.cmd("wincmd =")
      end)
    end,
  })
end

-- ============================================================================
-- HEALTH CHECK SYSTEM
-- ============================================================================

function M.health_check()
  local issues = {}

  -- Check treesitter health
  local test_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, { "local x = 1" })
  vim.bo[test_buf].filetype = "lua"

  local ok, parser = pcall(vim.treesitter.get_parser, test_buf)
  if not ok then
    table.insert(issues, "Treesitter parser creation failed")
  else
    local tree_ok, trees = pcall(parser.parse, parser)
    if not tree_ok or #trees == 0 then
      table.insert(issues, "Treesitter parsing failed")
    end
  end

  vim.api.nvim_buf_delete(test_buf, { force = true })

  -- Check LSP health (only if we expect LSP to be active)
  local active_clients = vim.lsp.get_clients()
  local current_buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[current_buf].filetype

  -- Only check for LSP if we're in a file that typically has LSP support
  local lsp_filetypes = {
    "lua", "javascript", "typescript", "python", "rust", "go",
    "java", "c", "cpp", "html", "css", "json", "yaml"
  }

  if vim.tbl_contains(lsp_filetypes, ft) and #active_clients == 0 then
    table.insert(issues, "No LSP clients active for " .. ft)
  end

  -- Report results (only if there are actual issues)
  if #issues > 0 then
    vim.notify(
      "Health issues detected:\n" .. table.concat(issues, "\n"),
      vim.log.levels.WARN,
      { title = "Modern Neovim Health Check" }
    )
  end

  return #issues == 0
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

function M.setup()
  setup_window_fixes()
  setup_treesitter_enhancements()
  setup_lsp_enhancements()
  setup_folding_enhancements()
  setup_performance_optimizations()
  setup_error_recovery()

  -- Add a command to manually run health check
  vim.api.nvim_create_user_command("ModernHealth", M.health_check, {
    desc = "Run modern Neovim health check"
  })

  -- Add a command to reload modern enhancements
  vim.api.nvim_create_user_command("ModernReload", function()
    -- Clear the autocommand group and reinitialize
    vim.api.nvim_clear_autocmds({ group = modern_group })
    M.setup()
    vim.notify("Modern Neovim features reloaded", vim.log.levels.INFO)
  end, {
    desc = "Reload modern Neovim enhancements"
  })
end

-- Auto-setup when required
M.setup()

return M
