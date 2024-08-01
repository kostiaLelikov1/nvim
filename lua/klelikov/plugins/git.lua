return {
	{
		'tpope/vim-fugitive',
	},
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			local wk = require('which-key')
			require('gitsigns').setup()

			wk.register({
				['G'] = {
					name = '+git',
					s = { '<cmd>lua require"gitsigns".stage_hunk()<CR>', 'Stage hunk' },
					u = { '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>', 'Undo stage hunk' },
					r = { '<cmd>lua require"gitsigns".reset_hunk()<CR>', 'Reset hunk' },
					R = { '<cmd>lua require"gitsigns".reset_buffer()<CR>', 'Reset buffer' },
					p = { '<cmd>lua require"gitsigns".preview_hunk()<CR>', 'Preview hunk' },
				},
			}, { prefix = '<leader>' })
		end,
	},
  {
    'isak102/telescope-git-file-history.nvim',
    dependancies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
  }
}
