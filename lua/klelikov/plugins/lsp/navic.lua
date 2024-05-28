return {
	'SmiteshP/nvim-navic',
	dependecies = {
		'VonHeikemen/lsp-zero.nvim',
	},
	config = function()
		local navic = require('nvim-navic')
		navic.setup({
			lsp = {
				auto_attach = true,
			},
		})
	end,
}
