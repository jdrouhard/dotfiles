local M = {
  'stevearc/dressing.nvim',
}

if require('globals').telescope then
  M.opts = { select = { backend = 'telescope' } }
else
  M.opts = { select = { backend = 'fzf_lua' } }
end

function M.init()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(...)
    require('lazy').load({ plugins = { 'dressing.nvim' } })
    return vim.ui.select(...)
  end

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.input = function(...)
    require('lazy').load({ plugins = { 'dressing.nvim' } })
    return vim.ui.input(...)
  end
end

return M
