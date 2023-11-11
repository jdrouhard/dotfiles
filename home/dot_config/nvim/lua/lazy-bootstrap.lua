local fn = vim.fn

local lazy_repo = 'https://github.com/folke/lazy.nvim.git'
local install_path = fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(install_path) then
  vim.notify('Installing lazy.nvim')
  vim.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    lazy_repo,
    install_path
  }, { text = true }):wait()
end
vim.opt.runtimepath:prepend(install_path)

local ViewConfig = require('lazy.view.config')
ViewConfig.keys.profile_filter = '<M-f>'
ViewConfig.keys.profile_sort = '<M-s>'

require('lazy').setup('plugins', {
  defaults = { lazy = true },
  install = { colorscheme = { 'tokyonight', 'habamax' } },
  --checker = { enabled = true },
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
