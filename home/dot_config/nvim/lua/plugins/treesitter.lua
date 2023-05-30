local M = {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  event = 'VeryLazy',
  build = ':TSUpdate',
}

M.opts = {
  ensure_installed = {
    'bash',
    'c',
    'cmake',
    'cpp',
    'javascript',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'regex',
    'rust',
    'vim',
    'yaml',
  },
  highlight = { enable = true, },
  context_commentstring = { enable = true, enable_autocmd = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-space>',
      node_incremental = '<C-space>',
      scope_incremental = '<nop>',
      node_decremental = '<bs>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
  },
}

function M.config(_, opts)
  require('nvim-treesitter.configs').setup(opts)
  vim.o.foldmethod     = 'expr'
  vim.o.foldexpr       = 'v:lua.vim.treesitter.foldexpr()'
  vim.o.foldlevel      = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable     = true
end

return M
