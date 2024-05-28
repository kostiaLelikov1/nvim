return {
  'folke/neodev.nvim',
  dependecies = {
    'VonHeikemen/lsp-zero.nvim',
  },
  config = function()
    require('neodev').setup()
  end
}
