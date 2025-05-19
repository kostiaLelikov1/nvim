local M = {}

M.optimize_startup = function()
	local disabled_built_ins = {
		'netrw',
		'netrwPlugin',
		'netrwSettings',
		'netrwFileHandlers',
		'gzip',
		'zip',
		'zipPlugin',
		'tar',
		'tarPlugin',
		'getscript',
		'getscriptPlugin',
		'vimball',
		'vimballPlugin',
		'2html_plugin',
		'logipat',
		'rrhelper',
		'spellfile_plugin',
		'matchit',
	}

	for _, plugin in pairs(disabled_built_ins) do
		vim.g['loaded_' .. plugin] = 1
	end

	vim.opt.lazyredraw = true

	vim.opt.synmaxcol = 240

	vim.opt.updatetime = 100

	vim.opt.ttyfast = true
end

M.optimize_runtime = function()
	if pcall(require, 'nvim-treesitter') then
		vim.opt.foldmethod = 'expr'
		vim.opt.foldexpr = 'nvim-treesitter#foldexpr()'
	end

	vim.opt.ttimeoutlen = 10

	vim.opt.lazyredraw = true

	vim.g.macro_performance = true
end

-- Apply all optimizations
M.apply_all = function()
	M.optimize_startup()
	M.optimize_runtime()
end

return M
