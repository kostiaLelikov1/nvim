return {
  'rcarriga/nvim-notify',
  config = function()
    vim.notify = require('notify')
    vim.notify.setup({
      stages = 'slide',
      timeout = 3000,
      background_colour = '#1e222a',
    })
  end,
}
