local M = {
  'stevearc/oil.nvim',
  event = { 'VeryLazy' },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  }
}

M.keys = {
  { '-', mode = { 'n' }, function() require('oil').open() end, desc = 'Open parent directory' },
}

M.opts = {
  keymaps = {
    ['gq'] = 'actions.close',
  },
}

return M
