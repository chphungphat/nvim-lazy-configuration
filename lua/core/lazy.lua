local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins/coding" },
    { import = "plugins/colorschemes" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    missing = true,
  },
  checker = {
    enabled = true,
    notify = true,
    frequency = 10800,
  },
  change_detection = {
    enabled = true,
    notify = true,
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
  },
})

vim.keymap.set("n", "<leader>ll", "<cmd>Lazy<CR>", { noremap = true, silent = true })
