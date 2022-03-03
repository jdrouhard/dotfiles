local utils = require('utils')
local autocmd = utils.autocmd
local map = utils.map

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

autocmd('coc', {
    [[User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')]],
    [[CursorHold * silent call CocActionAsync('highlight')]]
})
