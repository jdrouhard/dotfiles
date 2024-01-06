local M = {
  'ggandor/leap.nvim',
  keys = { 's', 'S', 'f', 'F', 't', 'T', },
  dependencies = {
    'tpope/vim-repeat',
    'ggandor/flit.nvim',
  }
}

function M.config()
  require('leap').set_default_keymaps()
  require('flit').setup({
    labeled_modes = 'nv',
  })
end

return M
