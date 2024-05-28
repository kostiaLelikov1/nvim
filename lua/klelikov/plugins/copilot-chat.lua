return {
	'CopilotC-Nvim/CopilotChat.nvim',
	branch = 'canary',
	dependencies = {
		{ 'zbirenbaum/copilot.lua' },
		{ 'nvim-lua/plenary.nvim' },
	},
	event = 'VeryLazy',
	config = function()
		local prompts = {
			Explain = 'Please explain how the following code works.',
			Review = 'Please review the following code and provide suggestions for improvement.',
			Tests = 'Please explain how the selected code works, then generate unit tests for it.',
			Refactor = 'Please refactor the following code to improve its clarity and readability.',
			FixCode = 'Please fix the following code to make it work as intended.',
			FixError = 'Please explain the error in the following text and provide a solution.',
			BetterNamings = 'Please provide better names for the following variables and functions.',
			Documentation = 'Please provide documentation for the following code.',
			SwaggerApiDocs = 'Please provide documentation for the following API using Swagger.',
			SwaggerJsDocs = 'Please write JSDoc for the following API using Swagger.',
			Summarize = 'Please summarize the following text.',
			Spelling = 'Please correct any grammar and spelling errors in the following text.',
			Wording = 'Please improve the grammar and wording of the following text.',
			Concise = 'Please rewrite the following text to make it more concise.',
		}

		local chat = require('CopilotChat')
		local select = require('CopilotChat.select')
		local wk = require('which-key')

		prompts.Commit = {
			prompt = 'Write commit message for the change',
			selection = select.gitdiff,
		}
		prompts.CommitStaged = {
			prompt = 'Write commit message for the change',
			selection = function(source)
				return select.gitdiff(source, true)
			end,
		}

		chat.setup({
			prompts = prompts,
			question_header = '## User ',
			answer_header = '## Copilot ',
			error_header = '## Error ',
			separator = ' ',
			auto_follow_cursor = false,
			mappings = {
				complete = {
					detail = 'Use @<Tab> or /<Tab> for options.',
					insert = '<Tab>',
				},
				close = {
					normal = 'q',
					insert = '<C-c>',
				},
				reset = {
					normal = '<C-x>',
					insert = '<C-x>',
				},
				submit_prompt = {
					normal = '<CR>',
					insert = '<C-CR>',
				},
				accept_diff = {
					normal = '<C-y>',
					insert = '<C-y>',
				},
				yank_diff = {
					normal = 'gmy',
				},
				show_diff = {
					normal = 'gmd',
				},
				show_system_prompt = {
					normal = 'gmp',
				},
				show_user_selection = {
					normal = 'gms',
				},
			},
		})

		vim.api.nvim_create_user_command('CopilotChatVisual', function(args)
			chat.ask(args.args, { selection = select.visual })
		end, { nargs = '*', range = true })

		vim.api.nvim_create_user_command('CopilotChatInline', function(args)
			chat.ask(args.args, {
				selection = select.visual,
				window = {
					layout = 'float',
					relative = 'cursor',
					width = 1,
					height = 0.4,
					row = 1,
				},
			})
		end, { nargs = '*', range = true })

		vim.api.nvim_create_user_command('CopilotChatBuffer', function(args)
			chat.ask(args.args, { selection = select.buffer })
		end, { nargs = '*', range = true })

		vim.api.nvim_create_autocmd('BufEnter', {
			pattern = 'copilot-*',
			callback = function()
				local ft = vim.bo.filetype
				if ft == 'copilot-chat' then
					vim.bo.filetype = 'markdown'
				end
			end,
		})

		wk.register({
			g = {
				m = {
					name = '+Copilot Chat',
					d = 'Show diff',
					p = 'System prompt',
					s = 'Show selection',
					y = 'Yank diff',
				},
			},
		})
	end,
	keys = {
		{
			'<leader>ch',
			function()
				local actions = require('CopilotChat.actions')
				require('CopilotChat.integrations.telescope').pick(actions.help_actions())
			end,
			desc = 'CopilotChat - Help actions',
		},
		{
			'<leader>cp',
			function()
				local actions = require('CopilotChat.actions')
				require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
			end,
			desc = 'CopilotChat - Prompt actions',
		},
		{
			'<leader>cp',
			":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
			mode = 'x',
			desc = 'CopilotChat - Prompt actions',
		},
		{ '<leader>ct', '<cmd>CopilotChatTests<cr>', desc = 'CopilotChat - Generate tests' },
		{ '<leader>cr', '<cmd>CopilotChatReview<cr>', desc = 'CopilotChat - Review code' },
		{ '<leader>cR', '<cmd>CopilotChatRefactor<cr>', desc = 'CopilotChat - Refactor code' },
		{ '<leader>cn', '<cmd>CopilotChatBetterNamings<cr>', desc = 'CopilotChat - Better Naming' },
		{
			'<leader>cv',
			':CopilotChatVisual',
			mode = 'x',
			desc = 'CopilotChat - Open in vertical split',
		},
		{
			'<leader>cx',
			':CopilotChatInline<cr>',
			mode = 'x',
			desc = 'CopilotChat - Inline chat',
		},
		{
			'<leader>ci',
			function()
				local input = vim.fn.input('Ask Copilot: ')
				if input ~= '' then
					vim.cmd('CopilotChat ' .. input)
				end
			end,
			desc = 'CopilotChat - Ask input',
		},
		{
			'<leader>cm',
			'<cmd>CopilotChatCommit<cr>',
			desc = 'CopilotChat - Generate commit message for all changes',
		},
		{
			'<leader>cM',
			'<cmd>CopilotChatCommitStaged<cr>',
			desc = 'CopilotChat - Generate commit message for staged changes',
		},
		{
			'<leader>cq',
			function()
				local input = vim.fn.input('Quick Chat: ')
				if input ~= '' then
					vim.cmd('CopilotChatBuffer ' .. input)
				end
			end,
			desc = 'CopilotChat - Quick chat',
		},
		{ '<leader>cd', '<cmd>CopilotChatDebugInfo<cr>', desc = 'CopilotChat - Debug Info' },
		{ '<leader>cf', '<cmd>CopilotChatFixDiagnostic<cr>', desc = 'CopilotChat - Fix Diagnostic' },
		{ '<leader>cl', '<cmd>CopilotChatReset<cr>', desc = 'CopilotChat - Clear buffer and chat history' },
		{ '<leader>cv', '<cmd>CopilotChatToggle<cr>', desc = 'CopilotChat - Toggle' },
	},
}
