return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.5',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope-fzf-native.nvim',
		'nvim-telescope/telescope-frecency.nvim',
	},
	config = function()
		local builtin = require('telescope.builtin')
		local telescope = require('telescope')
		local wk = require('which-key')

		wk.register({
			f = {
				name = 'Find',
				f = { builtin.find_files, '[F]ind [F]iles' },
				g = { builtin.live_grep, '[F]ind [G]rep' },
				b = { builtin.buffers, '[F]ind [B]uffers' },
				h = { builtin.help_tags, '[F]ind [H]elp tags' },
				r = { builtin.registers, '[F]ind [R]egisters' },
				c = { builtin.command_history, '[F]ind [C]ommand history' },
				o = {
					'<Cmd>Telescope frecency<CR>',
					'[F]ind [O]ld files',
				},
				m = {
					'<Cmd>Telescope marks<CR>',
					'[F]ind [M]arks',
				},
				B = {
          builtin.git_branches,
					'[F]ind [B]ranches',
				},
				C = {
          builtin.git_commits,
					'[F]ind [C]ommits',
				},
			},
		}, { prefix = '<leader>' })

		telescope.setup({
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = 'smart_case',
				},
			},
		})
		telescope.load_extension('fzf')
		telescope.load_extension('frecency')
	end,
}
