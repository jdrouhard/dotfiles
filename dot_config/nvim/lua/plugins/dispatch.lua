local M = {
  'tpope/vim-dispatch',
  cmd = { 'Dispatch', 'Make', 'Focus', 'Start', 'Spawn' },
  dependencies = {
    'radenling/vim-dispatch-neovim',
  },
}

function M.config()
  local handlers = vim.g.dispatch_handlers
  table.insert(handlers, 1, 'neovim')
  vim.g.dispatch_handlers = handlers
end

return M
