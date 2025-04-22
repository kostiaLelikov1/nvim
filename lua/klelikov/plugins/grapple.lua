return {
	{
		'cbochs/grapple.nvim',
		opts = {
			scope = 'static',
		},
		event = { 'BufReadPost', 'BufNewFile' },
		cmd = 'Grapple',
		keys = {
			{ '<leader>M', '<cmd>Grapple toggle<cr>', desc = 'Grapple toggle tag' },
			{ '<leader>mn', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle next tag' },
			{ '<leader>mp', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle previous tag' },
			{ '<leader>mc', '<cmd>Grapple reset<cr>', desc = 'Grapple reset tags' },
			{ '<leader>mq', '<cmd>Grapple quickfix<cr>', desc = 'Grapple quickfix' },
			{ '<a-a>', '<cmd>Grapple select index=1<cr>', desc = 'Grapple goto 0' },
			{ '<a-s>', '<cmd>Grapple select index=2<cr>', desc = 'Grapple goto 2' },
			{ '<a-d>', '<cmd>Grapple select index=3<cr>', desc = 'Grapple goto 3' },
			{ '<a-f>', '<cmd>Grapple select index=4<cr>', desc = 'Grapple goto 4' },
		},
		config = function()
			require('grapple').setup({
				scope = 'static',
				save_path = vim.fn.stdpath('data') .. '/grapple',
				icon = '󰛢',
				scope_configs = {
					static = {
						scope_name = 'static',
						resolver = 'git',
						fallback = 'cwd',
					},
				},
			})
		end,
	},
	{
		'will-lynas/grapple-line.nvim',
		dependencies = {
			'cbochs/grapple.nvim',
		},
		opts = {
			number_of_files = 4,
		},
	},
}
