return {
	'stevearc/conform.nvim',
	config = function()
		local conform = require('conform')
		conform.setup({
			formatters_by_ft = {
				lua = { 'stylua' },
				javascript = { 'prettierd', 'prettier' },
				typescript = { 'prettierd', 'prettier' },
				javascriptreact = { 'prettierd', 'prettier' },
				typescriptreact = { 'prettierd', 'prettier' },
				python = { 'black' },
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
	end,
}
