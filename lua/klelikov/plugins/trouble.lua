return {
	'folke/trouble.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		local trouble = require('trouble')
		local wk = require('which-key')

		trouble.setup({
			position = 'right',
			width = 40,
		})

		wk.add({
			{ '<leader>x', group = 'Trouble' },
			{ '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>' },
			{
				'<leader>xe',
				'<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>',
			},
			{ '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>' },
			{ '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>' },
			{
				'<leader>cl',
				'<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
			},
			{ '<leader>xL', '<cmd>Trouble loclist toggle<cr>' },
			{ '<leader>xQ', '<cmd>Trouble qflist toggle<cr>' },
		}, {
			mode = 'n',
		})
	end,
}
