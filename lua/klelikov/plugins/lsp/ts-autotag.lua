return {
	'windwp/nvim-ts-autotag',
	ft = { 'html', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte', 'vue', 'astro' },
	config = function()
		require('nvim-ts-autotag').setup()
	end,
}
