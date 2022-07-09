local map = vim.keymap.set
local opts = { noremap = false }

map('n', 'gD',         '<plug>(coc-declaration)', opts)
map('n', 'gd',         '<plug>(coc-definition)', opts)
map('n', 'gi',         '<plug>(coc-implementation)', opts)
map('n', 'gTD',        '<plug>(coc-type-definition)', opts)
map('n', '<leader>rn', '<plug>(coc-rename)', opts)
map('n', 'gr',         '<plug>(coc-references)', opts)
map('n', 'K',          "<cmd>call CocActionAsync('definitionHover')<CR>")
map('n', '<leader>ac', '<plug>(coc-codeaction-cursor)', opts)
map('n', ']e',         '<plug>(coc-diagnostic-next)', opts)
map('n', '[e',         '<plug>(coc-diagnostic-prev)', opts)

map({'x', 'o'}, 'if',    '<plug>(coc-funcobj-i)', opts)
map({'x', 'o'}, 'ic',    '<plug>(coc-classobj-i)', opts)

map('x', '<leader>f', '<plug>(coc-format-selected)', opts)
map('n', '<leader>f', '<plug>(coc-format)', opts)

local au_group = vim.api.nvim_create_augroup('coc', {})
vim.api.nvim_create_autocmd('User', {
  group = au_group,
  pattern = 'CocJumpPlaceholder',
  command = [[call CocActionAsync('showSignatureHelp')]]
})
vim.api.nvim_create_autocmd('CursorHold', {
  group = au_group,
  command = [[silent call CocActionAsync('highlight'))]]
})
