return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.5',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope-fzf-native.nvim',
	},
	config = function()
		local builtin = require('telescope.builtin')
		local telescope = require('telescope')
		local wk = require('which-key')

		wk.add({
			{ '<leader>f', group = 'Find' }, -- Define the 'Find' group with the prefix '<leader>f'

			-- Individual key mappings under the '<leader>f' prefix
			{ '<leader>ff', builtin.find_files, desc = 'Find Files' },
			{ '<leader>fg', builtin.live_grep, desc = 'Find Grep' },
			{ '<leader>fb', builtin.buffers, desc = 'Find Buffers' },
			{ '<leader>fh', builtin.help_tags, desc = 'Find Help Tags' },
			{ '<leader>fr', builtin.registers, desc = 'Find Registers' },
			{ '<leader>fc', builtin.command_history, desc = 'Find Command History' },
			{ '<leader>fm', ':Telescope grapple tags<cr>', desc = 'Find Marks' },
			{ '<leader>fn', ':Telescope neoclip<CR>', desc = 'Find Neoclip' },
			{ '<leader>fB', builtin.git_branches, desc = 'Find Branches' },
			{ '<leader>fC', builtin.git_commits, desc = 'Find Commits' },
			{ '<leader>fH', ':Telescope git_file_history<cr>', desc = 'Find History' },
		}, {
			mode = 'n', -- Apply these mappings in NORMAL mode
		})

		telescope.setup({
			defaults = {
				layout_strategy = 'vertical',
				mappings = {
					i = {
						['<C-u>'] = require('telescope.actions').preview_scrolling_up,
						['<C-d>'] = require('telescope.actions').preview_scrolling_down,
					},
					n = {
						['<C-u>'] = require('telescope.actions').preview_scrolling_up,
						['<C-d>'] = require('telescope.actions').preview_scrolling_down,
					},
				},
			},
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
		telescope.load_extension('grapple')
		telescope.load_extension('git_file_history')
	end,
}
