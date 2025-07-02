return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim", 
    "ibhagwan/fzf-lua",       
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
    { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git commit" },
    { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Git pull" },
    { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Git push" },
  },
  opts = {
    graph_style = "ascii",
    integrations = {
      telescope = false,  
      diffview = true,    
      fzf_lua = true,     
    },

    signs = {
      hunk = { "", "" },
      item = { "▸", "▾" },
      section = { "▸", "▾" },
    },

    sections = {
      untracked = { folded = false },
      unstaged = { folded = false },
      staged = { folded = false },
      stashes = { folded = true },
      unpulled_upstream = { folded = true },
      unmerged_upstream = { folded = false },
      unpulled_pushRemote = { folded = true },
      unmerged_pushRemote = { folded = false },
      recent = { folded = true },
      rebase = { folded = true },
    },

    auto_refresh = true,
    auto_show_console = false,  -- Don't auto-show console
    remember_settings = false,  -- Don't remember settings for performance
    
    console_timeout = 2000,
    
    disable_context_highlighting = false,
    disable_signs = false,
  },
}
