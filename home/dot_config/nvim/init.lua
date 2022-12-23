require('options')
require('lazy-bootstrap')
require('theme').setup()

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('commands')
    require('mappings')
  end,
})
