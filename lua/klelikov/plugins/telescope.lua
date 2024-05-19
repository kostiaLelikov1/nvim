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
		local trouble = require('trouble.providers.telescope')
		local keymap = vim.keymap

		keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
		keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind [G]rep' })
		keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
		keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp tags' })
		keymap.set('n', '<leader>fr', builtin.registers, { desc = '[F]ind [R]egisters' })
		keymap.set('n', '<leader>fc', builtin.command_history, { desc = '[F]ind [C]ommand history' })
		keymap.set('n', '<leader>fo', '<Cmd>Telescope frecency<CR>', { desc = '[F]ind [O]ld files' })
		keymap.set('n', '<leader>fm', '<Cmd>Telescope marks<CR>', { desc = '[F]ind [M]arks' })

		telescope.setup({
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = 'smart_case',
				},
			},
			defaults = {
				mappings = {
					i = {
						['<C-t>'] = trouble.open_with_trouble,
					},
					n = {
						['<C-t>'] = trouble.open_with_trouble,
					},
				},
			},
		})
		telescope.load_extension('fzf')
		telescope.load_extension('frecency')
	end,
}
