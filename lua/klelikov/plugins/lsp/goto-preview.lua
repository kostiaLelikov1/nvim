return {
	'rmagatti/goto-preview',
	config = function()
		local goto_preview = require('goto-preview')
		goto_preview.setup({
			width = 120,
			height = 30,
			default_mappings = false,
			border = 'single',
		})

		local keymap = vim.keymap

		keymap.set('n', 'gpd', goto_preview.goto_preview_definition, { desc = 'Goto Preview Definition' })
		keymap.set('n', 'gpD', goto_preview.goto_preview_declaration, { desc = 'Goto Preview Declaration' })
		keymap.set('n', 'gpo', goto_preview.goto_preview_type_definition, { desc = 'Goto Preview Implementation' })
		keymap.set('n', 'gpi', goto_preview.goto_preview_implementation, { desc = 'Goto Preview Implementation' })
		keymap.set('n', 'gP', goto_preview.close_all_win, { desc = 'Close all Goto Preview windows' })
		keymap.set('n', 'gpr', goto_preview.goto_preview_references, { desc = 'Goto Preview References' })
	end,
}
