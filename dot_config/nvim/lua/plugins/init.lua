local M = {
  {
    'junegunn/fzf',
    build = './install --bin',
  },

  {
    'junegunn/vim-easy-align',
    keys = { { 'ga', '<plug>(EasyAlign)', mode = { 'n', 'x' }, remap = true } },
  },

  {
    'tpope/vim-eunuch',
    cmd = { 'Delete', 'Unlink', 'Move', 'Rename', 'Mkdir' }
  },

  {
    'tpope/vim-fugitive',
    cmd = { 'G', 'Git', 'Gedit', 'Gdiff', 'Gdiffsplit', 'Gvdiff', 'Gvdiffsplit', 'Ghdiffsplit', 'GBrowse', },
    keys = {
      { '<leader>gg', '<cmd>Git blame<cr>' },
      { '<leader>gd', '<cmd>Gdiff<cr>' },
    },
  },

  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function()
      vim.g.startuptime_tries = 10
    end
  },
}

return M
