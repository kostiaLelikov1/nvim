return {
	'hrsh7th/nvim-cmp',
	dependencies = {
		'L3MON4D3/LuaSnip',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'saadparwaiz1/cmp_luasnip',
		'VonHeikemen/lsp-zero.nvim',
	},
	config = function()
		local cmp = require('cmp')
		local cmp_format = require('lsp-zero').cmp_format()
		local cmp_autopairs = require('nvim-autopairs.completion.cmp')
		local luasnip = require('luasnip')

		cmp.setup({
			sources = {
				{ name = 'copilot', group_index = 2 },
				{ name = 'path' },
				{ name = 'nvim_lsp' },
				{ name = 'luasnip', keyword_length = 2 },
				{ name = 'buffer', keyword_length = 3 },
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<CR>'] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				}),
				['<C-d>'] = cmp.mapping.scroll_docs(-4),
				['<C-u>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
			}),
			formatting = cmp_format,
		})

		cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

		local autocomplete_group = vim.api.nvim_create_augroup('vimrc_autocompletion', { clear = true })

		vim.api.nvim_create_autocmd('FileType', {
			pattern = { 'sql', 'mysql', 'plsql' },
			callback = function()
				cmp.setup.buffer({ sources = { { name = 'vim-dadbod-completion' } } })
			end,
			group = autocomplete_group,
		})
	end,
}
