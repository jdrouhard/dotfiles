local M = {
  'stevearc/dressing.nvim',
  event = 'BufReadPost',
}

if require('globals').telescope then
  M.config = { select = { backend = 'telescope' } }
else
  M.config = { select = { backend = 'fzf_lua' } }
end

return M
