local M = {
  'haya14busa/vim-asterisk',
  keys = {
    { '*', '<plug>(asterisk-z*)', mode = {'n', 'x' }, remap = true },
    { '#', '<plug>(asterisk-z#)', mode = {'n', 'x' }, remap = true },
    { 'g*', '<plug>(asterisk-gz*)', mode = {'n', 'x' }, remap = true },
    { 'g#', '<plug>(asterisk-gz#)', mode = {'n', 'x' }, remap = true },
  },
}

function M.config()
  vim.g['asterisk#keeppos'] = true
end

return M
