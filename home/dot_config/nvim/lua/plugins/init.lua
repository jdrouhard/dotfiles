local M = {
  'EdenEast/nightfox.nvim',
  'bluz71/vim-nightfly-guicolors',
  'bluz71/vim-moonfly-colors',
  'folke/tokyonight.nvim',
  'mhartington/oceanic-next',
  'rebelot/kanagawa.nvim',

  {
    'mhinz/vim-sayonara',
    cmd = 'Sayonara',
    init = function()
      vim.keymap.set('', '<c-q>', '<cmd>Sayonara!<CR>')
    end,
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
    event = 'VeryLazy',
    config = function()
      vim.keymap.set({ 'n', 'x' }, 'ga', '<plug>(EasyAlign)', { remap = true })
    end
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
    event = 'VeryLazy',
    config = function()
      local map = vim.keymap.set
      map('n', '<leader>gg', '<cmd>Git blame<CR>')
      map('n', '<leader>gd', '<cmd>Gdiff<CR>')
    end
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
