vim.g.have_nerd_font = true
vim.o.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus"

vim.opt.completeopt = "menuone,noselect,popup"

vim.opt.mouse = "a"
vim.opt.showmode = false

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "auto"

vim.opt.numberwidth = 4

vim.opt.updatetime = 300
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
vim.opt.backup = false
vim.opt.writebackup = false

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.laststatus = 3

vim.o.lazyredraw = true

vim.o.winborder = "rounded"

vim.opt.wildmenu = true
vim.opt.wildmode = "longest,list"
vim.opt.wildoptions = "pum"
vim.opt.wildignorecase = true

vim.opt.wildignore = {
  "*.o", "*.obj", "*.bin", "*.dll", "*.exe",
  "*/.git/*", "*/.svn/*", "*/.hg/*",
  "*/node_modules/*", "*/vendor/*",
  "*.pyc", "*.pyo", "*.pyd", "__pycache__",
  "*.class", "*.jar",
  "*.min.*", "bundle*.js",
  "*.swp", "*.tmp", "*~"
}

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.pumheight = 15

vim.opt.ttyfast = true

vim.opt.regexpengine = 0
