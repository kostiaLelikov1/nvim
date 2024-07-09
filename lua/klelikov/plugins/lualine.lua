return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons', 'f-person/git-blame.nvim', 'will-lynas/grapple-line.nvim' },
	config = function()
		local git_blame = require('gitblame')
		local grapple_line = require('grapple-line')
		vim.g.gitblame_display_virtual_text = 0
		vim.g.gitblame_message_template = '<summary> • <date> • <author>'
		vim.g.gitblame_date_format = '%Y-%m-%d'

		local function get_unique_bufnames()
			local tab_buffers = {}
			local unique_names = {}
			local name_to_paths = {}

			-- Collect buffers for each tab
			for i = 1, vim.fn.tabpagenr('$') do
				tab_buffers[i] = vim.fn.tabpagebuflist(i)
			end

			-- Initialize name_to_paths to keep track of all paths for each basename
			for _, buflist in pairs(tab_buffers) do
				for _, buf in ipairs(buflist) do
					local bufname = vim.fn.bufname(buf)
					local basename = vim.fn.fnamemodify(bufname, ':t')
					if not name_to_paths[basename] then
						name_to_paths[basename] = {}
					end
					table.insert(name_to_paths[basename], bufname)
				end
			end

			-- Function to find the unique path suffix
			local function get_suffix(bufname, other_bufnames)
				local path_parts = vim.split(bufname, '/', { plain = true })
				local suffix_length = 1
				local unique_suffix = path_parts[#path_parts]

				while true do
					local is_unique = true
					if #path_parts < suffix_length then
						break
					end
					unique_suffix = table.concat(path_parts, '/', #path_parts - suffix_length + 1)
					for _, other_bufname in ipairs(other_bufnames) do
						if other_bufname ~= bufname then
							local other_path_parts = vim.split(other_bufname, '/', { plain = true })
							if #other_path_parts < suffix_length then
								break
							end
							local other_suffix = table.concat(other_path_parts, '/', #other_path_parts - suffix_length + 1)
							if unique_suffix == other_suffix then
								is_unique = false
								break
							end
						end
					end
					if is_unique then
						break
					end
					suffix_length = suffix_length + 1
					if suffix_length > #path_parts then
						unique_suffix = bufname
						break
					end
				end

				return unique_suffix
			end

			-- Determine unique suffix for each buffer
			for basename, bufname_list in pairs(name_to_paths) do
				local suffixes = {}
				for _, bufname in ipairs(bufname_list) do
					suffixes[bufname] = get_suffix(bufname, bufname_list)
				end
				for bufname, suffix in pairs(suffixes) do
					unique_names[bufname] = suffix
				end
			end

			return unique_names
		end

		local function tab_list()
			local tabline = ''
			local unique_bufnames = get_unique_bufnames()

			for i = 1, vim.fn.tabpagenr('$') do
				local buflist = vim.fn.tabpagebuflist(i)
				local last_buf = buflist[#buflist]
				local last_bufname = unique_bufnames[vim.fn.bufname(last_buf)]
				local current_tab = vim.fn.tabpagenr()
				if i == current_tab then
					tabline = tabline
						.. '%#TabLineSel# '
						.. i
						.. '('
						.. (last_bufname ~= '' and last_bufname or '[No name]')
						.. ') %#TabLine#'
				else
					tabline = tabline .. ' ' .. i .. '(' .. (last_bufname ~= '' and last_bufname or '[No name]') .. ') '
				end
			end

			return tabline
		end

		require('lualine').setup({
			options = {
				theme = 'catppuccin',
				component_separators = '',
				section_separators = { left = '', right = '' },
        globalstatus = true,
			},
			tabline = {
				lualine_a = {
					{
						function()
							local status, tabline = pcall(tab_list)
							if status then
								return tabline
							else
								return 'Tabline error' .. tabline.code
							end
						end,
						separator = '',
					},
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {
					{ git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
				},
				lualine_z = {},
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'branch', 'diff', 'diagnostics' },
				lualine_c = { grapple_line.status },
				lualine_x = {},
				lualine_y = {
					{
						function()
							local unsaved = 0
							for _, buf in ipairs(vim.api.nvim_list_bufs()) do
								if vim.api.nvim_buf_get_option(buf, 'modified') then
									unsaved = unsaved + 1
								end
							end
							local readonly = vim.bo.readonly and ' ' or ''
							return 'unsaved ' .. unsaved .. readonly
						end,
					},
				},
				lualine_z = { 'location' },
			},
		})
	end,
}
