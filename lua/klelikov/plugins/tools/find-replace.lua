return {
	-- Visual Find and Replace
	{
		'klelikov/find-replace.nvim',
		dir = vim.fn.stdpath('config') .. '/lua/klelikov/find-replace',
		dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim', 'nvim-telescope/telescope.nvim' },
		config = function()
			require('klelikov.find-replace').setup()
		end,
		keys = {
			{ '<leader>rf', '<cmd>FindReplaceFile<cr>', desc = 'Find & Replace in File' },
			{ '<leader>rp', '<cmd>FindReplaceProject<cr>', desc = 'Find & Replace in Project' },
			{ '<leader>rw', '<cmd>FindReplaceWord<cr>', desc = 'Find & Replace Word Under Cursor' },
			{ '<leader>rs', '<cmd>FindReplaceSelection<cr>', mode = 'v', desc = 'Find & Replace Selection' },
		},
	},
}
