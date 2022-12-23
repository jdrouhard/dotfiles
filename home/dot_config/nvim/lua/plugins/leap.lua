local M = {
  'ggandor/leap.nvim',
  event = 'VeryLazy',
  dependencies = {
    'tpope/vim-repeat',
    'ggandor/flit.nvim',
    'ggandor/leap-ast.nvim',
  }
}

function M.config()
  require('leap').set_default_keymaps()
  require('flit').setup({
    labeled_modes = 'nv',
  })
  vim.keymap.set({ 'n', 'x', 'o' }, 'M', function()
    require('leap-ast').leap()
  end, {})
end

return M
