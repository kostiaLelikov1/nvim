local opt = vim.opt

opt.relativenumber = true
opt.number = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.wrap = false
opt.showtabline = 2
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.termguicolors = true
opt.background = 'dark'
opt.signcolumn = 'yes'
opt.backspace = 'indent,eol,start'
opt.scrolloff = 7

opt.clipboard:append('unnamedplus')

opt.splitright = true
opt.splitbelow = true

opt.swapfile = false

vim.o.statuscolumn = '%s %-3l %-3r  '

vim.opt.spelllang = 'en_us'
vim.opt.spell = true

vim.cmd('language en_US.UTF-8')
