local M = {
  'utilyre/barbecue.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'nvim-tree/nvim-web-devicons',

    {
      'SmiteshP/nvim-navic',
      opts = { lazy_update_context = true, },
    },
  },
}

M.opts = {
  create_autocmd = false,
  show_modified = true,
  show_dirname = false,
  theme = {
    basename = { bold = true },
  },
}

function M.config(_, opts)
  local api = vim.api

  require('barbecue').setup(opts)
  vim.o.laststatus = 3
  vim.o.winbar = '%#barbecue_basename#%t%X'

  local group = api.nvim_create_augroup('barbecue.updater', {})

  api.nvim_create_autocmd({
    'WinResized',
    'BufWinEnter',
    'CursorHold',
    'InsertLeave',
    'BufModifiedSet',
  }, {
    group = group,
    callback = function()
      require('barbecue.ui').update()
    end,
  })
end

return M
