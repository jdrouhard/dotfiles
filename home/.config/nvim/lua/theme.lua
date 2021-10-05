local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local autocmd = require('utils').autocmd

local M = {}

M.theme = 'tokyonight'
M.lualine_theme = 'tokyonight'

function M.apply_highlights()
    cmd [[hi! link TSKeywordAccess Statement]]
    cmd [[hi! link TSStatement Statement]]
    cmd [[hi! link TSStorageClass StorageClass]]
    cmd [[hi! link TSStructure Keyword]]

    cmd [[hi! link CocSem_variable TSVariable]]
    cmd [[hi! link CocSem_parameter TSParameter]]
    cmd [[hi! link CocSem_property TSProperty]]
    cmd [[hi! link CocSem_namespace TSNamespace]]

    cmd [[hi! link CocErrorHighlight LspDiagnosticsUnderlineError]]
    cmd [[hi! link CocWarningHighlight LspDiagnosticsUnderlineWarning]]
    cmd [[hi! link CocInfoHighlight LspDiagnosticsUnderlineInformation]]
    cmd [[hi! link CocHintHighlight LspDiagnosticsUnderlineHint]]
end

function M.setup()
    opt.termguicolors = true
    g.nightfox_italic_comments = true
    g.nightfox_italic_functions = true

    g.oceanic_next_terminal_italic = true
    g.oceanic_next_terminal_bold = true

    g.tokyonight_style = 'night'
    g.tokyonight_italic_functions = true

    autocmd('highlights', [[ColorScheme * lua require('theme').apply_highlights()]])
    cmd([[silent! colorscheme ]] .. M.theme)
end

return M
