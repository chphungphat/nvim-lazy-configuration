return {
  "sschleemilch/slimline.nvim",
  dependencies = {
    "echasnovski/mini.icons",
    "lewis6991/gitsigns.nvim",
  },
  config = function()
    require("mini.icons").setup()

    require("slimline").setup({
      bold = true,
      style = "fg",

      components = {
        left = { "mode", "path", "git" },
        center = {},
        right = { "diagnostics", "progress" },
      },

      configs = {
        mode = {
          verbose = false,
        },
        path = {
          directory = true,
        },
        diagnostics = {
          workspace = false,
        },
        progress = {
          column = false,
        },
      },

      spaces = {
        components = " ",
        left = " ",
        right = " ",
      },

      sep = {
        hide = { first = false, last = false },
        left = "",
        right = "",
      },
    })
  end,
}
