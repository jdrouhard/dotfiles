local M = {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async',
  },
  event = 'VeryLazy',
}

M.opts = {
  preview = {
    mappings = {
      scrollB = '<C-b>',
      scrollF = '<C-f>',
      scrollU = '<C-u>',
      scrollD = '<C-d>',
    },
  },
  --provider_selector = function(_, filetype, buftype)
  --  local function handle_fallback_exception(bufnr, err, provider_name)
  --    if type(err) == 'string' and err:match('UfoFallbackException') then
  --      return require('ufo').getFolds(bufnr, provider_name)
  --    else
  --      return require('promise').reject(err)
  --    end
  --  end
  --
  --  return (filetype == 'alpha') and ''
  --      or (filetype == '' or buftype == 'nofile') and 'indent' -- only use indent until a file is opened
  --      or function(bufnr)
  --        return require('ufo').getFolds(bufnr, 'lsp')
  --            :catch(function(err) return handle_fallback_exception(bufnr, err, 'treesitter') end)
  --            :catch(function(err) return handle_fallback_exception(bufnr, err, 'indent') end)
  --      end
  --end,
}

function M.config(_, opts)
  --vim.o.foldcolumn     = '1'
  vim.o.foldlevel      = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable     = true

  vim.opt.fillchars    = {
    fold = ' ',
    foldopen = '',
    foldclose = '',
    foldsep = ' ',
  }

  vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
  vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
  vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
  vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)
  vim.keymap.set('n', 'zp', require('ufo').peekFoldedLinesUnderCursor)

  require('ufo').setup(opts)
end

return M
