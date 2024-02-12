return {
	'nvim-treesitter/nvim-treesitter',
	event = { 'BufReadPre', 'BufNewFile' },
	build = ':TSUpdate',
	dependencies = {
		'windwp/nvim-ts-autotag',
	},
	config = function()
		local treesitter = require('nvim-treesitter.configs')

		treesitter.setup({
			highlight = {
				enable = true,
			},
			intent = { enable = true },
			autotag = { enable = true },
			ensure_installed = {
				'json',
				'javascript',
				'typescript',
				'tsx',
				'html',
				'css',
				'scss',
				'prisma',
				'astro',
				'bash',
				'markdown',
				'markdown_inline',
				'lua',
				'vim',
				'dockerfile',
				'gitignore',
				'latex',
				'solidity',
				'sql',
				'yaml',
			},
		})
	end,
}
