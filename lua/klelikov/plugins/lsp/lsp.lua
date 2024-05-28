return {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v3.x',
	dependencies = {
		'neovim/nvim-lspconfig',
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'SmiteshP/nvim-navic',
	},
	config = function()
		local lsp_zero = require('lsp-zero')
		local mason = require('mason')
		local mason_lspconfig = require('mason-lspconfig')
		local navic = require('nvim-navic')

		lsp_zero.set_sign_icons({
			error = '✘',
			warn = '▲',
			hint = '⚑',
			info = '»',
		})

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
			vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts) vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts) vim.keymap.set('n', '<leader>rr', vim.lsp.buf.rename, opts) vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts) vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts) vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
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

		vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			underline = true,
			virtual_text = {
				spacing = 5,
				min = 'severity',
			},
			update_in_insert = true,
		})
	end,
}
