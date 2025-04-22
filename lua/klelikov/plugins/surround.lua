return {
	'echasnovski/mini.surround',
	version = '*',
	config = function()
		require('mini.surround').setup({
			-- Add custom mappings if needed
			mappings = {
				add = 'ys', -- Add surrounding in Normal and Visual modes
				delete = 'ds', -- Delete surrounding
				find = 'sf', -- Find surrounding (to the right)
				find_left = 'sF', -- Find surrounding (to the left)
				highlight = 'sh', -- Highlight surrounding
				replace = 'cs', -- Replace surrounding
				update_n_lines = 'sn', -- Update `n_lines`
			},
		})
	end,
	-- Cheatsheet for MiniSurround keymaps
	-- yss - Surround selection with a pair of characters
	-- ysw - Surround word with a pair of characters
	-- ys$ - Surround to the end of the line with a pair of characters
	-- ds - Delete surrounding pair of characters
	-- cs - Change surrounding pair of characters
	-- ys`motion`char - Surround the result of a motion with a pair of characters
	-- ds`char` - Delete surrounding pair of characters
	-- cs`oldchar`newchar - Change surrounding pair of characters from oldchar to newchar
}
