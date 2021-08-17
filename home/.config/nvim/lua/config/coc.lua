local g = vim.g
local utils = require'utils'
local autocmd = utils.autocmd
local map = utils.map
local cmd = vim.cmd

g.coc_default_semantic_highlight_groups = true

cmd [[hi! link CocSem_variable TSVariable]]
cmd [[hi! link CocSem_parameter TSParameter]]
cmd [[hi! link CocSem_property TSProperty]]
cmd [[hi! link CocErrorHighlight LspDiagnosticsUnderlineError]]
cmd [[hi! link CocWarningHighlight LspDiagnosticsUnderlineWarning]]
cmd [[hi! link CocInfoHighlight LspDiagnosticsUnderlineInformation]]
cmd [[hi! link CocHintHighlight LspDiagnosticsUnderlineHint]]

local opts = { silent = true, noremap = false }

map('n', '<leader>jd', '<plug>(coc-definition)', opts)
map('n', 'gD',         '<plug>(coc-declaration)', opts)
map('n', 'gd',         '<plug>(coc-definition)', opts)
map('n', 'gi',         '<plug>(coc-implementation)', opts)
map('n', 'gr',         '<plug>(coc-references)', opts)
map('n', '<F3>',       '<plug>(coc-references)', opts)
map('n', 'K',          "<cmd>call CocActionAsync('definitionHover')<CR>")
map('n', '<leader>ac', '<cmd>CocAction<CR>')

map({'x', 'o'}, 'if',    '<plug>(coc-funcobj-i)', opts)
map({'x', 'o'}, 'ic',    '<plug>(coc-classobj-i)', opts)

map('x', '<leader>f', '<plug>(coc-format-selected)', opts)
map('n', '<leader>f', '<plug>(coc-format)', opts)

autocmd('coc', {
    [[User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')]],
    [[CursorHold * silent call CocActionAsync('highlight')]]
})
