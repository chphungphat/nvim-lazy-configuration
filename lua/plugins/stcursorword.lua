return {
  "sontungexpt/stcursorword",
  event = "VeryLazy",
  config = function()
    require("stcursorword").setup({
      excluded = {
        filetypes = {
          "TelescopePrompt",
          "oil_preview",
          "copilot-chat",
          "oil",
          "NvimTree",
          "neo-tree",
          "neo-tree-popup",
          "NeogitStatus",
        },
      },
    })
  end,
}
