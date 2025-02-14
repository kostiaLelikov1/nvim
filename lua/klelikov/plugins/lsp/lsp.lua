return {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v4.x',
	dependencies = {
		'neovim/nvim-lspconfig',
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'HallerPatrick/py_lsp.nvim',
		'hrsh7th/cmp-nvim-lsp',
	},
	config = function()
		local lsp_zero = require('lsp-zero')
		local mason = require('mason')
		local mason_lspconfig = require('mason-lspconfig')
		local wk = require('which-key')

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

		local lsp_attach = function(_, bufnr)
			wk.add({
				{ 'g', group = '+LSP', buffer = bufnr }, -- Define the LSP group with 'g' prefix for the buffer

				-- Individual key mappings with buffer-specific options
				{ 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', desc = 'Show Hover', buffer = bufnr },
				{ 'gd', '<cmd>Telescope lsp_definitions<cr>', desc = 'Go to Definition', buffer = bufnr },
				{ 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', desc = 'Go to Declaration', buffer = bufnr },
				{ 'gi', '<cmd>Telescope lsp_implementations<cr>', desc = 'Go to Implementations', buffer = bufnr },
				{ 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', desc = 'Go to Type Definition', buffer = bufnr },
				{ 'gr', '<cmd>Telescope lsp_references<cr>', desc = 'Go to References', buffer = bufnr },
				{ 'grr', '<cmd>lua vim.lsp.buf.rename()<cr>', desc = 'Rename', buffer = bufnr },
				{ 'gca', '<cmd>lua vim.lsp.buf.code_action()<cr>', desc = 'Code Action', buffer = bufnr },
				{ 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', desc = 'Open Diagnostic Float', buffer = bufnr },

				-- Diagnostic navigation mappings with buffer-specific options
				{ ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', desc = 'Go to Next Diagnostic', buffer = bufnr },
				{ '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', desc = 'Go to Previous Diagnostic', buffer = bufnr },
			}, {
				mode = 'n', -- Apply these mappings in NORMAL mode
			})
		end

		lsp_zero.extend_lspconfig({
			capabilities = require('cmp_nvim_lsp').default_capabilities(),
			lsp_attach = lsp_attach,
			sign_test = true,
			float_border = 'rounded',
		})

		mason.setup({})
		mason_lspconfig.setup({
			ensure_installed = {
				'ts_ls',
				'lua_ls',
				'eslint',
				'prismals',
				'cssls',
				'cssmodules_ls',
				'pyright',
				'astro',
				'tailwindcss',
				'jsonls',
        'solargraph',
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

		require('lspconfig').gleam.setup({
			on_attach = function(client, bufnr)
				lsp_zero.default_setup(client, bufnr)
			end,
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

		require('py_lsp').setup({})
	end,
}
