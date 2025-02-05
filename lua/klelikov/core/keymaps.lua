vim.g.mapleader = ' '

local keymap = vim.keymap

keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode with jk' })

keymap.set('n', '<leader>nh', ':nohl<CR>', { desc = 'Clear search highlights' })

keymap.set('n', '<c-k>', ':wincmd k<CR>', { desc = 'Navitage to top window' })
keymap.set('n', '<c-j>', ':wincmd j<CR>', { desc = 'Navitage to bottom window' })
keymap.set('n', '<c-h>', ':wincmd h<CR>', { desc = 'Navitage to left window' })
keymap.set('n', '<c-l>', ':wincmd l<CR>', { desc = 'Navitage to right window' })
keymap.set('n', '<a-k>', ':wincmd K<CR>', { desc = 'Move window up' })
keymap.set('n', '<a-j>', ':wincmd J<CR>', { desc = 'Move window down' })
keymap.set('n', '<a-h>', ':wincmd H<CR>', { desc = 'Move window left' })
keymap.set('n', '<a-l>', ':wincmd L<CR>', { desc = 'Move window right' })
keymap.set('n', '<leader>wq', '<C-w>q', { desc = 'Close window' })

keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down half a page' })
keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up half a page' })

keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word to new' })

local function delete_hidden_buffers(options)
	local force = options and options.force or false
	local buffers = vim.api.nvim_list_bufs()
	for _, buffer in ipairs(buffers) do
		if vim.fn.buflisted(buffer) and vim.fn.bufwinnr(buffer) == -1 then
			if not force then
				vim.api.nvim_command('bwipeout ' .. buffer)
			else
				vim.api.nvim_command('bwipeout! ' .. buffer)
			end
		end
	end
end

vim.keymap.set('n', '<leader>cab', delete_hidden_buffers)
vim.keymap.set('n', '<leader>cab!', function()
	delete_hidden_buffers({ force = true })
end)
keymap.set('n', '<leader>qq', ':bd<CR>', { desc = 'Close buffer' })

keymap.set('n', '<leader>tq', ':tabclose<CR>', { desc = 'Close tab' })
keymap.set('n', '<leader>tn', ':$tabnew<CR>', { desc = 'New tab' })
keymap.set('n', '<leader>tQ', ':tabonly<CR>', { desc = 'Close all tabs except current' })

local function set_tab_keymaps()
	for i = 1, 9 do
		local key = '<A-' .. i .. '>'
		local command = i .. 'gt'
		keymap.set('n', key, command, { desc = 'Go to tab ' .. i })
	end
	keymap.set('n', '<A-0>', ':tablast<CR>', { desc = 'Go to tab last tab' })
end

set_tab_keymaps()

vim.keymap.set('n', '<A-Up>', ':resize -2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-Down>', ':resize +2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>wm', ':resize | vertical resize<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>we', ':wincmd =<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>ax', ':AvanteClear<CR>')
