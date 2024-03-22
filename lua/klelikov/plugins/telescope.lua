return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.5',
	dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim' },
	config = function()
		local builtin = require('telescope.builtin')
		local telescope = require('telescope')
		local trouble = require('trouble.providers.telescope')
		local keymap = vim.keymap

		keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
		keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
		keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
		keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
    keymap.set('n', '<leader>fr', builtin.registers, { desc = 'Registers' })


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
	end,
}
