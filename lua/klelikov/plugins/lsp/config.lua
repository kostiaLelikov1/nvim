local lsp_zero = require('lsp-zero')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local conform = require('conform')
local cmp = require('cmp')
local cmp_format = require('lsp-zero').cmp_format()
local ufo = require('ufo')

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
end)

lsp_zero.omnifunc.setup({
	tabcomplete = true,
	use_fallback = true,
	update_on_delete = true,
})

lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })

	local opts = { buffer = bufnr }

	vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', opts)
	vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', opts)
	vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)
end)

mason.setup({})
mason_lspconfig.setup({
	ensure_installed = {
		'tsserver',
		'lua_ls',
		'eslint',
	},
	handlers = {
		lsp_zero.default_setup,
		lua_ls = function()
			local lua_opts = lsp_zero.nvim_lua_ls()
			require('lspconfig').lua_ls.setup(lua_opts)
		end,
	},
	automatic_installation = true,
})

cmp.setup({
	sources = {
		{ name = 'copilot', group_index = 2 },
		{ name = 'nvim_lsp', group_index = 2 },
	},
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
	}),
	formatting = cmp_format,
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
