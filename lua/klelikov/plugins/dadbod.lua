return {
	'tpope/vim-dadbod',
	dependencies = {
		{ 'kristijanhusak/vim-dadbod-ui' },
		{ 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' } },
	},
	config = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_winwidth = 50
		vim.g.db_ui_winheight = 15
		vim.g.db_ui_save_location = '~/.config/nvim/db_ui_history'
		vim.g.db_ui_use_nvim_notify = 1

		vim.keymap.set('n', '<leader>dd', '<cmd>DBUIToggle<cr>', { desc = 'Toggle DBUI' })
	end,
}
