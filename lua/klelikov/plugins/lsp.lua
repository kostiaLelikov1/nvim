return {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v3.x',
	dependencies = {
		'neovim/nvim-lspconfig',
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/nvim-cmp',
		'L3MON4D3/LuaSnip',
		'stevearc/conform.nvim',
		'kevinhwang91/nvim-ufo',
		'kevinhwang91/promise-async',
		'SmiteshP/nvim-navic',
	},
	config = function()
		local lsp_zero = require('lsp-zero')
		local mason = require('mason')
		local mason_lspconfig = require('mason-lspconfig')
		local conform = require('conform')
		local cmp = require('cmp')
		local cmp_format = require('lsp-zero').cmp_format()
		local ufo = require('ufo')
		local navic = require('nvim-navic')
		local cmp_autopairs = require('nvim-autopairs.completion.cmp')

		navic.setup({
			lsp = {
				auto_attach = true,
			},
		})

		conform.setup({
			formatters_by_ft = {
				lua = { 'stylua' },
				javascript = { { 'prettierd', 'prettier' } },
				typescript = { { 'prettierd', 'prettier' } },
				javascriptreact = { { 'prettierd', 'prettier' } },
				typescriptreact = { { 'prettierd', 'prettier' } },
			},
		})

		vim.api.nvim_create_user_command('Format', function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					['end'] = { args.line2, end_line:len() },
				}
			end
			conform.format({ async = true, lsp_fallback = true, range = range })
		end, { range = true })

		vim.keymap.set('', '<leader>fp', function()
			require('conform').format({ async = true, lsp_fallback = true })
		end, { desc = '[F]ormat [P]roject' })

		lsp_zero.omnifunc.setup({
			tabcomplete = true,
			use_fallback = true,
			update_on_delete = true,
		})

		lsp_zero.on_attach(function(client, bufnr)
			local opts = { buffer = bufnr }

			vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
			vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', opts)
			vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
			vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', opts)
			vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
			vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)
			vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
			vim.keymap.set('n', '<leader>rr', vim.lsp.buf.rename, opts)
			vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
			vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)

			if client.server_capabilities.documentSymbolProvider then
				navic.attach(client, bufnr)
			end
		end)

		mason.setup({})
		mason_lspconfig.setup({
			ensure_installed = {
				'tsserver',
				'lua_ls',
				'eslint',
				'prismals',
				'cssls',
				'cssmodules_ls',
				'pyright',
			},
			handlers = {
				lsp_zero.default_setup,
				lua_ls = function()
					local lua_opts = lsp_zero.nvim_lua_ls()
					require('lspconfig').lua_ls.setup(lua_opts)
				end,
				cssmodules_ls = function()
					require('lspconfig').cssmodules_ls.setup({
						on_attach = function(client, bufnr)
							client.server_capabilities.definitionProvider = false
							lsp_zero.default_setup(client, bufnr)
						end,
					})
				end,
			},
			automatic_installation = true,
		})

		cmp.setup({
			sources = {
				{ name = 'copilot', group_index = 2 },
				{ name = 'nvim_lsp', group_index = 2 },
				{ name = 'luasnip' },
			},
			mapping = cmp.mapping.preset.insert({
				['<CR>'] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				}),
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
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

		vim.o.foldcolumn = '1'
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		ufo.setup()

		vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
		vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

		lsp_zero.set_server_config({
			capabilities = {
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			},
		})
	end,
}
