return {
	'folke/which-key.nvim',
	event = 'VeryLazy',
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	config = function()
		local wk = require('which-key')

		-- Define leader key groups for better organization using the new format
		wk.add({
			{ "<leader>l", group = "LSP" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>c", group = "Copilot" },
			{ "<leader>e", group = "Explorer" },
			{ "<leader>m", group = "Marks" },
			{ "<leader>w", group = "Window" },
			{ "<leader>b", group = "Buffer" },
			{ "<leader>t", group = "Tabs" },
			{ "<leader>q", group = "Quit" },
			{ "<leader>x", group = "Text" },
			{ "<leader>T", group = "Terminal" },
		})

		-- Configure which-key options
		wk.setup({
			plugins = {
				spelling = {
					enabled = true,
					suggestions = 20,
				},
			},
			win = { -- Updated from 'window' to 'win'
				border = 'rounded',
				padding = { 2, 2, 2, 2 },
			},
			layout = {
				height = { min = 4, max = 25 },
				width = { min = 20, max = 50 },
				spacing = 3,
			},
			-- Replaced 'ignore_missing' with 'filter'
			filter = function(trigger, mapping, mode)
				return true -- Keep all mappings
			 end,
			show_help = true,
			triggers = { "<leader>" }, -- Changed from 'auto' to explicit triggers
		})
	end,
}
