local M = {
  'utilyre/barbecue.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
}

M.opts = {
  create_autocmd = false,
  show_modified = true,
  show_dirname = false,
}

function M.config(_, opts)
  require('barbecue').setup(opts)
  vim.o.laststatus = 3
  vim.o.winbar = '%#barbecue_basename#%t%X'

  vim.api.nvim_create_autocmd({
    'WinResized',
    'BufWinEnter',
    'CursorHold',
    'InsertLeave',
    'BufModifiedSet',
  }, {
    group = vim.api.nvim_create_augroup('barbecue.updater', {}),
    callback = function()
      require('barbecue.ui').update()
    end,
  })
end

return M
