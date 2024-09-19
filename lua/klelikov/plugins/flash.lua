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

		wk.add({
			{ '<leader>l', group = 'Flash' }, -- Define the group with the prefix '<leader>l'

			-- Individual key mappings under '<leader>l' prefix
			{
				'<leader>ls',
				function()
					flash.jump()
				end,
				desc = 'Flash Jump',
			},
			{
				'<leader>lt',
				function()
					flash.treesitter()
				end,
				desc = 'Flash Treesitter',
			},
			{
				'<leader>lr',
				function()
					flash.treesitter_search()
				end,
				desc = 'Flash Treesitter Search',
			},
		}, {
			mode = 'n', -- Set to NORMAL mode if needed
		})
	end,
}
