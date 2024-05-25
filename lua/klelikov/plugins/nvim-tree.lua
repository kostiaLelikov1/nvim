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

		wk.register({
			e = {
				name = 'explorer',
				e = {
					'<cmd>NvimTreeToggle<CR>',
					'Toggle file explorer',
				},
				f = {
					'<cmd>NvimTreeFindFileToggle<CR>',
					'Toggle file explorer on current file',
				},
				c = {
					'<cmd>NvimTreeCollapse<CR>',
					'Collapse file explorer',
				},
				r = {
					'<cmd>NvimTreeRefresh<CR>',
					'Refresh file explorer',
				},
			},
		}, { prefix = '<leader>' })
	end,
}
