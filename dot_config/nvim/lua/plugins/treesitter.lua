local M = {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  event = { 'VeryLazy', 'BufReadPost', 'BufWritePost', 'BufNewFile' },
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
    'vimdoc',
    'yaml',
  },
  highlight = { enable = false, },
  --context_commentstring = { enable = false, enable_autocmd = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-space>',
      node_incremental = '<C-space>',
      node_decremental = '<bs>',
      scope_incremental = false,
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
  local configs = require('nvim-treesitter.configs')
  configs.setup(opts)

  local config_mod = configs.get_module('highlight')
  if not config_mod then
    return
  end

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup("Nvim-Treesitter-highlight", {}),
    callback = function(ev)
      vim.schedule(function()
        configs.reattach_module('highlight', ev.buf, ev.match)
      end)
    end,
    desc = "attach nvim-treesitter-highlight"
  })

  config_mod.enable = true
  config_mod.enabled_buffers = nil
end

return M
