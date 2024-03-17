return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		local navic = require('nvim-navic')
		local colors = {
			blue = '#80a0ff',
			cyan = '#79dac8',
			black = '#080808',
			white = '#c6c6c6',
			red = '#ff5189',
			violet = '#d183e8',
			grey = '#303030',
		}

		local bubbles_theme = {
			normal = {
				a = { fg = colors.black, bg = colors.violet },
				b = { fg = colors.white, bg = colors.grey },
				c = { fg = colors.white },
			},

			insert = { a = { fg = colors.black, bg = colors.blue } },
			visual = { a = { fg = colors.black, bg = colors.cyan } },
			replace = { a = { fg = colors.black, bg = colors.red } },

			inactive = {
				a = { fg = colors.white, bg = colors.black },
				b = { fg = colors.white, bg = colors.black },
				c = { fg = colors.white },
			},
		}

		require('lualine').setup({
			options = {
				theme = bubbles_theme,
				component_separators = '',
				section_separators = { left = '', right = '' },
			},
			winbar = {
				lualine_c = {
					{ navic.get_location, cond = navic.is_available },
				},
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'branch' },
				lualine_c = { 'filename' },
				lualine_x = { 'encoding', 'filetype' },
				lualine_y = { 'progress' },
				lualine_z = { 'location' },
			},
		})
	end,
}
