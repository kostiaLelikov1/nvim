return {
	'folke/flash.nvim',
	event = 'VeryLazy',
	opts = {},
	config = function()
		local flash = require('flash')
		local wk = require('which-key')
		flash.setup({
			modes = {
				char = {
					jump_labels = true,
				},
			},
		})

		wk.register({
			l = {
				name = 'flash',
				s = {
					function()
						flash.jump()
					end,
					'Flash jump',
				},
				t = {
					function()
						flash.treesitter()
					end,
					'Flash treesitter',
				},
				r = {
					function()
						flash.treesitter_search()
					end,
					'Flash treesitter search',
				},
			},
		}, { prefix = '<leader>' })
	end,
}
