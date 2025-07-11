return {
	-- Treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		event = { 'BufReadPre', 'BufNewFile' },
		build = ':TSUpdate',
		dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
		config = function()
			require('nvim-treesitter.configs').setup({
				highlight = { enable = true, disable = { 'vimdoc' } },
				indent = { enable = true },
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
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							['af'] = '@function.outer',
							['if'] = '@function.inner',
							['ac'] = '@class.outer',
							['ic'] = '@class.inner',
							['as'] = '@scope',
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							[']m'] = '@function.outer',
							[']]'] = '@class.outer',
						},
						goto_next_end = {
							[']M'] = '@function.outer',
							[']['] = '@class.outer',
						},
						goto_previous_start = {
							['[m'] = '@function.outer',
							['[['] = '@class.outer',
						},
						goto_previous_end = {
							['[M'] = '@function.outer',
							['[]'] = '@class.outer',
						},
					},
				},
			})

			vim.filetype.add({ extension = { mdx = 'mdx' } })
			vim.treesitter.language.register('markdown', 'mdx')
		end,
	},

	-- Treesitter Context
	{
		'nvim-treesitter/nvim-treesitter-context',
		dependencies = 'nvim-treesitter/nvim-treesitter',
		opts = { enable = true, max_lines = 0, min_window_height = 0, line_numbers = true },
	},

	-- Comment
	{
		'numToStr/Comment.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
		config = function()
			require('Comment').setup({
				pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
			})
		end,
	},

	-- Surround
	{ 'kylechui/nvim-surround', version = '*', event = 'VeryLazy', opts = {} },

	-- Visual Multi
	{ 'mg979/vim-visual-multi', lazy = false, branch = 'master' },

	-- Flash (better motions)
	{
		'folke/flash.nvim',
		event = 'VeryLazy',
		opts = {},
		keys = {
			{
				's',
				mode = { 'n', 'x', 'o' },
				function()
					require('flash').jump()
				end,
				desc = 'Flash',
			},
			{
				'S',
				mode = { 'n', 'x', 'o' },
				function()
					require('flash').treesitter()
				end,
				desc = 'Flash Treesitter',
			},
			{
				'r',
				mode = 'o',
				function()
					require('flash').remote()
				end,
				desc = 'Remote Flash',
			},
			{
				'R',
				mode = { 'o', 'x' },
				function()
					require('flash').treesitter_search()
				end,
				desc = 'Treesitter Search',
			},
			{
				'<c-s>',
				mode = { 'c' },
				function()
					require('flash').toggle()
				end,
				desc = 'Toggle Flash Search',
			},
		},
	},
}
