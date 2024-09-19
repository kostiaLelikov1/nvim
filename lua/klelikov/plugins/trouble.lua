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
			{ '<leader>x', group = 'Trouble' }, -- Define the 'Trouble' group with the prefix '<leader>x'

			-- Individual key mappings under the '<leader>x' prefix
			{ '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
			{
				'<leader>xe',
				'<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>',
				desc = 'Diagnostics (Trouble) - Errors',
			},
			{ '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
			{ '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
			{
				'<leader>cl',
				'<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
				desc = 'LSP Definitions / References (Trouble)',
			},
			{ '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
			{ '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
		}, {
			mode = 'n', -- Apply these mappings in NORMAL mode
		})
	end,
}
