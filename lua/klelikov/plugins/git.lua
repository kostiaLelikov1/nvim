return {
	{
		'tpope/vim-fugitive',
	},
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			local wk = require('which-key')
			require('gitsigns').setup()

			-- Use the standard <leader>g prefix for git operations to align with our keymap organization
			wk.add({
				-- Git operations with gitsigns
				{ '<leader>gs', "<cmd>lua require'gitsigns'.stage_hunk()<CR>", desc = 'Stage Hunk' },
				{ '<leader>gu', "<cmd>lua require'gitsigns'.undo_stage_hunk()<CR>", desc = 'Undo Stage Hunk' },
				{ '<leader>gr', "<cmd>lua require'gitsigns'.reset_hunk()<CR>", desc = 'Reset Hunk' },
				{ '<leader>gR', "<cmd>lua require'gitsigns'.reset_buffer()<CR>", desc = 'Reset Buffer' },
				{ '<leader>gp', "<cmd>lua require'gitsigns'.preview_hunk()<CR>", desc = 'Preview Hunk' },
				{ '<leader>gb', "<cmd>lua require'gitsigns'.blame_line()<CR>", desc = 'Blame Line' },
				{ '<leader>gd', "<cmd>lua require'gitsigns'.diffthis()<CR>", desc = 'Diff This' },
				
				-- Navigation
				{ ']g', "<cmd>lua require'gitsigns'.next_hunk()<CR>", desc = 'Next Git Hunk' },
				{ '[g', "<cmd>lua require'gitsigns'.prev_hunk()<CR>", desc = 'Previous Git Hunk' },
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
