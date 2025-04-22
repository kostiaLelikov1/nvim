return {
	'CopilotC-Nvim/CopilotChat.nvim',
	branch = 'main',
	dependencies = {
		{ 'zbirenbaum/copilot.lua' },
		{ 'nvim-lua/plenary.nvim' },
	},
  build = "make tiktoken",
	opts = {
		debug = false, -- Enable debugging
    model = 'claude-3.7-sonnet',
		prompts = {
			Explain = {
				prompt = 'Explain how the following code works in detail.',
				mapping = '<leader>ce',
			},
			Review = {
				prompt = 'Review the following code and provide suggestions for improvement.',
				mapping = '<leader>cr',
			},
			Tests = {
				prompt = 'Generate comprehensive unit tests for the following code.',
				mapping = '<leader>ct',
			},
			Refactor = {
				prompt = 'Refactor the following code to improve clarity and readability without changing its behavior.',
				mapping = '<leader>cf',
			},
			FixError = {
				prompt = 'Fix the following error in my code:',
				mapping = '<leader>cx',
			},
			Optimize = {
				prompt = 'Optimize the following code for better performance.',
				mapping = '<leader>co',
			},
			Docs = {
				prompt = 'Write comprehensive documentation for the following code:',
				mapping = '<leader>cd',
			},
		},
	},
	config = function(_, opts)
		local chat = require('CopilotChat')
		chat.setup(opts)

		local wk = require('which-key')

		wk.add({
			{ '<leader>c', group = 'Copilot' },
			{ '<leader>cc', '<cmd>CopilotChatToggle<cr>', desc = 'Toggle Copilot Chat' },
			{ '<leader>ce', chat.ask_or_help, desc = 'Explain Code' },
			{ '<leader>cr', chat.ask_or_help, desc = 'Review Code' },
			{ '<leader>ct', chat.ask_or_help, desc = 'Generate Tests' },
			{ '<leader>cf', chat.ask_or_help, desc = 'Refactor Code' },
			{ '<leader>cx', chat.ask_or_help, desc = 'Fix Error' },
			{ '<leader>co', chat.ask_or_help, desc = 'Optimize Code' },
			{ '<leader>cd', chat.ask_or_help, desc = 'Write Documentation' },
			{ '<leader>ch', '<cmd>CopilotChatHistory<cr>', desc = 'View Chat History' },
		})

		wk.add({
			{
				'<leader>cv',
				function()
					chat.ask('Explain selected code', { selection = true })
				end,
				desc = 'Explain Selected Code',
			},
		}, { mode = 'v' })
	end,
}
