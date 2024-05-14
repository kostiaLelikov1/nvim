return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons', 'f-person/git-blame.nvim' },
	config = function()
		local git_blame = require('gitblame')
		vim.g.gitblame_display_virtual_text = 0
		vim.g.gitblame_message_template = '<summary> • <date> • <author>'
		vim.g.gitblame_date_format = '%Y-%m-%d'

		require('lualine').setup({
			options = {
				theme = 'catppuccin',
				component_separators = '',
				section_separators = { left = '', right = '' },
			},
			tabline = {
				lualine_a = { 'tabs' },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {
					{ git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
				},
				lualine_z = {
					{
						'navic',
						color_correction = nil,
						navic_opts = nil,
					},
				},
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'branch', 'diff', 'diagnostics' },
				lualine_c = { { 'filename', path = 1 } },
				lualine_x = { 'encoding' },
				lualine_y = {
					{
						function()
							local unsaved = 0
							for _, buf in ipairs(vim.api.nvim_list_bufs()) do
								if vim.api.nvim_buf_get_option(buf, 'modified') then
									unsaved = unsaved + 1
								end
							end
							local readonly = vim.bo.readonly and ' ' or ''
							return 'unsaved ' .. unsaved .. readonly
						end,
					},
				},
				lualine_z = { 'location' },
			},
		})
	end,
}
