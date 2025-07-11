return {
	-- Simple Claude Terminal
	{
		'klelikov/claude-terminal.nvim',
		dir = vim.fn.stdpath('config') .. '/lua/klelikov/claude-terminal',
		config = function()
			require('klelikov.claude-terminal').setup()
		end,
		keys = {
			{ '<leader>ao', '<cmd>ClaudeOpen<cr>', desc = 'Open Claude Terminal' },
			{ '<leader>at', '<cmd>ClaudeToggle<cr>', desc = 'Toggle Claude Terminal' },
			{ '<leader>ac', '<cmd>ClaudeClose<cr>', desc = 'Close Claude Terminal' },
		},
	},
}
