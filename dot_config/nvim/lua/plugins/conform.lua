local M = {
  'stevearc/conform.nvim',
  event = 'BufReadPre',
  cmd = 'ConformInfo',
}

M.keys = {
  { '<leader>f', function() require('conform').format({ async = true }) end, mode = { 'n', 'x' } },
}

---@module 'conform'
---@type conform.setupOpts
M.opts = {
  formatters_by_ft = {
    lua = { 'stylua' },
  },
  default_format_opts = {
    lsp_format = 'fallback',
  },
}

return M
