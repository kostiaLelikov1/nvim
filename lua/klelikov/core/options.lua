-- Neovim options configuration
local opt = vim.opt

-- UI options
opt.relativenumber = true     -- Show relative line numbers
opt.number = true             -- Show current line number
opt.cursorline = true         -- Highlight current line
opt.termguicolors = true      -- True color support
opt.background = 'dark'       -- Dark background
opt.signcolumn = 'yes'        -- Always show sign column
opt.scrolloff = 8             -- Keep 8 lines above/below cursor when scrolling
opt.sidescrolloff = 8         -- Keep 8 columns left/right of cursor when scrolling horizontally
opt.showmode = false          -- Don't show mode (shown in statusline)
opt.showtabline = 2           -- Always show tabline
opt.laststatus = 3            -- Global statusline
opt.cmdheight = 1             -- Command line height
opt.pumheight = 10            -- Pop-up menu height
opt.conceallevel = 0          -- Show text normally
opt.statuscolumn = '%s %-3l %-3r  ' -- Status column format

-- Editor behavior
opt.tabstop = 2               -- Number of spaces a tab counts for
opt.shiftwidth = 2            -- Number of spaces for indentation
opt.expandtab = true          -- Use spaces instead of tabs
opt.autoindent = true         -- Copy indent from current line when starting new line
opt.smartindent = true        -- Smart auto-indenting
opt.wrap = false              -- Don't wrap lines
opt.breakindent = true        -- Preserve indentation in wrapped text
opt.backspace = 'indent,eol,start' -- Backspace behavior

-- Search options
opt.ignorecase = true         -- Ignore case in search patterns
opt.smartcase = true          -- Override ignorecase if search contains uppercase
opt.hlsearch = true           -- Highlight search results
opt.incsearch = true          -- Incremental search

-- Split behavior
opt.splitright = true         -- Vertical splits go to the right
opt.splitbelow = true         -- Horizontal splits go below

-- File handling
opt.encoding = 'utf-8'        -- String encoding
opt.fileencoding = 'utf-8'    -- File encoding
opt.swapfile = false          -- Don't create swap files
opt.backup = false            -- Don't create backup files
opt.writebackup = false       -- Don't write backup files
opt.undofile = true           -- Persistent undo history
opt.undodir = vim.fn.stdpath('data') .. '/undodir' -- Undo directory

-- System interaction
opt.clipboard:append('unnamedplus') -- Use system clipboard
opt.mouse = 'a'               -- Enable mouse in all modes
opt.updatetime = 100          -- Faster completion and other features
opt.timeoutlen = 300          -- Time to wait for a mapped sequence to complete

-- Spelling
opt.spelllang = 'en_us'       -- Spell check language
opt.spell = true              -- Enable spell checking

-- Set language
vim.cmd('language en_US.UTF-8')

-- Disable some built-in plugins we don't need
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
