local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=ssomething',
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{ import = 'klelikov.plugins.lsp' },
	{ import = 'klelikov.plugins.ui' },
	{ import = 'klelikov.plugins.editing' },
	{ import = 'klelikov.plugins.navigation' },
	{ import = 'klelikov.plugins.git' },
	{ import = 'klelikov.plugins.tools' },
}, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
