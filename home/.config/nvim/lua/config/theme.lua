local cmd = vim.cmd
local autocmd = require('utils').autocmd

local M = {}

M.theme = 'tokyonight'
M.lualine_theme = 'tokyonight'

function M.apply_highlights()
    cmd [[hi! link TSKeywordAccess Statement]]
    cmd [[hi! link TSStatement Statement]]
    cmd [[hi! link TSStorageClass StorageClass]]
    cmd [[hi! link TSStructure Structure]]

    cmd [[hi! link CocSem_variable TSVariable]]
    cmd [[hi! link CocSem_parameter TSParameter]]
    cmd [[hi! link CocSem_property TSProperty]]
    cmd [[hi! link CocErrorHighlight LspDiagnosticsUnderlineError]]
    cmd [[hi! link CocWarningHighlight LspDiagnosticsUnderlineWarning]]
    cmd [[hi! link CocInfoHighlight LspDiagnosticsUnderlineInformation]]
    cmd [[hi! link CocHintHighlight LspDiagnosticsUnderlineHint]]
end

autocmd('highlights', [[ColorScheme * lua require('config.theme').apply_highlights()]])

return M
