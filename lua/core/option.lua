vim.g.have_nerd_font = true
vim.o.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus"

vim.opt.completeopt = "menuone,noselect,popup"

vim.opt.mouse = ""
vim.opt.showmode = false

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "-", nbsp = "␣" }

vim.opt.inccommand = "split"

vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.opt.hlsearch = true

vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 2

vim.opt.shiftwidth = 2
vim.opt.shiftround = true

vim.opt.linebreak = true
vim.opt.wrap = false

vim.opt.swapfile = false

-- %=: Ensure the following text is on the right side of status column
-- v:virtnum < 1 ? ... : '': If first line
-- v:relnum ? v:relnum : ...: If relative number is true
-- v:lnum < 10 ? v:lnum . '  ' : v:lnum: If line number is less than 1, add 2 spaces
-- %=: Add separator to align item to the right
-- %s: The sign itself
vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s"
