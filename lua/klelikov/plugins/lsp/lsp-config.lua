return {
	'neovim/nvim-lspconfig',
	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'HallerPatrick/py_lsp.nvim',
		'hrsh7th/cmp-nvim-lsp',
	},
	config = function()
		local mason = require('mason')
		local mason_lspconfig = require('mason-lspconfig')
		local lspconfig = require('lspconfig')
		local wk = require('which-key')

		local signs = {
			Error = '✘',
			Warn = '▲',
			Hint = '⚑',
			Info = '»',
		}

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = signs.Error,
					[vim.diagnostic.severity.WARN] = signs.Warn,
					[vim.diagnostic.severity.HINT] = signs.Hint,
					[vim.diagnostic.severity.INFO] = signs.Info,
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
					[vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
					[vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
					[vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
				},
				texthl = {
					[vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
					[vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
					[vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
					[vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
				},
			},
			virtual_text = true,
			update_in_insert = false,
			underline = true,
			severity_sort = true,
			float = {
				border = 'rounded',
				source = 'always',
			},
		})

		vim.api.nvim_create_autocmd('LspAttach', {
			callback = function(args)
				local bufnr = args.buf
				vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
			end,
		})

		local lsp_attach = function(_, bufnr)
			wk.add({
				{ 'g', group = '+LSP', buffer = bufnr }, -- Define the LSP group with 'g' prefix for the buffer

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

		local capabilities = require('cmp_nvim_lsp').default_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		mason.setup({})

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

		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					on_attach = lsp_attach,
					capabilities = capabilities,
				})
			end,

			-- Special configuration for lua_ls
			['lua_ls'] = function()
				lspconfig.lua_ls.setup({
					on_attach = lsp_attach,
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = {
								globals = { 'vim' },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file('', true),
								checkThirdParty = false,
							},
							telemetry = {
								enable = false,
							},
						},
					},
				})
			end,

			['cssmodules_ls'] = function()
				lspconfig.cssmodules_ls.setup({
					on_attach = function(client, bufnr)
						client.server_capabilities.definitionProvider = false
						lsp_attach(client, bufnr)
					end,
					capabilities = capabilities,
				})
			end,
		})

		lspconfig.gleam.setup({
			on_attach = lsp_attach,
			capabilities = capabilities,
		})

		require('py_lsp').setup({})
	end,
}
