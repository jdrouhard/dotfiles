local M = {
  {
    'mhinz/vim-sayonara',
    keys = { { '<c-q>', '<cmd>Sayonara!<cr>', mode = '' } },
  },

  {
    'junegunn/fzf',
    build = function() vim.fn['fzf#install']() end,
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
    lazy = false,
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
