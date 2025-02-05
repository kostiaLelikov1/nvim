return {
	'yetone/avante.nvim',
	event = 'VeryLazy',
	lazy = false,
	version = false,
	opts = {
		provider = 'ollama',
		claude = {
			endpoint = 'https://api.anthropic.com',
			model = 'claude-3-5-sonnet-20241022',
			temperature = 0,
			max_tokens = 4096,
		},
		vendors = {
			ollama = {
				__inherited_from = 'openai',
				api_key_name = '',
				endpoint = 'http://127.0.0.1:8080/v1',
				model = 'deepseek-r1',
			},
		},
		dual_boost = {
			enabled = false,
			first_provider = 'claude',
			second_provider = 'ollama',
			prompt = 'Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]',
			timeout = 60000,
		},
	},
	build = 'make',
	dependencies = {
		'stevearc/dressing.nvim',
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim',
		'nvim-telescope/telescope.nvim',
		'hrsh7th/nvim-cmp',
		'nvim-tree/nvim-web-devicons',
		{

			'HakonHarnes/img-clip.nvim',
			event = 'VeryLazy',
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					use_absolute_path = true,
				},
			},
		},
		{
			'MeanderingProgrammer/render-markdown.nvim',
			opts = {
				file_types = { 'markdown', 'Avante' },
			},
			ft = { 'markdown', 'Avante' },
		},
	},
}
