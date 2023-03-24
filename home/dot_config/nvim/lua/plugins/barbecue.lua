local M = {
  'utilyre/barbecue.nvim',
  lazy = false,
  branch = 'fix/E36',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
}

function M.config()
  require('barbecue').setup({
    show_modified = true,
    show_dirname = false,
  })
  vim.o.laststatus = 3
  vim.o.winbar = '%#barbecue_basename#%t%X'
end

return M
