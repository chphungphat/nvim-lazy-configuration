return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      indent = {
        enable = true,
        chars = { "│" },
        exclude_filetypes = {
          "help",
          "terminal",
          "lazy",
          "mason",
          "NvimTree",
          "neo-tree",
          "TelescopePrompt",
          "oil",
          "notify",
        },
      },

      chunk = {
        enable = true,
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "┌",
          left_bottom = "└",
          right_arrow = "─",
        },
        duration = 200,
        delay = 300,
      },
    })
  end,
}
