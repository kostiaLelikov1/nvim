return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.5',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope-fzf-native.nvim',
	},
	config = function()
		local builtin = require('telescope.builtin')
		local telescope = require('telescope')
		local pickers = require('telescope.pickers')
		local finders = require('telescope.finders')
		local previewers = require('telescope.previewers')
		local config = require('telescope.config').values
		local actions = require('telescope.actions')
		local action_state = require('telescope.actions.state')
		local wk = require('which-key')

		local function list_opened_windows()
			pickers
				.new({}, {
					prompt_title = 'Opened Windows',
					finder = finders.new_table({
						results = vim.api.nvim_list_wins(),
						entry_maker = function(entry)
							local buf = vim.api.nvim_win_get_buf(entry)
							local buf_name = vim.api.nvim_buf_get_name(buf)
							local win_id = entry
							return {
								value = win_id,
								display = buf_name ~= '' and buf_name or '[No Name]',
								ordinal = buf_name,
								win_id = win_id,
								buf = buf, -- Keep track of the buffer
							}
						end,
					}),
					sorter = config.generic_sorter({}),
					previewer = previewers.new_buffer_previewer({
						define_preview = function(self, entry, status)
							local buf = entry.buf
							local buf_name = vim.api.nvim_buf_get_name(buf)

							local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
							vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', ft)

							local buf_content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
							vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, buf_content)

							pcall(function()
								vim.treesitter.start(self.state.bufnr, ft)
							end)
						end,
					}),
					attach_mappings = function(prompt_bufnr, map)
						-- Close window but stay in picker with <C-x>
						map('i', '<C-x>', function()
							local selection = action_state.get_selected_entry()
							vim.api.nvim_win_close(selection.win_id, false)
							-- Refresh the picker to update the list
							actions.close(prompt_bufnr)
							list_opened_windows()
						end)
						map('n', '<C-x>', function()
							local selection = action_state.get_selected_entry()
							vim.api.nvim_win_close(selection.win_id, false)
							-- Refresh the picker to update the list
							actions.close(prompt_bufnr)
							list_opened_windows()
						end)
						-- Close window and exit picker on <CR>
						map('i', '<CR>', function()
							local selection = action_state.get_selected_entry()
							actions.close(prompt_bufnr)
							vim.api.nvim_win_close(selection.win_id, false)
						end)
						map('n', '<CR>', function()
							local selection = action_state.get_selected_entry()
							actions.close(prompt_bufnr)
							vim.api.nvim_win_close(selection.win_id, false)
						end)
						return true
					end,
				})
				:find()
		end

		wk.add({
			-- File finding
			{ '<leader>ff', builtin.find_files, desc = 'Find Files' },
			{ '<leader>fg', builtin.live_grep, desc = 'Find Text (Grep)' },
			{ '<leader>fb', builtin.buffers, desc = 'Find Buffers' },
			{ '<leader>fw', list_opened_windows, desc = 'Find Opened Windows' },
			{ '<leader>fr', builtin.oldfiles, desc = 'Find Recent Files' },

			-- Help and documentation
			{ '<leader>fh', builtin.help_tags, desc = 'Find Help' },
			{ '<leader>fk', builtin.keymaps, desc = 'Find Keymaps' },
			{ '<leader>fc', builtin.commands, desc = 'Find Commands' },

			-- LSP related searches
			{ '<leader>ls', builtin.lsp_document_symbols, desc = 'Find Document Symbols' },
			{ '<leader>lS', builtin.lsp_workspace_symbols, desc = 'Find Workspace Symbols' },
			{ '<leader>lr', builtin.lsp_references, desc = 'Find References' },
			{ '<leader>ld', builtin.lsp_definitions, desc = 'Find Definitions' },
			{ '<leader>li', builtin.lsp_implementations, desc = 'Find Implementations' },
			{ '<leader>lt', builtin.lsp_type_definitions, desc = 'Find Type Definitions' },

			-- Git related searches
			{ '<leader>gc', builtin.git_commits, desc = 'Find Git Commits' },
			{ '<leader>gb', builtin.git_branches, desc = 'Find Git Branches' },
			{ '<leader>gs', builtin.git_status, desc = 'Git Status' },
			{ '<leader>gh', ':Telescope git_file_history<cr>', desc = 'Git File History' },
		}, {
			mode = 'n', -- Apply these mappings in NORMAL mode
		})

		telescope.setup({
			defaults = {
				layout_strategy = 'vertical',
				mappings = {
					i = {
						['<C-u>'] = require('telescope.actions').preview_scrolling_up,
						['<C-d>'] = require('telescope.actions').preview_scrolling_down,
					},
					n = {
						['<C-u>'] = require('telescope.actions').preview_scrolling_up,
						['<C-d>'] = require('telescope.actions').preview_scrolling_down,
					},
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = 'smart_case',
				},
				['ui-select'] = {
					require('telescope.themes').get_dropdown({
						-- even more opts
					}),
				},
			},
		})
		telescope.load_extension('fzf')
		telescope.load_extension('grapple')
		telescope.load_extension('git_file_history')
    telescope.load_extension('ui-select')
	end,
}
