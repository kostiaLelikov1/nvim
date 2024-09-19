return {
	'nvimdev/lspsaga.nvim',
	config = function()
		local wk = require('which-key')
		require('lspsaga').setup({
			lightbulb = {
				enable = false,
			},
			code_action = {
				show_server_name = true,
			},
		})

		wk.add({
			{ 'gs', group = 'Lspsaga' }, -- Group for Lspsaga commands

			-- Individual key mappings under the 'gs' prefix
			{ 'gsca', '<cmd>Lspsaga code_action<CR>', desc = 'Code Action' },
			{ 'gsd', '<cmd>Lspsaga peek_definition<CR>', desc = 'Peek Definition' },
			{ 'gso', '<cmd>Lspsaga peek_type_definition<CR>', desc = 'Peek Type Definition' },
			{ 'gsf', '<cmd>Lspsaga finder<CR>', desc = 'LSP Finder' },
			{ 'gst', '<cmd>Lspsaga term_toggle<CR>', desc = 'Open Float Terminal' },
			{ 'gsl', '<cmd>Lspsaga outline<CR>', desc = 'LSP Outline' },
			{ 'gsrr', '<cmd>Lspsaga rename<CR>', desc = 'Rename' },
			{ 'gsK', '<cmd>Lspsaga hover_doc<CR>', desc = 'Hover Doc' },

			-- Optional: You can add specific modes if needed
			-- { "gs...", mode = "n" },  -- Only in NORMAL mode
		})
	end,
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'nvim-tree/nvim-web-devicons',
		'VonHeikemen/lsp-zero.nvim',
	},
}
