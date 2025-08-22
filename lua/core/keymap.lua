vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set({ "n", "i", "v" }, "<F1>", "<nop>")
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>\\", "<C-w>v", { desc = "Split vertical" })

vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostic Error messages" })
vim.keymap.set("n", "<leader>ca", vim.diagnostic.setloclist, { desc = "Open diagnostic Quickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>hh", ":tab help<Space>", { desc = "Tab help" })


-- Keymap for easy troubleshooting
vim.keymap.set("n", "<leader>tsd", "<cmd>TSDebug<CR>", { desc = "Debug treesitter" })
vim.keymap.set("n", "<leader>tsr", "<cmd>TSRefresh<CR>", { desc = "Refresh treesitter" })
vim.keymap.set("n", "<leader>tsh", "<cmd>TSHealth<CR>", { desc = "Check treesitter health" })

-- Additional treesitter inspection keymaps
vim.keymap.set("n", "<leader>tsi", function()
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]

  local node = vim.treesitter.get_node({ bufnr = buf, pos = { row, col } })
  if node then
    local node_type = node:type()
    local start_row, start_col, end_row, end_col = node:range()

    vim.notify(string.format(
      "Node: %s\nRange: (%d,%d) to (%d,%d)",
      node_type, start_row, start_col, end_row, end_col
    ), vim.log.levels.INFO, { title = "Treesitter Node Info" })
  else
    vim.notify("No treesitter node found at cursor", vim.log.levels.WARN)
  end
end, { desc = "Inspect treesitter node at cursor" })

-- Treesitter highlighting toggle
vim.keymap.set("n", "<leader>tst", function()
  local buf = vim.api.nvim_get_current_buf()
  local enabled = vim.treesitter.highlighter.active[buf] ~= nil

  if enabled then
    vim.treesitter.stop(buf)
    vim.notify("Treesitter highlighting disabled", vim.log.levels.INFO)
  else
    vim.treesitter.start(buf)
    vim.notify("Treesitter highlighting enabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle treesitter highlighting" })

-- Show treesitter capture groups under cursor
vim.keymap.set("n", "<leader>tsc", function()
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]

  local captures = vim.treesitter.get_captures_at_pos(buf, row, col)
  if #captures > 0 then
    local capture_names = {}
    for _, capture in ipairs(captures) do
      table.insert(capture_names, capture.capture)
    end
    vim.notify(
      "Captures: " .. table.concat(capture_names, ", "),
      vim.log.levels.INFO,
      { title = "Treesitter Captures" }
    )
  else
    vim.notify("No treesitter captures at cursor", vim.log.levels.WARN)
  end
end, { desc = "Show treesitter captures at cursor" })

-- Modern treesitter playground alternative
vim.keymap.set("n", "<leader>tsp", function()
  local buf = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(buf)

  if not parser then
    vim.notify("No treesitter parser for this buffer", vim.log.levels.ERROR)
    return
  end

  local tree = parser:parse()[1]
  local root = tree:root()

  -- Create a new buffer to show the syntax tree
  local syntax_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(syntax_buf, "treesitter-syntax-tree")
  vim.bo[syntax_buf].filetype = "query"
  vim.bo[syntax_buf].modifiable = true

  -- Simple tree representation
  local function node_to_string(node, depth)
    depth = depth or 0
    local indent = string.rep("  ", depth)
    local node_text = string.format("%s(%s)", indent, node:type())

    local lines = { node_text }
    for child in node:iter_children() do
      local child_lines = node_to_string(child, depth + 1)
      for _, line in ipairs(child_lines) do
        table.insert(lines, line)
      end
    end
    return lines
  end

  local tree_lines = node_to_string(root)
  vim.api.nvim_buf_set_lines(syntax_buf, 0, -1, false, tree_lines)
  vim.bo[syntax_buf].modifiable = false

  -- Open in a split
  vim.cmd("split")
  vim.api.nvim_win_set_buf(0, syntax_buf)
  vim.api.nvim_win_set_height(0, math.min(15, #tree_lines))
end, { desc = "Show treesitter syntax tree" })


vim.keymap.set("n", "<leader>cD", function()
  vim.diagnostic.setqflist({
    severity = {
      vim.diagnostic.severity.ERROR,
      vim.diagnostic.severity.WARN
    }
  })
end, { desc = "Show all diagnostics in quickfix" })

vim.keymap.set("n", "<leader>cw", function()
  vim.diagnostic.setqflist({
    severity = vim.diagnostic.severity.WARN
  })
end, { desc = "Show warnings in quickfix" })

vim.keymap.set("n", "<leader>ce", function()
  vim.diagnostic.setqflist({
    severity = vim.diagnostic.severity.ERROR
  })
end, { desc = "Show errors in quickfix" })

-- Toggle diagnostic virtual text
vim.keymap.set("n", "<leader>cv", function()
  local current_config = vim.diagnostic.config()
  vim.diagnostic.config({
    virtual_text = not current_config.virtual_text
  })
  local status = current_config.virtual_text and "disabled" or "enabled"
  vim.notify("Diagnostic virtual text " .. status, vim.log.levels.INFO)
end, { desc = "Toggle diagnostic virtual text" })
