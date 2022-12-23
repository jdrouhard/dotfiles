local M = {
  'haya14busa/vim-asterisk',
  keys = { '*', '#', 'g*', 'g#' },
}

function M.config()
  local map = vim.keymap.set
  vim.g['asterisk#keeppos'] = true
  map({ 'n', 'x' }, '*', '<plug>(asterisk-z*)', { remap = true })
  map({ 'n', 'x' }, '#', '<plug>(asterisk-z#)', { remap = true })
  map({ 'n', 'x' }, 'g*', '<plug>(asterisk-gz*)', { remap = true })
  map({ 'n', 'x' }, 'g#', '<plug>(asterisk-gz#)', { remap = true })
end

return M
