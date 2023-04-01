local M = {
  'utilyre/barbecue.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
}

M.opts = {
  show_modified = true,
  show_dirname = false,
  theme = 'catppuccin',
}

function M.config(_, opts)
  require('barbecue').setup(opts)
  vim.o.laststatus = 3
  vim.o.winbar = '%#barbecue_basename#%t%X'
end

return M
