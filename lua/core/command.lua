-- Fixed cursor line management for core/command.lua
-- This replaces your current cursor line autocmd

-- Remove the conflicting global setting first
vim.opt.cursorline = true -- Enable globally, then manage per-window

-- Enhanced cursor line management with better event handling
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- FIXED: Better cursor line management
local cursorline_group = vim.api.nvim_create_augroup("CursorLineManagement", { clear = true })

-- Main cursor line management
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
  group = cursorline_group,
  callback = function()
    local ft = vim.bo.filetype
    local bt = vim.bo.buftype

    -- Don't show cursor line in certain filetypes
    -- UPDATED: Changed "NvimTree" to "neo-tree" and added "neo-tree-popup"
    local excluded_filetypes = {
      "TelescopePrompt",
      "fzf",
      "oil_preview",
      "oil",
      "copilot-chat",
      "neo-tree",       -- CHANGED from "NvimTree"
      "neo-tree-popup", -- ADDED for neo-tree popups
      "NeogitStatus",
      "lazy",
      "mason",
      "help",
      "terminal",
      "prompt",
      "nofile",
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

-- Special handling for fzf and floating windows
vim.api.nvim_create_autocmd("FileType", {
  group = cursorline_group,
  pattern = { "fzf", "TelescopePrompt", "neo-tree", "neo-tree-popup" }, -- UPDATED pattern list
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- Enhanced colorscheme handling
vim.api.nvim_create_autocmd("ColorScheme", {
  group = cursorline_group,
  callback = function()
    local bg = vim.g.colors_name == "gruvbox-material" and "#3c3836" or "#2a2a37"
    vim.api.nvim_set_hl(0, "CursorLine", { bg = bg })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fabd2f", bold = true })

    -- Ensure cursor line is visible after colorscheme change
    vim.schedule(function()
      if vim.wo.cursorline then
        vim.wo.cursorline = false
        vim.wo.cursorline = true
      end
    end)
  end,
})

-- Fix for focus.nvim conflicts (if you're using it)
vim.api.nvim_create_autocmd("User", {
  group = cursorline_group,
  pattern = "FocusGained",
  callback = function()
    -- UPDATED: Changed "NvimTree" to "neo-tree"
    if vim.bo.filetype ~= "neo-tree" and vim.bo.buftype ~= "terminal" then
      vim.wo.cursorline = true
    end
  end,
})

vim.o.background = "dark"
