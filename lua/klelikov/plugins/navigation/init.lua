return {
	-- Telescope
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
			'nvim-tree/nvim-web-devicons',
			'nvim-telescope/telescope-ui-select.nvim',
			'debugloop/telescope-undo.nvim',
		},
		config = function()
			local telescope = require('telescope')
			local actions = require('telescope.actions')

			telescope.setup({
				defaults = {
					path_display = { 'smart' },
					mappings = {
						i = {
							['<C-k>'] = actions.move_selection_previous,
							['<C-j>'] = actions.move_selection_next,
							['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
				},
				extensions = {
					['ui-select'] = {
						require('telescope.themes').get_dropdown({}),
					},
					undo = {
						use_delta = true,
						side_by_side = true,
						layout_strategy = 'vertical',
						layout_config = { preview_height = 0.8 },
					},
				},
			})

			telescope.load_extension('fzf')
			telescope.load_extension('ui-select')
			telescope.load_extension('undo')

			-- Keymaps
			local keymap = vim.keymap
			local builtin = require('telescope.builtin')

			-- File and text search
			keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Fuzzy find files in cwd' })
			keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', { desc = 'Fuzzy find recent files' })
			keymap.set('n', '<leader>fs', '<cmd>Telescope live_grep<cr>', { desc = 'Find string in cwd' })
			keymap.set('n', '<leader>fc', '<cmd>Telescope grep_string<cr>', { desc = 'Find string under cursor in cwd' })
			keymap.set('n', '<leader>ft', '<cmd>TodoTelescope<cr>', { desc = 'Find todos' })
			keymap.set('n', '<leader>fu', '<cmd>Telescope undo<cr>', { desc = 'Find undo history' })
			keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
			keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find Help Tags' })
			keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Find Keymaps' })
			keymap.set('n', '<leader>fC', builtin.commands, { desc = 'Find Commands' })

			-- LSP related searches
			keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, { desc = 'Find Document Symbols' })
			keymap.set('n', '<leader>lS', builtin.lsp_workspace_symbols, { desc = 'Find Workspace Symbols' })
			keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = 'Find References' })
			keymap.set('n', '<leader>ld', builtin.lsp_definitions, { desc = 'Find Definitions' })
			keymap.set('n', '<leader>li', builtin.lsp_implementations, { desc = 'Find Implementations' })
			keymap.set('n', '<leader>lt', builtin.lsp_type_definitions, { desc = 'Find Type Definitions' })

			-- Git related searches
			keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Find Git Commits' })
			keymap.set('n', '<leader>gb', builtin.git_branches, { desc = 'Find Git Branches' })
			keymap.set('n', '<leader>gS', builtin.git_status, { desc = 'Git Status' })
			keymap.set('n', '<leader>gh', '<cmd>Telescope git_file_history<cr>', { desc = 'Git File History' })
		end,
	},

	-- Nvim Tree
	{
		'nvim-tree/nvim-tree.lua',
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			local nvimtree = require('nvim-tree')

			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			nvimtree.setup({
				view = { width = 35, relativenumber = true },
				renderer = {
					indent_markers = { enable = true },
					icons = {
						glyphs = {
							folder = {
								arrow_closed = '▸',
								arrow_open = '▾',
							},
						},
					},
				},
				actions = {
					open_file = {
						window_picker = { enable = false },
					},
				},
				filters = { custom = { '^.DS_Store$', '^.git$' } },
				git = { ignore = false },
			})

			-- Keymaps
			local keymap = vim.keymap
			keymap.set('n', '<leader>ee', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
			keymap.set(
				'n',
				'<leader>ef',
				'<cmd>NvimTreeFindFileToggle<CR>',
				{ desc = 'Toggle file explorer on current file' }
			)
			keymap.set('n', '<leader>ec', '<cmd>NvimTreeCollapse<CR>', { desc = 'Collapse file explorer' })
			keymap.set('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>', { desc = 'Refresh file explorer' })
		end,
	},

	-- Grapple (file marking)
	{
		'cbochs/grapple.nvim',
		dependencies = 'nvim-tree/nvim-web-devicons',
		opts = { scope = 'git' },
		event = { 'BufReadPost', 'BufNewFile' },
		cmd = 'Grapple',
		keys = {
			{ '<leader>M', '<cmd>Grapple toggle<cr>', desc = 'Grapple toggle tag' },
			{ '<leader>mn', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle next tag' },
			{ '<leader>mp', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle previous tag' },
			{ '<leader>mc', '<cmd>Grapple reset<cr>', desc = 'Grapple reset tags' },
			{ '<leader>mq', '<cmd>Grapple quickfix<cr>', desc = 'Grapple quickfix' },
			{ '<a-a>', '<cmd>Grapple select index=1<cr>', desc = 'Grapple goto 1' },
			{ '<a-s>', '<cmd>Grapple select index=2<cr>', desc = 'Grapple goto 2' },
			{ '<a-d>', '<cmd>Grapple select index=3<cr>', desc = 'Grapple goto 3' },
			{ '<a-f>', '<cmd>Grapple select index=4<cr>', desc = 'Grapple goto 4' },
		},
	},

	-- Tmux Navigator
	{
		'christoomey/vim-tmux-navigator',
		cmd = {
			'TmuxNavigateLeft',
			'TmuxNavigateDown',
			'TmuxNavigateUp',
			'TmuxNavigateRight',
			'TmuxNavigatePrevious',
		},
		keys = {
			{ '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
			{ '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
			{ '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
			{ '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
			{ '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
		},
	},
}
