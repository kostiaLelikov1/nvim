local M = {}
local Job = require('plenary.job')
local Popup = require('nui.popup')
local Input = require('nui.input')
local Layout = require('nui.layout')

-- State management
local state = {
	search_term = '',
	replace_term = '',
	matches = {},
	current_match = 1,
	scope = 'project', -- 'file' or 'project'
	preview_buf = nil,
	preview_win = nil,
	results_buf = nil,
	results_win = nil,
	layout = nil,
}

function M.setup()
	-- Create commands
	vim.api.nvim_create_user_command('FindReplaceFile', function()
		M.start_find_replace('file')
	end, {})
	vim.api.nvim_create_user_command('FindReplaceProject', function()
		M.start_find_replace('project')
	end, {})
	vim.api.nvim_create_user_command('FindReplaceWord', M.find_replace_word, {})
	vim.api.nvim_create_user_command('FindReplaceSelection', M.find_replace_selection, { range = true })
end

-- Get selected text
local function get_visual_selection()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.fn.getline(start_pos[2], end_pos[2])

	if #lines == 0 then
		return ''
	end

	-- Handle single line selection
	if #lines == 1 then
		return string.sub(lines[1], start_pos[3], end_pos[3])
	end

	-- Handle multi-line selection
	lines[1] = string.sub(lines[1], start_pos[3])
	lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])

	return table.concat(lines, '\n')
end

-- Find matches using ripgrep (asynchronous)
local function find_matches(search_term, scope, callback)
	local matches = {}

	-- Validate search term
	if not search_term or search_term == '' then
		callback({})
		return
	end

	local args = {
		'--json',
		'--smart-case',
		'--no-heading',
		'--line-number',
		'--column',
		'--max-count=500', -- Limit results to prevent huge searches
	}

	if scope == 'file' then
		-- For file scope, only search the current file
		table.insert(args, '--')
		table.insert(args, search_term)
		table.insert(args, vim.fn.expand('%:p'))
	else
		-- For project scope, use ripgrep's built-in ignore functionality
		-- Add separator and search term
		table.insert(args, '--')
		table.insert(args, search_term)
		table.insert(args, '.')
	end

	local job = Job:new({
		command = 'rg',
		args = args,
		timeout = 10000, -- 10 second timeout
		on_exit = function(j, return_val)
			vim.schedule(function()
				local results = j:result()

				if return_val == 0 or return_val == 1 then -- 0 = matches found, 1 = no matches
					for _, line in ipairs(results) do
						local ok, data = pcall(vim.fn.json_decode, line)
						if ok and data.type == 'match' then
							table.insert(matches, {
								file = data.data.path.text,
								line_number = data.data.line_number,
								column = data.data.submatches[1].start + 1,
								line_text = data.data.lines.text,
								match_text = data.data.submatches[1].match.text,
								applied = false,
								rejected = false,
								original_line = data.data.lines.text, -- Store original line for undo
							})
						end
					end
				end

				callback(matches)
			end)
		end,
	})

	job:start()
end

-- Create the find and replace UI
local function create_ui()
	-- Create buffers
	state.results_buf = vim.api.nvim_create_buf(false, true)
	state.preview_buf = vim.api.nvim_create_buf(false, true)

	-- Set buffer options
	vim.api.nvim_buf_set_option(state.results_buf, 'filetype', 'findreplace-results')
	vim.api.nvim_buf_set_option(state.preview_buf, 'filetype', 'diff')
	vim.api.nvim_buf_set_option(state.preview_buf, 'modifiable', false)

	-- Create full-screen popup using Layout
	local results_popup = Popup({
		border = {
			style = 'rounded',
			text = {
				top = ' Find & Replace Results ',
				top_align = 'center',
			},
		},
		buf_options = {
			modifiable = true,
			readonly = false,
		},
	})

	local preview_popup = Popup({
		border = {
			style = 'rounded',
			text = {
				top = ' Preview ',
				top_align = 'center',
			},
		},
		buf_options = {
			modifiable = true,
			readonly = false,
		},
	})

	-- Create full-screen layout
	state.layout = Layout(
		{
			position = '50%',
			size = {
				width = '95%',
				height = '90%',
			},
			relative = 'editor',
		},
		Layout.Box({
			Layout.Box(results_popup, { size = '40%' }),
			Layout.Box(preview_popup, { size = '60%' }),
		}, { dir = 'row' })
	)

	-- Mount the layout
	state.layout:mount()

	-- Get window references and set buffers
	state.results_win = results_popup.winid
	state.preview_win = preview_popup.winid

	-- Set the buffers in the windows
	vim.api.nvim_win_set_buf(state.results_win, state.results_buf)
	vim.api.nvim_win_set_buf(state.preview_win, state.preview_buf)

	-- Set up keymaps for results window
	local opts = { buffer = state.results_buf, noremap = true, silent = true }

	-- Navigation
	vim.keymap.set('n', 'j', function()
		M.next_match()
	end, opts)
	vim.keymap.set('n', 'k', function()
		M.prev_match()
	end, opts)
	vim.keymap.set('n', '<Down>', function()
		M.next_match()
	end, opts)
	vim.keymap.set('n', '<Up>', function()
		M.prev_match()
	end, opts)

	-- Actions
	vim.keymap.set('n', '<CR>', function()
		M.apply_current()
	end, opts)
	vim.keymap.set('n', 'a', function()
		M.apply_current()
	end, opts)
	vim.keymap.set('n', 'r', function()
		M.reject_current()
	end, opts)
	vim.keymap.set('n', 'A', function()
		M.apply_all()
	end, opts)
	vim.keymap.set('n', 'R', function()
		M.reject_all()
	end, opts)
	vim.keymap.set('n', 'u', function()
		M.undo_current()
	end, opts)

	-- Close
	vim.keymap.set('n', 'q', function()
		M.close_ui()
	end, opts)
	vim.keymap.set('n', '<Esc>', function()
		M.close_ui()
	end, opts)

	-- Focus results window (deferred to ensure proper setup)
	vim.schedule(function()
		if state.results_win and vim.api.nvim_win_is_valid(state.results_win) then
			vim.api.nvim_set_current_win(state.results_win)
		end
	end)
end

-- Update results display
local function update_results_display()
	if not state.results_buf or not vim.api.nvim_buf_is_valid(state.results_buf) then
		return
	end

	local lines = {}
	local header =
		string.format('Find & Replace: "%s" → "%s" (%d matches)', state.search_term, state.replace_term, #state.matches)

	table.insert(lines, header)
	table.insert(lines, string.rep('─', #header))
	table.insert(lines, '')

	-- Keybind help
	table.insert(lines, 'Keybinds: ↕️ j/k  ✅ a/Enter  ❌ r  🔄 u  📁 A(ll)  🗑️ R(eject all)  🚪 q/Esc')
	table.insert(lines, '')

	for i, match in ipairs(state.matches) do
		local prefix = '  '
		local status = ''
		local icon = '📄'

		if i == state.current_match then
			prefix = '▶ '
			icon = '👉'
		end

		if match.applied then
			status = ' ✅'
			icon = '✅'
		elseif match.rejected then
			status = ' ❌'
			icon = '❌'
		end

		-- Highlight the matched text in the line
		local line_preview = match.line_text:gsub('%s+', ' ')
		local before = line_preview:sub(1, match.column - 1)
		local matched_text = line_preview:sub(match.column, match.column + #state.search_term - 1)
		local after = line_preview:sub(match.column + #state.search_term)

		local highlighted_line = before .. '【' .. matched_text .. '】' .. after

		local line = string.format(
			'%s%s %s:%d:%d │ %s%s',
			prefix,
			icon,
			vim.fn.fnamemodify(match.file, ':~:.'),
			match.line_number,
			match.column,
			highlighted_line,
			status
		)

		table.insert(lines, line)
	end

	vim.api.nvim_buf_set_option(state.results_buf, 'modifiable', true)
	vim.api.nvim_buf_set_lines(state.results_buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(state.results_buf, 'modifiable', false)

	-- Position cursor on current match (deferred to ensure window is ready)
	if
		state.current_match > 0
		and state.current_match <= #state.matches
		and state.results_win
		and vim.api.nvim_win_is_valid(state.results_win)
	then
		vim.schedule(function()
			local cursor_line = 5 + state.current_match -- Account for header lines
			local total_lines = vim.api.nvim_buf_line_count(state.results_buf)

			-- Ensure cursor line is within buffer bounds and greater than 0
			if cursor_line > 0 and cursor_line <= total_lines and vim.api.nvim_win_is_valid(state.results_win) then
				local success = pcall(vim.api.nvim_win_set_cursor, state.results_win, { cursor_line, 0 })
				if not success then
					-- If cursor positioning fails, just go to first line - it's not critical
					pcall(vim.api.nvim_win_set_cursor, state.results_win, { 1, 0 })
				end
			end
		end)
	end
end

-- Update preview display with proper diff format
local function update_preview_display()
	if not state.preview_buf or not vim.api.nvim_buf_is_valid(state.preview_buf) then
		return
	end

	if #state.matches == 0 or state.current_match < 1 or state.current_match > #state.matches then
		vim.api.nvim_buf_set_option(state.preview_buf, 'modifiable', true)
		vim.api.nvim_buf_set_lines(state.preview_buf, 0, -1, false, { 'No match selected' })
		vim.api.nvim_buf_set_option(state.preview_buf, 'modifiable', false)
		return
	end

	local match = state.matches[state.current_match]
	local lines = {}

	-- Read file content around the match
	local file_lines = vim.fn.readfile(match.file)
	local start_line = math.max(1, match.line_number - 5)
	local end_line = math.min(#file_lines, match.line_number + 5)

	-- Get file extension for syntax highlighting
	local file_ext = vim.fn.fnamemodify(match.file, ':e')
	local filetype = vim.filetype.match({ filename = match.file }) or file_ext

	-- Add diff header
	table.insert(lines, string.format('--- a/%s', vim.fn.fnamemodify(match.file, ':~:.')))
	table.insert(lines, string.format('+++ b/%s', vim.fn.fnamemodify(match.file, ':~:.')))
	table.insert(lines, string.format('@@ -%d,7 +%d,7 @@', match.line_number, match.line_number))
	table.insert(lines, '')

	-- Add context and diff lines
	for i = start_line, end_line do
		local line_content = file_lines[i] or ''

		if i == match.line_number then
			-- Show the original line (to be removed)
			table.insert(lines, string.format('-%s', line_content))

			-- Show the replacement line (to be added)
			local before = line_content:sub(1, match.column - 1)
			local after = line_content:sub(match.column + #state.search_term)
			local new_line = before .. state.replace_term .. after
			table.insert(lines, string.format('+%s', new_line))
		else
			-- Context lines
			table.insert(lines, string.format(' %s', line_content))
		end
	end

	-- Add separator and file info
	table.insert(lines, '')
	table.insert(lines, string.format('File: %s:%d:%d', match.file, match.line_number, match.column))
	table.insert(lines, string.format('Replace: "%s" → "%s"', state.search_term, state.replace_term))
	if match.applied then
		table.insert(lines, 'Status: ✅ Applied')
	elseif match.rejected then
		table.insert(lines, 'Status: ❌ Rejected')
	else
		table.insert(lines, 'Status: ⏳ Pending')
	end

	vim.api.nvim_buf_set_option(state.preview_buf, 'modifiable', true)
	vim.api.nvim_buf_set_lines(state.preview_buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(state.preview_buf, 'modifiable', false)

	-- Set proper filetype for syntax highlighting in preview
	if filetype and filetype ~= '' then
		vim.api.nvim_buf_set_option(state.preview_buf, 'filetype', 'diff')
	end
end

-- Navigation functions
function M.next_match()
	if state.current_match < #state.matches then
		state.current_match = state.current_match + 1
		update_results_display()
		update_preview_display()
	end
end

function M.prev_match()
	if state.current_match > 1 then
		state.current_match = state.current_match - 1
		update_results_display()
		update_preview_display()
	end
end

-- Apply/reject functions
function M.apply_current()
	if state.current_match > 0 and state.current_match <= #state.matches then
		local match = state.matches[state.current_match]
		if not match.applied and not match.rejected then
			-- Apply the replacement
			local file_lines = vim.fn.readfile(match.file)
			local line = file_lines[match.line_number]
			local before = line:sub(1, match.column - 1)
			local after = line:sub(match.column + #state.search_term)
			file_lines[match.line_number] = before .. state.replace_term .. after

			-- Write back to file
			vim.fn.writefile(file_lines, match.file)

			match.applied = true
		end

		update_results_display()
		M.next_match()
	end
end

function M.reject_current()
	if state.current_match > 0 and state.current_match <= #state.matches then
		local match = state.matches[state.current_match]
		match.rejected = true
		update_results_display()
		M.next_match()
	end
end

function M.undo_current()
	if state.current_match > 0 and state.current_match <= #state.matches then
		local match = state.matches[state.current_match]

		-- Only undo if it was previously applied
		if match.applied then
			-- Read the file and restore the original line
			local file_lines = vim.fn.readfile(match.file)
			file_lines[match.line_number] = match.original_line

			-- Write back to file
			vim.fn.writefile(file_lines, match.file)
		end

		-- Reset the state
		match.applied = false
		match.rejected = false
		update_results_display()
		update_preview_display()
	end
end

function M.apply_all()
	for _, match in ipairs(state.matches) do
		if not match.applied and not match.rejected then
			-- Apply the replacement
			local file_lines = vim.fn.readfile(match.file)
			local line = file_lines[match.line_number]
			local before = line:sub(1, match.column - 1)
			local after = line:sub(match.column + #state.search_term)
			file_lines[match.line_number] = before .. state.replace_term .. after

			-- Write back to file
			vim.fn.writefile(file_lines, match.file)
			match.applied = true
		end
	end

	update_results_display()
end

function M.reject_all()
	for _, match in ipairs(state.matches) do
		if not match.applied then
			match.rejected = true
		end
	end

	update_results_display()
end

-- Close UI
function M.close_ui()
	-- Unmount layout if it exists
	if state.layout then
		state.layout:unmount()
	end

	-- Reset state
	state.matches = {}
	state.current_match = 1
	state.results_buf = nil
	state.results_win = nil
	state.preview_buf = nil
	state.preview_win = nil
	state.layout = nil
end

-- Start find and replace with input
function M.start_find_replace(scope)
	state.scope = scope

	-- Get search term input
	local search_input = Input({
		position = '50%',
		size = { width = 60, height = 1 },
		border = {
			style = 'rounded',
			text = { top = ' Find ', top_align = 'center' },
		},
	}, {
		prompt = '🔍 Search: ',
		default_value = '', -- Always start with empty value
		on_submit = function(search_term)
			if search_term and search_term ~= '' then
				state.search_term = search_term

				-- Get replace term input
				local replace_input = Input({
					position = '50%',
					size = { width = 60, height = 1 },
					border = {
						style = 'rounded',
						text = { top = ' Replace ', top_align = 'center' },
					},
				}, {
					prompt = '🔄 Replace: ',
					default_value = '', -- Always start with empty value
					on_submit = function(replace_term)
						if replace_term ~= nil then -- Allow empty replacement
							state.replace_term = replace_term
							M.execute_find_replace()
						end
					end,
				})

				replace_input:mount()
				-- Enter insert mode after mounting
				vim.schedule(function()
					vim.cmd('startinsert')
				end)
			end
		end,
	})

	search_input:mount()
	-- Enter insert mode after mounting
	vim.schedule(function()
		vim.cmd('startinsert')
	end)
end

-- Find and replace word under cursor
function M.find_replace_word()
	local word = vim.fn.expand('<cword>')
	if word == '' then
		vim.notify('No word under cursor', vim.log.levels.WARN)
		return
	end

	state.search_term = word
	state.scope = 'project'

	-- Get replace term input
	local replace_input = Input({
		position = '50%',
		size = { width = 60, height = 1 },
		border = {
			style = 'rounded',
			text = { top = ' Replace "' .. word .. '" ', top_align = 'center' },
		},
	}, {
		prompt = '🔄 Replace with: ',
		default_value = '', -- Always start with empty value
		on_submit = function(replace_term)
			if replace_term ~= nil then
				state.replace_term = replace_term
				M.execute_find_replace()
			end
		end,
	})

	replace_input:mount()
	-- Enter insert mode after mounting
	vim.schedule(function()
		vim.cmd('startinsert')
	end)
end

-- Find and replace selection
function M.find_replace_selection()
	local selection = get_visual_selection()
	if selection == '' then
		vim.notify('No text selected', vim.log.levels.WARN)
		return
	end

	state.search_term = selection
	state.scope = 'project'

	-- Get replace term input
	local replace_input = Input({
		position = '50%',
		size = { width = 60, height = 1 },
		border = {
			style = 'rounded',
			text = { top = ' Replace Selection ', top_align = 'center' },
		},
	}, {
		prompt = '🔄 Replace with: ',
		default_value = '', -- Always start with empty value
		on_submit = function(replace_term)
			if replace_term ~= nil then
				state.replace_term = replace_term
				M.execute_find_replace()
			end
		end,
	})

	replace_input:mount()
	-- Enter insert mode after mounting
	vim.schedule(function()
		vim.cmd('startinsert')
	end)
end

-- Execute the find and replace
function M.execute_find_replace()
	-- Find matches asynchronously
	find_matches(state.search_term, state.scope, function(matches)
		state.matches = matches
		state.current_match = 1

		if #state.matches == 0 then
			return
		end

		-- Create and show UI
		create_ui()
		update_results_display()
		update_preview_display()
	end)
end

return M
