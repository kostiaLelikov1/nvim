return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.5',
	dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim' },
	config = function()
		local builtin = require('telescope.builtin')
		local telescope = require('telescope')
		local keymap = vim.keymap

		keymap.set('n', '<leader>ff', builtin.find_files, {})
		keymap.set('n', '<leader>fg', builtin.live_grep, {})
		keymap.set('n', '<leader>fb', builtin.buffers, {})
		keymap.set('n', '<leader>fh', builtin.help_tags, {})

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
	end,
}
