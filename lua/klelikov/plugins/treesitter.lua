return {
	'nvim-treesitter/nvim-treesitter',
	event = { 'BufReadPre', 'BufNewFile' },
	build = ':TSUpdate',
	dependencies = {
		'windwp/nvim-ts-autotag',
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	config = function()
		local treesitter = require('nvim-treesitter.configs')

		treesitter.setup({
			highlight = {
				enable = true,
				disable = { 'vimdoc' },
			},
			intent = { enable = true },
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
				'vimdoc',
				'dockerfile',
				'gitignore',
				'latex',
				'solidity',
				'sql',
				'yaml',
				'gleam',
				'ruby',
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<leader>vi',
					node_incremental = '<leader>vi',
					scope_incremental = false,
					node_decremental = '<leader>vd',
				},
			},
		})
	end,
}
