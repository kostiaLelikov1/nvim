return {
	-- Fugitive
	{ 'tpope/vim-fugitive', cmd = { 'Git', 'Gvdiffsplit', 'Gdiffsplit' } },

	-- Gitsigns
	{
		'lewis6991/gitsigns.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			local wk = require('which-key')
			require('gitsigns').setup({
				signs = {
					add = { text = '▎' },
					change = { text = '▎' },
					delete = { text = '' },
					topdelete = { text = '' },
					changedelete = { text = '▎' },
					untracked = { text = '▎' },
				},
			})

			wk.add({
				{ '<leader>g', group = '+git' },
				{ '<leader>gs', "<cmd>lua require'gitsigns'.stage_hunk()<CR>", desc = 'Stage Hunk' },
				{ '<leader>gu', "<cmd>lua require'gitsigns'.undo_stage_hunk()<CR>", desc = 'Undo Stage Hunk' },
				{ '<leader>gr', "<cmd>lua require'gitsigns'.reset_hunk()<CR>", desc = 'Reset Hunk' },
				{ '<leader>gR', "<cmd>lua require'gitsigns'.reset_buffer()<CR>", desc = 'Reset Buffer' },
				{ '<leader>gp', "<cmd>lua require'gitsigns'.preview_hunk()<CR>", desc = 'Preview Hunk' },
				{ '<leader>gb', "<cmd>lua require'gitsigns'.blame_line()<CR>", desc = 'Blame Line' },
				{ '<leader>gd', "<cmd>lua require'gitsigns'.diffthis()<CR>", desc = 'Diff This' },
				{ ']g', "<cmd>lua require'gitsigns'.next_hunk()<CR>", desc = 'Next Git Hunk' },
				{ '[g', "<cmd>lua require'gitsigns'.prev_hunk()<CR>", desc = 'Previous Git Hunk' },
			}, { mode = 'n' })
		end,
	},

	-- Git File History
	{
		'isak102/telescope-git-file-history.nvim',
		dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
		config = function()
			require('telescope').load_extension('git_file_history')
		end,
		keys = {
			{ '<leader>gf', '<cmd>Telescope git_file_history<cr>', desc = 'Git file history' },
		},
	},
}
