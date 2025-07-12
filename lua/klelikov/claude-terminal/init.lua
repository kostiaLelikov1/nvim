local M = {}

-- Terminal state
local claude_term_buf = nil
local claude_term_win = nil
local claude_job_id = nil

function M.setup()
	-- Create commands
	vim.api.nvim_create_user_command('ClaudeOpen', M.open_claude_terminal, {})
	vim.api.nvim_create_user_command('ClaudeToggle', M.toggle_claude_terminal, {})
	vim.api.nvim_create_user_command('ClaudeClose', M.close_claude_terminal, {})
end

-- Check if Claude terminal exists and is visible
local function is_claude_visible()
	return claude_term_win
		and vim.api.nvim_win_is_valid(claude_term_win)
		and claude_term_buf
		and vim.api.nvim_buf_is_valid(claude_term_buf)
		and vim.api.nvim_win_get_buf(claude_term_win) == claude_term_buf
end

-- Find Claude window if it exists
local function find_claude_window()
	if not claude_term_buf or not vim.api.nvim_buf_is_valid(claude_term_buf) then
		return nil
	end

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == claude_term_buf then
			return win
		end
	end
	return nil
end

-- Open Claude terminal
function M.open_claude_terminal()
	-- If already visible, just focus it
	if is_claude_visible() then
		vim.api.nvim_set_current_win(claude_term_win)
		vim.cmd('startinsert')
		return
	end

	-- Update window reference if buffer exists in another window
	local existing_win = find_claude_window()
	if existing_win then
		claude_term_win = existing_win
		vim.api.nvim_set_current_win(claude_term_win)
		vim.cmd('startinsert')
		return
	end

	-- If buffer exists but no window, create window
	if claude_term_buf and vim.api.nvim_buf_is_valid(claude_term_buf) then
		-- Save current window

		-- Create split and set buffer
		vim.cmd('vsplit')
		vim.cmd('wincmd l')
		vim.api.nvim_win_set_buf(0, claude_term_buf)
		claude_term_win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_width(claude_term_win, math.floor(vim.o.columns * 0.4))
		vim.cmd('startinsert')
		return
	end

	-- Create completely new terminal
	-- Save current window first

	-- Create split
	vim.cmd('vsplit')
	vim.cmd('wincmd l')

	-- Set width before creating terminal
	vim.api.nvim_win_set_width(0, math.floor(vim.o.columns * 0.4))

	-- Create new buffer and start terminal
	claude_term_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, claude_term_buf)
	claude_term_win = vim.api.nvim_get_current_win()

	-- Start claude in this buffer
	claude_job_id = vim.fn.termopen('claude', {
		on_exit = function()
			claude_job_id = nil
		end,
	})

	-- Set buffer name
	vim.api.nvim_buf_set_name(claude_term_buf, 'Claude Terminal')

	-- Set up keymaps
	local opts = { buffer = claude_term_buf, noremap = true, silent = true }
	vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', opts)
	-- Leader keymaps only work in normal mode to avoid delays when typing space in terminal
	vim.keymap.set('n', '<leader>at', function()
		M.toggle_claude_terminal()
	end, opts)
	vim.keymap.set('n', '<leader>ac', function()
		M.close_claude_terminal()
	end, opts)

	vim.cmd('startinsert')
end

-- Toggle Claude terminal visibility
function M.toggle_claude_terminal()
	-- If visible, hide it
	if is_claude_visible() then
		vim.api.nvim_win_close(claude_term_win, false)
		claude_term_win = nil
		return
	end

	-- If not visible, open it
	M.open_claude_terminal()
end

-- Close Claude terminal completely
function M.close_claude_terminal()
	-- Kill the claude process if it's running
	if claude_job_id then
		vim.fn.jobstop(claude_job_id)
		claude_job_id = nil
	end

	-- Find and close any windows with this buffer
	if claude_term_buf and vim.api.nvim_buf_is_valid(claude_term_buf) then
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == claude_term_buf then
				vim.api.nvim_win_close(win, false)
			end
		end

		-- Delete the buffer
		vim.api.nvim_buf_delete(claude_term_buf, { force = true })
	end

	-- Reset all references
	claude_term_buf = nil
	claude_term_win = nil

	vim.notify('Claude terminal closed')
end

return M
