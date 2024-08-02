return {
	'norcalli/nvim-colorizer.lua',
	name = 'colorizer',
	event = 'BufRead',
	config = function()
		require('colorizer').setup()
	end,
}
