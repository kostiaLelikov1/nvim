local opt = vim.opt
local g = vim.g

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = 'yes'
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.background = 'dark'
opt.showmode = false
opt.laststatus = 3
opt.cmdheight = 1
opt.pumheight = 10
opt.conceallevel = 0

-- Editor
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.wrap = false
opt.breakindent = true
opt.backspace = 'indent,eol,start'

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Files
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath('data') .. '/undodir'

-- System
opt.clipboard:append('unnamedplus')
opt.hidden = true
opt.autowriteall = true
opt.confirm = true
opt.autoread = true
opt.exrc = true
opt.secure = true
opt.mouse = 'a'
opt.updatetime = 100
opt.timeoutlen = 300

-- Spelling
opt.spelllang = 'en_us'
opt.spell = true

-- Performance
g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1

-- Language
vim.cmd('language en_US.UTF-8')
