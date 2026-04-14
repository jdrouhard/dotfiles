vim.pack.add({'https://github.com/folke/lazy.nvim'})

local ViewConfig = require('lazy.view.config')
ViewConfig.keys.profile_filter = '<M-f>'
ViewConfig.keys.profile_sort = '<M-s>'

require('lazy').setup('plugins', {
  defaults = { lazy = true },
  install = { colorscheme = { 'tokyonight', 'habamax' } },
  --checker = { enabled = true },
  dev = { path = '~/source', },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
