vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local cursorline_group = vim.api.nvim_create_augroup("CursorLineManagement", { clear = true })

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

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("DiagnosticColors", { clear = true }),
  callback = function()
    if vim.g.colors_name == "gruvbox-material" then
      vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#ea6962" })
      vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#d8a657" })
      vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#7daea3" })
      vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#a9b665" })

      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#ea6962", bg = "#3c2526" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#d8a657", bg = "#3c3526" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#7daea3", bg = "#263c3a" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#a9b665", bg = "#2e3c26" })
    end

    local bg = vim.g.colors_name == "gruvbox-material" and "#3c3836" or "#2a2a37"
    vim.api.nvim_set_hl(0, "CursorLine", { bg = bg })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fabd2f", bold = true })
  end,
})

vim.o.background = "dark"

vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = "●",
    source = "if_many",
    format = function(diagnostic)
      local severity_icons = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.INFO] = " ",
        [vim.diagnostic.severity.HINT] = " ",
      }
      local icon = severity_icons[diagnostic.severity] or "●"
      return string.format("%s %s", icon, diagnostic.message)
    end,
  },
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
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
    format = function(diagnostic)
      local source = diagnostic.source or "unknown"
      return string.format("[%s] %s", source, diagnostic.message)
    end,
  },
})
