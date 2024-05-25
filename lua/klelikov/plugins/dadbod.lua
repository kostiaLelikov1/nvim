return {
	'tpope/vim-dadbod',
	dependencies = {
		{ 'kristijanhusak/vim-dadbod-ui' },
		{ 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' } },
	},
	config = function()
		local wk = require('which-key')
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_winwidth = 50
		vim.g.db_ui_winheight = 15
		vim.g.db_ui_save_location = '~/.config/nvim/db_ui_history'
		vim.g.db_ui_use_nvim_notify = 1

		wk.register({
			d = {
				name = 'database',
				d = {
					function()
						vim.cmd('DBUIToggle')
					end,
					'Toggle DBUI',
				},
			},
		}, { prefix = '<leader>' })
	end,
}
