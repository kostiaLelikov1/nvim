vim.g.mapleader = ' '

local keymap = vim.keymap

keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode with jk' })

keymap.set('n', '<leader>nh', ':nohl<CR>', { desc = 'Clear search highlights' })

keymap.set('n', '<c-k>', ':wincmd k<CR>')
keymap.set('n', '<c-j>', ':wincmd j<CR>')
keymap.set('n', '<c-h>', ':wincmd h<CR>')
keymap.set('n', '<c-l>', ':wincmd l<CR>')

keymap.set('n', '<leader>qq', ':bd<CR>', { desc = 'Close buffer' })
