local M = {}

local modern_group = vim.api.nvim_create_augroup("ModernNeovimCompat", { clear = true })

-- ============================================================================
-- TREESITTER ASYNC HIGHLIGHTING FIXES (Neovim 0.11+)
-- ============================================================================

local function setup_treesitter_async_fixes()
  -- Force synchronous treesitter parsing to prevent window ID issues
  -- This is the most reliable fix for the neogit navigation problem
  vim.g._ts_force_sync_parsing = true

  -- Alternative: Wrap treesitter highlighter functions to validate windows
  local function safe_highlight_wrapper()
    local ok, highlighter = pcall(require, "vim.treesitter.highlighter")
    if not ok then return end

    -- Store original functions
    local original_on_line = highlighter._on_line
    local original_on_buf = highlighter._on_buf

    -- Safe wrapper for _on_line
    if original_on_line then
      highlighter._on_line = function(...)
        local args = { ... }
        -- Validate window if present in args
        for i, arg in ipairs(args) do
          if type(arg) == "number" and arg > 1000 then -- Likely a window ID
            if not vim.api.nvim_win_is_valid(arg) then
              return                                   -- Skip highlighting for invalid window
            end
          end
        end

        local success, result = pcall(original_on_line, ...)
        if not success then
          -- Log error but don't crash
          vim.schedule(function()
            vim.notify("Treesitter highlighting error (recovered): " .. tostring(result), vim.log.levels.DEBUG)
          end)
          return
        end
        return result
      end
    end

    -- Safe wrapper for _on_buf
    if original_on_buf then
      highlighter._on_buf = function(...)
        local args = { ... }
        -- Validate buffer and windows
        for i, arg in ipairs(args) do
          if type(arg) == "number" then
            if arg > 1000 and not vim.api.nvim_win_is_valid(arg) then
              return -- Skip for invalid window
            elseif arg < 1000 and arg > 0 and not vim.api.nvim_buf_is_valid(arg) then
              return -- Skip for invalid buffer
            end
          end
        end

        local success, result = pcall(original_on_buf, ...)
        if not success then
          vim.schedule(function()
            vim.notify("Treesitter buffer highlighting error (recovered): " .. tostring(result), vim.log.levels.DEBUG)
          end)
          return
        end
        return result
      end
    end
  end

  -- Apply the wrapper after treesitter loads
  vim.schedule(function()
    safe_highlight_wrapper()
  end)
end

-- ============================================================================
-- WINDOW AND UI FIXES
-- ============================================================================

local function setup_window_fixes()
  -- Enhanced nvim_open_win wrapper with better validation
  local original_nvim_open_win = vim.api.nvim_open_win
  vim.api.nvim_open_win = function(buffer, enter, config)
    -- Validate all window-related config
    if config then
      if config.win and not vim.api.nvim_win_is_valid(config.win) then
        config.win = nil
      end
      if config.relative == "win" and config.win and not vim.api.nvim_win_is_valid(config.win) then
        config.relative = "editor"
        config.win = nil
      end
    end

    -- Validate buffer
    if buffer and buffer ~= 0 and not vim.api.nvim_buf_is_valid(buffer) then
      return nil
    end

    local ok, result = pcall(original_nvim_open_win, buffer, enter, config)
    if not ok then
      vim.schedule(function()
        vim.notify("Window creation failed (recovered): " .. tostring(result), vim.log.levels.DEBUG)
      end)
      return nil
    end
    return result
  end

  -- Enhanced nvim_win_set_config wrapper
  local original_nvim_win_set_config = vim.api.nvim_win_set_config
  vim.api.nvim_win_set_config = function(window, config)
    if not vim.api.nvim_win_is_valid(window) then
      return
    end

    if config and config.win and not vim.api.nvim_win_is_valid(config.win) then
      config.win = nil
    end

    local ok, result = pcall(original_nvim_win_set_config, window, config)
    if not ok then
      vim.schedule(function()
        vim.notify("Window config failed (recovered): " .. tostring(result), vim.log.levels.DEBUG)
      end)
    end
    return result
  end

  -- Wrap nvim_buf_set_extmark to validate window references
  local original_nvim_buf_set_extmark = vim.api.nvim_buf_set_extmark
  vim.api.nvim_buf_set_extmark = function(buffer, ns_id, line, col, opts)
    -- Validate buffer
    if not vim.api.nvim_buf_is_valid(buffer) then
      return
    end

    -- Validate window references in opts
    if opts then
      if opts.win and not vim.api.nvim_win_is_valid(opts.win) then
        opts.win = nil
      end
      -- Check for window references in virt_text positioning
      if opts.virt_text_win_col and opts.win and not vim.api.nvim_win_is_valid(opts.win) then
        opts.virt_text_win_col = nil
        opts.win = nil
      end
    end

    local ok, result = pcall(original_nvim_buf_set_extmark, buffer, ns_id, line, col, opts)
    if not ok then
      -- Don't spam notifications for extmark errors
      return
    end
    return result
  end
end

-- ============================================================================
-- NEOGIT SPECIFIC FIXES
-- ============================================================================

local function setup_neogit_fixes()
  -- Better handling when navigating from neogit
  vim.api.nvim_create_autocmd("BufEnter", {
    group = modern_group,
    callback = function(event)
      local buf = event.buf
      local bufname = vim.api.nvim_buf_get_name(buf)

      -- If we're entering a file from neogit, refresh treesitter safely
      if bufname and bufname ~= "" and not bufname:match("NeogitStatus") then
        -- Check if this buffer came from neogit navigation
        local neogit_was_open = false
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_is_valid(win) then
            local win_buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_is_valid(win_buf) then
              local win_bufname = vim.api.nvim_buf_get_name(win_buf)
              if win_bufname:match("NeogitStatus") then
                neogit_was_open = true
                break
              end
            end
          end
        end

        if neogit_was_open then
          -- Schedule treesitter refresh after window management settles
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf) then
              -- Restart treesitter for this buffer
              pcall(vim.treesitter.stop, buf)
              vim.defer_fn(function()
                if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype ~= "" then
                  pcall(vim.treesitter.start, buf)
                end
              end, 50)
            end
          end)
        end
      end
    end,
  })

  -- Clean up treesitter when neogit closes
  vim.api.nvim_create_autocmd("BufHidden", {
    group = modern_group,
    pattern = "*NeogitStatus*",
    callback = function()
      -- Small delay to let window management settle
      vim.defer_fn(function()
        -- Refresh treesitter for all visible buffers
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_is_valid(win) then
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
              local ft = vim.bo[buf].filetype
              if ft and ft ~= "" then
                pcall(vim.treesitter.stop, buf)
                pcall(vim.treesitter.start, buf)
              end
            end
          end
        end
      end, 100)
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

      -- Modern semantic tokens handling with error recovery
      if client.server_capabilities.semanticTokensProvider then
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(buf) then
            pcall(vim.lsp.semantic_tokens.start, buf, client.id)
          end
        end)
      end

      -- Modern inlay hints setup (Neovim 0.10+)
      if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        pcall(vim.lsp.inlay_hint.enable, true, { bufnr = buf })
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

        -- Use synchronous treesitter for large files to prevent issues
        vim.b[buf]._ts_force_sync = true

        -- Disable treesitter for very large files
        if stats.size > 5 * 1024 * 1024 then -- 5MB
          pcall(vim.treesitter.stop, buf)
          vim.b[buf].ts_highlight = false
        end

        vim.notify(
          string.format("Large file detected (%.1fMB), some features disabled", stats.size / 1024 / 1024),
          vim.log.levels.INFO
        )
      end
    end,
  })
end

-- ============================================================================
-- ERROR RECOVERY AND HEALTH CHECKS
-- ============================================================================

local function setup_error_recovery()
  -- Enhanced error recovery with modern APIs
  vim.api.nvim_create_autocmd("User", {
    group = modern_group,
    pattern = "LazyDone",
    callback = function()
      vim.defer_fn(function()
        M.health_check()
      end, 2000)
    end,
  })

  -- Handle window resize events that might break treesitter
  vim.api.nvim_create_autocmd("VimResized", {
    group = modern_group,
    callback = function()
      vim.schedule(function()
        -- Ensure all windows are properly sized
        pcall(vim.cmd, "wincmd =")

        -- Refresh treesitter for visible buffers after resize
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_is_valid(win) then
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
              local ft = vim.bo[buf].filetype
              if ft and ft ~= "" then
                pcall(vim.treesitter.stop, buf)
                pcall(vim.treesitter.start, buf)
              end
            end
          end
        end
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

  -- Check async treesitter setting
  if not vim.g._ts_force_sync_parsing then
    table.insert(issues, "Async treesitter may cause window ID issues with neogit")
  end

  -- Report results
  if #issues > 0 then
    vim.notify(
      "Modern Neovim compatibility issues:\n" .. table.concat(issues, "\n"),
      vim.log.levels.WARN,
      { title = "Modern Neovim Health Check" }
    )
    return false
  else
    vim.notify(
      "All modern Neovim compatibility checks passed!",
      vim.log.levels.INFO,
      { title = "Modern Neovim Health Check" }
    )
    return true
  end
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

function M.setup()
  setup_treesitter_async_fixes() -- This should be first
  setup_window_fixes()
  setup_neogit_fixes()
  setup_lsp_enhancements()
  setup_performance_optimizations()
  setup_error_recovery()

  -- Add enhanced commands
  vim.api.nvim_create_user_command("ModernHealth", M.health_check, {
    desc = "Run modern Neovim health check"
  })

  vim.api.nvim_create_user_command("ModernReload", function()
    vim.api.nvim_clear_autocmds({ group = modern_group })
    M.setup()
    vim.notify("Modern Neovim features reloaded", vim.log.levels.INFO)
  end, {
    desc = "Reload modern Neovim enhancements"
  })

  vim.api.nvim_create_user_command("ModernFixTreesitter", function()
    -- Force refresh treesitter for all visible buffers
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_is_valid(win) then
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
          local ft = vim.bo[buf].filetype
          if ft and ft ~= "" then
            pcall(vim.treesitter.stop, buf)
            pcall(vim.treesitter.start, buf)
          end
        end
      end
    end
    vim.notify("Treesitter refreshed for all buffers", vim.log.levels.INFO)
  end, {
    desc = "Fix treesitter highlighting issues"
  })
end

-- Auto-setup when required
M.setup()

return M
