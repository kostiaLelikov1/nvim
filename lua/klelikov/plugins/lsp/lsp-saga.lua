return {
	'nvimdev/lspsaga.nvim',
	config = function()
		local wk = require('which-key')
		require('lspsaga').setup({
			symbol_in_winbar = {
				enable = false,
			},
			lightbulb = {
				enable = false,
			},
			code_action = {
				show_server_name = true,
			},
		})

		wk.register({
			['s'] = {
				name = '+lspsaga',
				['ca'] = { '<cmd>Lspsaga code_action<CR>', 'Code Action' },
				['d'] = { '<cmd>Lspsaga peek_definition<CR>', 'Peek Definition' },
				['o'] = { '<cmd>Lspsaga peek_type_definition<CR>', 'Peek Type Definition' },
				['f'] = { '<cmd>Lspsaga finder<CR>', 'LSP Finder' },
				['t'] = { '<cmd>Lspsaga term_toggle<CR>', 'Open Float Terminal' },
				['l'] = { '<cmd>Lspsaga outline<CR>', 'LSP Outline' },
        ['rr'] = { '<cmd>Lspsaga rename<CR>', 'Rename' },
			},
		}, { prefix = 'g' })
	end,
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'nvim-tree/nvim-web-devicons',
		'VonHeikemen/lsp-zero.nvim',
	},
}
