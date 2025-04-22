return {
	'hrsh7th/nvim-cmp',
	dependencies = {
		'L3MON4D3/LuaSnip',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'saadparwaiz1/cmp_luasnip',
		{ 'zbirenbaum/copilot-cmp', config = false }, -- We'll configure it in lsp/copilot-cmp.lua
	},
	config = function()
		local cmp = require('cmp')
		local cmp_autopairs = require('nvim-autopairs.completion.cmp')
		local luasnip = require('luasnip')

		require('copilot_cmp').setup()

		local format_kinds = {
			Text = '󰉿 Text',
			Method = '󰆧 Method',
			Function = '󰊕 Function',
			Constructor = ' Constructor',
			Field = '󰜢 Field',
			Variable = '󰀫 Variable',
			Class = '󰠱 Class',
			Interface = ' Interface',
			Module = ' Module',
			Property = '󰜢 Property',
			Unit = '󰑭 Unit',
			Value = '󰎠 Value',
			Enum = ' Enum',
			Keyword = '󰌋 Keyword',
			Snippet = ' Snippet',
			Color = '󰏘 Color',
			File = '󰈙 File',
			Reference = '󰈇 Reference',
			Folder = '󰉋 Folder',
			EnumMember = ' EnumMember',
			Constant = '󰏿 Constant',
			Struct = '󰙅 Struct',
			Event = ' Event',
			Operator = '󰆕 Operator',
			TypeParameter = '󰊄 TypeParam',
			Copilot = ' Copilot',
		}

		cmp.setup({
			sources = {
				{ name = 'copilot', group_index = 1 },
				{ name = 'nvim_lsp', group_index = 1 },
				{ name = 'path', group_index = 2 },
				{ name = 'luasnip', keyword_length = 2, group_index = 2 },
				{ name = 'buffer', keyword_length = 3, group_index = 3 },
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<CR>'] = cmp.mapping.confirm({
					select = false,
				}),
				['<C-d>'] = cmp.mapping.scroll_docs(-4),
				['<C-u>'] = cmp.mapping.scroll_docs(4),
				['<C-e>'] = cmp.mapping.abort(),
				['<Tab>'] = function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end,
				['<S-Tab>'] = function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end,
			}),
			formatting = {
				format = function(entry, vim_item)
					-- Set the kind icon
					vim_item.kind = format_kinds[vim_item.kind] or vim_item.kind

					-- Set the source name
					vim_item.menu = ({
						copilot = '[Copilot]',
						nvim_lsp = '[LSP]',
						luasnip = '[Snippet]',
						buffer = '[Buffer]',
						path = '[Path]',
					})[entry.source.name]

					return vim_item
				end,
			},
			sorting = {
				priority_weight = 2,
				comparators = {
					-- Below is the default comparator list and order for nvim-cmp
					cmp.config.compare.offset,
					-- cmp.config.compare.scopes, -- this is commented in nvim-cmp too
					cmp.config.compare.exact,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.locality,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
		})

		cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
	end,
}
