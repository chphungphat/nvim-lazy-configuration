vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Simplified cursorline management - fewer events, better performance
local cursorline_group = vim.api.nvim_create_augroup("CursorLineManagement", { clear = true })

-- Excluded filetypes for cursorline
local excluded_filetypes = {
  "TelescopePrompt", "fzf", "oil_preview", "oil", "copilot-chat",
  "neo-tree", "neo-tree-popup", "NeogitStatus", "lazy", "mason",
  "help", "terminal", "prompt", "nofile"
}

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = cursorline_group,
  callback = function()
    local ft = vim.bo.filetype
    local bt = vim.bo.buftype

    if vim.tbl_contains(excluded_filetypes, ft) or vim.tbl_contains(excluded_filetypes, bt) then
      vim.wo.cursorline = false
    else
      vim.wo.cursorline = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = cursorline_group,
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- Single colorscheme handler - consolidate all highlight updates
vim.api.nvim_create_autocmd("ColorScheme", {
  group = cursorline_group,
  callback = function()
    -- Cursorline colors
    local bg = vim.g.colors_name == "gruvbox-material" and "#3c3836" or "#2a2a37"
    vim.api.nvim_set_hl(0, "CursorLine", { bg = bg })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fabd2f", bold = true })
  end,
})

-- Background setting
vim.o.background = "dark"
