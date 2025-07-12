return {
	-- Which Key
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			plugins = { spelling = true },
		},
		config = function(_, opts)
			local wk = require('which-key')
			wk.setup(opts)

			-- Add group mappings
			wk.add({
				{ '<leader>f', group = 'file/find' },
				{ '<leader>s', group = 'search' },
				{ '<leader>e', group = 'explorer' },
				{ '<leader>v', group = 'visual' },
				{ '<leader>m', group = 'marks/format' },
				{ '<leader>g', group = 'git' },
				{ '<leader>x', group = 'trouble' },
				{ '<leader>c', group = 'copilot' },
				{ '<leader>r', group = 'replace' },
				{ '<leader>b', group = 'buffer' },
				{ '<leader>t', group = 'tab' },
				{ '<leader>w', group = 'window' },
				{ '<leader>q', group = 'quit' },
				{ '<leader>T', group = 'terminal' },
				{ '<leader>l', group = 'lsp' },
				{ '<leader>cc', group = 'copilot chat' },
				{ '<leader>sn', group = 'noice' },
				{ '<leader>a', group = 'claude ai' },
				{ '<leader>r', group = 'find & replace' },
				{ 'g', group = 'goto' },
				{ 'gs', group = 'lspsaga/surround' },
				{ 'z', group = 'fold' },
				{ ']', group = 'next' },
				{ '[', group = 'prev' },
			})
		end,
	},

	-- Copilot
	{
		'zbirenbaum/copilot.lua',
		cmd = 'Copilot',
		event = 'InsertEnter',
		config = function()
			require('copilot').setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
				filetypes = {
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					['.'] = false,
				},
			})
		end,
	},

	-- Trouble
	{
		'folke/trouble.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/todo-comments.nvim' },
		opts = { focus = true },
		cmd = 'Trouble',
		keys = {
			{ '<leader>xw', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Open trouble workspace diagnostics' },
			{ '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Open trouble document diagnostics' },
			{ '<leader>xq', '<cmd>Trouble quickfix toggle<CR>', desc = 'Open trouble quickfix list' },
			{ '<leader>xl', '<cmd>Trouble loclist toggle<CR>', desc = 'Open trouble location list' },
			{ '<leader>xt', '<cmd>Trouble todo toggle<CR>', desc = 'Open todos in trouble' },
		},
	},

	-- Todo Comments
	{
		'folke/todo-comments.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = 'nvim-lua/plenary.nvim',
		opts = {},
	},

	-- Neoclip (clipboard manager)
	{
		'AckslD/nvim-neoclip.lua',
		dependencies = { 'nvim-telescope/telescope.nvim' },
		config = function()
			require('neoclip').setup()
			require('telescope').load_extension('neoclip')
			vim.keymap.set('n', '<leader>fp', '<cmd>Telescope neoclip<cr>', { desc = 'Find in clipboard history' })
		end,
	},

	-- Markdown Preview
	{
		'iamcco/markdown-preview.nvim',
		cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
		build = 'cd app && yarn install',
		init = function()
			vim.g.mkdp_filetypes = { 'markdown' }
		end,
		ft = { 'markdown' },
	},
}
