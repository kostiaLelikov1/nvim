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

		wk.register({
			name = 'Trouble',
			xx = {
				'<cmd>Trouble diagnostics toggle<cr>',
				'Diagnostics (Trouble)',
			},
			xe = {
				'<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>',
				'Diagnostics (Trouble) - Errors',
			},
			xX = {
				'<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
				'Buffer Diagnostics (Trouble)',
			},
			cs = {
				'<cmd>Trouble symbols toggle focus=false<cr>',
				'Symbols (Trouble)',
			},
			cl = {
				'<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
				'LSP Definitions / references / ... (Trouble)',
			},
			xL = {
				'<cmd>Trouble loclist toggle<cr>',
				'Location List (Trouble)',
			},
			xQ = {
				'<cmd>Trouble qflist toggle<cr>',
				'Quickfix List (Trouble)',
			},
		}, { prefix = '<leader>' })
	end,
}
