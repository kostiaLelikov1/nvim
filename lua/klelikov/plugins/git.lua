return {
	{
		'tpope/vim-fugitive',
	},
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			local wk = require('which-key')
			require('gitsigns').setup()

			wk.add({
				{ '<leader>G', group = 'Git' }, -- Define the 'Git' group with the prefix '<leader>G'

				-- Individual key mappings under the '<leader>G' prefix
				{ '<leader>Gs', "<cmd>lua require'gitsigns'.stage_hunk()<CR>", desc = 'Stage Hunk' },
				{ '<leader>Gu', "<cmd>lua require'gitsigns'.undo_stage_hunk()<CR>", desc = 'Undo Stage Hunk' },
				{ '<leader>Gr', "<cmd>lua require'gitsigns'.reset_hunk()<CR>", desc = 'Reset Hunk' },
				{ '<leader>GR', "<cmd>lua require'gitsigns'.reset_buffer()<CR>", desc = 'Reset Buffer' },
				{ '<leader>Gp', "<cmd>lua require'gitsigns'.preview_hunk()<CR>", desc = 'Preview Hunk' },
			}, {
				mode = 'n', -- Apply these mappings in NORMAL mode
			})
		end,
	},
	{
		'isak102/telescope-git-file-history.nvim',
		dependancies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
		},
	},
}
