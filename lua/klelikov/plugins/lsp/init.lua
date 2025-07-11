return {
	-- Core LSP Configuration
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'hrsh7th/cmp-nvim-lsp',
			'folke/neodev.nvim',
		},
		config = function()
			-- Setup neodev for Neovim Lua development
			require('neodev').setup()

			local mason = require('mason')
			local mason_lspconfig = require('mason-lspconfig')
			local lspconfig = require('lspconfig')
			local wk = require('which-key')

			-- Diagnostic signs
			local signs = { Error = '✘', Warn = '▲', Hint = '⚑', Info = '»' }

			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = signs.Error,
						[vim.diagnostic.severity.WARN] = signs.Warn,
						[vim.diagnostic.severity.HINT] = signs.Hint,
						[vim.diagnostic.severity.INFO] = signs.Info,
					},
				},
				virtual_text = true,
				update_in_insert = false,
				underline = true,
				severity_sort = true,
				float = { border = 'rounded', source = 'always' },
			})

			-- LSP keymaps
			local lsp_attach = function(_, bufnr)
				wk.add({
					{ 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', desc = 'Show Hover', buffer = bufnr },
					{ 'gd', '<cmd>Telescope lsp_definitions<cr>', desc = 'Go to Definition', buffer = bufnr },
					{ 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', desc = 'Go to Declaration', buffer = bufnr },
					{ 'gi', '<cmd>Telescope lsp_implementations<cr>', desc = 'Go to Implementations', buffer = bufnr },
					{ 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', desc = 'Go to Type Definition', buffer = bufnr },
					{ 'gr', '<cmd>Telescope lsp_references<cr>', desc = 'Go to References', buffer = bufnr },
					{ 'grr', '<cmd>lua vim.lsp.buf.rename()<cr>', desc = 'Rename', buffer = bufnr },
					{ 'gca', '<cmd>lua vim.lsp.buf.code_action()<cr>', desc = 'Code Action', buffer = bufnr },
					{ 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', desc = 'Open Diagnostic Float', buffer = bufnr },
					{ ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', desc = 'Go to Next Diagnostic', buffer = bufnr },
					{ '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', desc = 'Go to Previous Diagnostic', buffer = bufnr },
				}, { mode = 'n' })
			end

			-- Capabilities
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			-- Mason setup
			mason.setup()
			mason_lspconfig.setup({
				ensure_installed = {
					'ts_ls',
					'lua_ls',
					'prismals',
					'cssls',
					'cssmodules_ls',
					'pyright',
					'astro',
					'tailwindcss',
					'jsonls',
					'solargraph',
				},
				automatic_installation = true,
			})

			-- Configure LSP servers manually
			local servers = {
				'ts_ls',
				'lua_ls',
				'prismals',
				'cssls',
				'cssmodules_ls',
				'pyright',
				'astro',
				'tailwindcss',
				'jsonls',
				'solargraph',
			}

			for _, server_name in ipairs(servers) do
				local opts = {
					on_attach = lsp_attach,
					capabilities = capabilities,
				}

				-- Server-specific configurations
				if server_name == 'lua_ls' then
					opts.settings = {
						Lua = {
							diagnostics = { globals = { 'vim' } },
							workspace = {
								library = vim.api.nvim_get_runtime_file('', true),
								checkThirdParty = false,
							},
							telemetry = { enable = false },
						},
					}
				elseif server_name == 'cssmodules_ls' then
					opts.on_attach = function(client, bufnr)
						client.server_capabilities.definitionProvider = false
						lsp_attach(client, bufnr)
					end
				end

				lspconfig[server_name].setup(opts)
			end

			-- Additional language servers
			lspconfig.gleam.setup({ on_attach = lsp_attach, capabilities = capabilities })
		end,
	},

	-- Mason UI
	{ 'williamboman/mason.nvim', cmd = 'Mason', build = ':MasonUpdate' },

	-- Python LSP
	{
		'HallerPatrick/py_lsp.nvim',
		ft = 'python',
		config = function()
			require('py_lsp').setup({})
		end,
	},

	-- TypeScript Tools
	{ 'pmizio/typescript-tools.nvim', dependencies = { 'nvim-lua/plenary.nvim' }, opts = {} },

	-- LSP Saga
	{
		'nvimdev/lspsaga.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
		config = function()
			local wk = require('which-key')
			require('lspsaga').setup({
				lightbulb = { enable = false },
				code_action = { show_server_name = true },
			})

			wk.add({
				{ 'gs', group = 'Lspsaga' },
				{ 'gsca', '<cmd>Lspsaga code_action<CR>', desc = 'Code Action' },
				{ 'gsd', '<cmd>Lspsaga peek_definition<CR>', desc = 'Peek Definition' },
				{ 'gso', '<cmd>Lspsaga peek_type_definition<CR>', desc = 'Peek Type Definition' },
				{ 'gsf', '<cmd>Lspsaga finder<CR>', desc = 'LSP Finder' },
				{ 'gst', '<cmd>Lspsaga term_toggle<CR>', desc = 'Open Float Terminal' },
				{ 'gsl', '<cmd>Lspsaga outline<CR>', desc = 'LSP Outline' },
				{ 'gsrr', '<cmd>Lspsaga rename<CR>', desc = 'Rename' },
				{ 'gsK', '<cmd>Lspsaga hover_doc<CR>', desc = 'Hover Doc' },
			})
		end,
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'onsails/lspkind.nvim',
			{ 'zbirenbaum/copilot-cmp', dependencies = 'zbirenbaum/copilot.lua', config = true },
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')
			local lspkind = require('lspkind')

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-k>'] = cmp.mapping.select_prev_item(),
					['<C-j>'] = cmp.mapping.select_next_item(),
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = false }),
				}),
				sources = cmp.config.sources({
					{ name = 'copilot', priority = 1000 },
					{ name = 'nvim_lsp', priority = 750 },
					{ name = 'path', priority = 500 },
					{ name = 'luasnip', priority = 500 },
					{ name = 'buffer', priority = 250 },
				}),
				formatting = {
					format = lspkind.cmp_format({
						maxwidth = 50,
						ellipsis_char = '...',
						symbol_map = { Copilot = '' },
					}),
				},
			})
		end,
	},

	-- Formatting
	{
		'stevearc/conform.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			local conform = require('conform')
			conform.setup({
				formatters_by_ft = {
					javascript = { 'prettier' },
					typescript = { 'prettier' },
					javascriptreact = { 'prettier' },
					typescriptreact = { 'prettier' },
					svelte = { 'prettier' },
					css = { 'prettier' },
					html = { 'prettier' },
					json = { 'prettier' },
					yaml = { 'prettier' },
					markdown = { 'prettier' },
					graphql = { 'prettier' },
					liquid = { 'prettier' },
					lua = { 'stylua' },
					python = { 'black' },
				},
				-- format_on_save = {
				-- 	lsp_fallback = true,
				-- 	async = false,
				-- 	timeout_ms = 1000,
				-- },
			})

			vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
				conform.format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
			end, { desc = 'Format file or range (in visual mode)' })

			vim.keymap.set('', '<leader>fp', function()
				conform.format({ async = true, lsp_fallback = true })
			end, { desc = 'Format Project' })
		end,
	},

	-- Additional LSP enhancements
	{ 'windwp/nvim-autopairs', event = 'InsertEnter', opts = { check_ts = true } },
	{ 'windwp/nvim-ts-autotag', dependencies = 'nvim-treesitter/nvim-treesitter', opts = {} },
	{
		'antosha417/nvim-lsp-file-operations',
		dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-tree.lua' },
		config = true,
	},
	{
		'kevinhwang91/nvim-ufo',
		dependencies = 'kevinhwang91/promise-async',
		config = function()
			vim.o.foldcolumn = '1'
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
			vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

			require('ufo').setup({
				provider_selector = function()
					return { 'lsp', 'indent' }
				end,
			})
		end,
	},
}
