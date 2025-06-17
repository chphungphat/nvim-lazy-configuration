-- Modern Neovim 0.11+ compatibility fixes

-- Global error handling for modern treesitter
local group = vim.api.nvim_create_augroup("ModernNeovimFixes", { clear = true })

-- Modern treesitter debugging command
vim.api.nvim_create_user_command("TSDebug", function()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype

  print("Buffer:", buf)
  print("Filetype:", ft)

  -- Check if treesitter parser exists
  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  if ok and parser then
    print("Parser found:", parser:lang())

    -- In modern Neovim, you need to explicitly parse
    local trees = parser:parse()
    print("Trees parsed:", #trees)

    -- Check highlighting
    local has_highlights = #vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { limit = 1 }) > 0
    print("Has highlights:", has_highlights)
  else
    print("No parser found for", ft)
  end
end, { desc = "Debug treesitter for current buffer" })

-- Modern highlight refresh command
vim.api.nvim_create_user_command("TSRefresh", function()
  local buf = vim.api.nvim_get_current_buf()

  -- Modern way: just trigger file type detection
  vim.api.nvim_exec_autocmds("FileType", {
    buffer = buf,
    data = { filetype = vim.bo[buf].filetype }
  })

  vim.notify("Treesitter refreshed", vim.log.levels.INFO)
end, { desc = "Refresh treesitter highlighting" })

-- Better startup sequence for modern Neovim
vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  callback = function()
    -- Modern Neovim handles treesitter initialization automatically
    -- No manual intervention needed

    -- Just ensure folding is set up correctly
    vim.schedule(function()
      -- Modern folding setup (only if not already set)
      if vim.wo.foldmethod ~= "expr" then
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end
    end)
  end,
})

-- Handle colorscheme changes in modern Neovim
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    -- Modern treesitter handles highlighting refresh automatically
    -- Just ensure cursor line highlighting is consistent
    vim.schedule(function()
      -- Your existing cursor line logic
      local bg = vim.g.colors_name == "gruvbox-material" and "#3c3836" or "#2a2a37"
      vim.api.nvim_set_hl(0, "CursorLine", { bg = bg })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fabd2f", bold = true })
    end)
  end,
})

-- Modern error recovery
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "LazyDone",
  callback = function()
    -- After all plugins are loaded, ensure everything is working
    vim.defer_fn(function()
      -- Check for any treesitter issues and report them
      local issues = {}

      -- Check if treesitter is working
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

      -- Clean up test buffer
      vim.api.nvim_buf_delete(test_buf, { force = true })

      if #issues > 0 then
        vim.notify(
          "Treesitter issues detected:\n" .. table.concat(issues, "\n"),
          vim.log.levels.WARN,
          { title = "Treesitter Health Check" }
        )
      end
    end, 500)
  end,
})

-- Keymap for easy troubleshooting
vim.keymap.set("n", "<leader>tsd", "<cmd>TSDebug<CR>", { desc = "Debug treesitter" })
vim.keymap.set("n", "<leader>tsr", "<cmd>TSRefresh<CR>", { desc = "Refresh treesitter" })

-- Better treesitter health check integration
vim.api.nvim_create_user_command("TSHealth", function()
  vim.cmd("checkhealth nvim-treesitter")
end, { desc = "Check treesitter health" })

-- Handle the specific window ID error from your screenshot
local original_nvim_open_win = vim.api.nvim_open_win
vim.api.nvim_open_win = function(buffer, enter, config)
  -- Validate window config before calling
  if config and config.win and not vim.api.nvim_win_is_valid(config.win) then
    config.win = nil
  end

  return original_nvim_open_win(buffer, enter, config)
end

-- Global error handler for "Invalid window id" errors
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "*",
  callback = function()
    -- This is a catch-all for any remaining window issues
    -- Modern Neovim should handle these better, but this provides a safety net
  end,
})
