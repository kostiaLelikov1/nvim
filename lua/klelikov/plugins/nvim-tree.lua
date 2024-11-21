return {
	'nvim-tree/nvim-tree.lua',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		local nvimtree = require('nvim-tree')
		local wk = require('which-key')

		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			view = {
				width = 35,
				relativenumber = true,
			},
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { '.DS_Store', '.idea', '.vscode', 'node_modules' },
			},
			git = {
				ignore = false,
			},
			renderer = {
				indent_markers = {
					enable = true,
				},
			},
		})

		wk.add({
			{ '<leader>e', group = 'Explorer' }, -- Define the 'Explorer' group with the prefix '<leader>e'

			-- Individual key mappings under the '<leader>e' prefix
			{ '<leader>ee', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle File Explorer' },
			{ '<leader>ef', '<cmd>NvimTreeFindFileToggle<CR>', desc = 'Toggle File Explorer on Current File' },
			{ '<leader>ec', '<cmd>NvimTreeCollapse<CR>', desc = 'Collapse File Explorer' },
			{ '<leader>er', '<cmd>NvimTreeRefresh<CR>', desc = 'Refresh File Explorer' },
			{ '<leader>eo', '<cmd>NvimTreeFocus<CR>', desc = 'Focus File Explorer' },
		}, {
			mode = 'n', -- Apply these mappings in NORMAL mode
		})
	end,
}
