local g = vim.g
local opt = vim.opt
local cmd = vim.cmd

local M = {}

M.theme = 'tokyonight'
M.lualine_theme = 'tokyonight'

local function lsp_highlights(prefix)
  local hl_map = {
    Class         = 'TSType',
    Comment       = 'TSComment',
    Enum          = 'TSType',
    EnumMember    = 'TSConstant',
    Function      = 'TSFunction',
    Macro         = 'TSMacro',
    Method        = 'TSFunction',
    Namespace     = 'TSNamespace',
    Parameter     = 'TSParameterReference',
    Property      = 'TSProperty',
    Type          = 'TSType',
    TypeParameter = 'TSType',
    Variable      = 'TSVariable',
    Deprecated    = 'TSStrike',

    DeclarationVariable = 'Identifier',
    DeclarationParameter = 'TSParameter',
  }

  for name, hl in pairs(hl_map) do
    cmd(string.format('hi! link %s%s %s', prefix, name, hl))
  end
end

function M.apply_highlights()
    cmd [[hi! link TSKeywordAccess Statement]]
    cmd [[hi! link TSStatement Statement]]
    cmd [[hi! link TSStorageClass StorageClass]]
    cmd [[hi! link TSStructure Keyword]]

    lsp_highlights('CocSem')
    lsp_highlights('Lsp')

    cmd [[hi! link CocErrorHighlight DiagnosticUnderlineError]]
    cmd [[hi! link CocWarningHighlight DiagnosticUnderlineWarn]]
    cmd [[hi! link CocInfoHighlight DiagnosticUnderlineInfo]]
    cmd [[hi! link CocHintHighlight DiagnosticUnderlineHint]]
    cmd [[hi! link CocHighlightText LspReferenceText]]
    cmd [[hi! link CocHighlightRead LspReferenceRead]]
    cmd [[hi! link CocHighlightWrite LspReferenceWrite]]
end

function M.setup()
    opt.termguicolors = true
    g.nightfox_italic_comments = true
    g.nightfox_italic_functions = true

    g.oceanic_next_terminal_italic = true
    g.oceanic_next_terminal_bold = true

    g.tokyonight_style = 'night'
    g.tokyonight_italic_functions = true

    local au_group = vim.api.nvim_create_augroup('highlights', {})
    vim.api.nvim_create_autocmd('ColorScheme', { group = au_group, callback = M.apply_highlights })
    cmd([[silent! colorscheme ]] .. M.theme)

    require('config.heirline').setup()
    --require('colorizer').setup()
end

return M
