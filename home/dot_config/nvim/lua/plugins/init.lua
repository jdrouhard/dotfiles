local M = {
  'EdenEast/nightfox.nvim',
  'bluz71/vim-nightfly-guicolors',
  'bluz71/vim-moonfly-colors',
  'folke/tokyonight.nvim',
  'mhartington/oceanic-next',
  'rebelot/kanagawa.nvim',

  'kosayoda/nvim-lightbulb',
  'folke/neodev.nvim',

  {
    'mhinz/vim-sayonara',
    keys = { { '<c-q>', '<cmd>Sayonara!<cr>', mode = '' } },
  },

  {
    'nvim-lua/plenary.nvim',
    config = function()
      require('plenary.filetype').add_file('overrides')
    end
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
    'justinmk/vim-dirvish',
    lazy = false,
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
