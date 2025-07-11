return {
	-- Colorscheme
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		lazy = false,
		priority = 1000,
		config = function()
			require('catppuccin').setup({
				flavour = 'macchiato',
				transparent_background = true,
			})
			vim.cmd.colorscheme('catppuccin')
		end,
	},

	-- Lualine
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/noice.nvim' },
		config = function()
			local lualine = require('lualine')
			local lazy_status = require('lazy.status')

			lualine.setup({
				options = {
					theme = 'catppuccin',
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
				},
				sections = {
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff', 'diagnostics' },
					lualine_c = {
						'%=',
						{
							'filename',
							path = 0,
						},
					},
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = '#ff9e64' },
						},
						{
							require('noice').api.status.command.get,
							cond = require('noice').api.status.command.has,
							color = { fg = '#ff9e64' },
						},
						{
							require('noice').api.status.mode.get,
							cond = require('noice').api.status.mode.has,
							color = { fg = '#ff9e64' },
						},
						{
							require('noice').api.status.search.get,
							cond = require('noice').api.status.search.has,
							color = { fg = '#ff9e64' },
						},
						'encoding',
						'fileformat',
						'filetype',
					},
					lualine_y = { 'progress' },
					lualine_z = { 'location' },
				},
			})
		end,
	},

	-- Notify
	{
		'rcarriga/nvim-notify',
		lazy = false,
		config = function()
			require('notify').setup({
				background_colour = '#000000',
				timeout = 3000,
				stages = 'slide',
				top_down = false, -- Show notifications from bottom
				max_height = function()
					return math.floor(vim.o.lines * 0.75)
				end,
				max_width = function()
					return math.floor(vim.o.columns * 0.75)
				end,
				on_open = function(win)
					vim.api.nvim_win_set_config(win, { zindex = 100 })
				end,
			})
		end,
	},

	-- Noice (UI for messages, cmdline and popupmenu)
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
		opts = {
			lsp = {
				override = {
					['vim.lsp.util.convert_input_to_markdown_lines'] = true,
					['vim.lsp.util.stylize_markdown'] = true,
					['cmp.entry.get_documentation'] = true,
				},
			},
			routes = {
				{
					filter = {
						event = 'msg_show',
						any = {
							{ find = '%d+L, %d+B' },
							{ find = '; after #%d+' },
							{ find = '; before #%d+' },
						},
					},
					view = 'mini',
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		},
		keys = {
			{ '<leader>sn', '', desc = '+noice' },
			{
				'<S-Enter>',
				function()
					require('noice').redirect(vim.fn.getcmdline())
				end,
				mode = 'c',
				desc = 'Redirect Cmdline',
			},
			{
				'<leader>snl',
				function()
					require('noice').cmd('last')
				end,
				desc = 'Noice Last Message',
			},
			{
				'<leader>snh',
				function()
					require('noice').cmd('history')
				end,
				desc = 'Noice History',
			},
			{
				'<leader>sna',
				function()
					require('noice').cmd('all')
				end,
				desc = 'Noice All',
			},
			{
				'<leader>snd',
				function()
					require('noice').cmd('dismiss')
				end,
				desc = 'Dismiss All',
			},
		},
	},

	-- Colorizer
	{ 'NvChad/nvim-colorizer.lua', event = { 'BufReadPre', 'BufNewFile' }, opts = {} },

	-- Indent Blankline
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		event = { 'BufReadPre', 'BufNewFile' },
		opts = { indent = { char = '┊' } },
	},
}
