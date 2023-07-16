local hl_map = {
  ['@keyword.access'] = { link = 'Statement' },
  ['@statement']      = { link = 'Statement' },
  ['@structure']      = { link = '@keyword' },
  ['@deprecated']     = { link = '@text.strike' },
  ['@text.strike']    = { strikethrough = true },

  -- Native LSP groups
  ['@lsp.mod.deprecated'] = { link = '@text.strike' },

  --- clangd
  ['@lsp.mod.constructorOrDestructor'] = { link = '@constructor' },

  -- Coc specific groups
  -- Misc
  CocErrorHighlight   = { link = 'DiagnosticUnderlineError' },
  CocWarningHighlight = { link = 'DiagnosticUnderlineWarn' },
  CocInfoHighlight    = { link = 'DiagnosticUnderlineInfo' },
  CocHintHighlight    = { link = 'DiagnosticUnderlineHint' },
  CocHighlightText    = { link = 'LspReferenceText' },
  CocHighlightRead    = { link = 'LspReferenceRead' },
  CocHighlightWrite   = { link = 'LspReferenceWrite' },

  -- LSP
  CocSemClass         = { link = '@type' },
  CocSemComment       = { link = '@comment' },
  CocSemEnum          = { link = '@type' },
  CocSemEnumMember    = { link = '@constant' },
  CocSemFunction      = { link = '@function' },
  CocSemMacro         = { link = '@macro' },
  CocSemMethod        = { link = '@function' },
  CocSemNamespace     = { link = '@namespace' },
  CocSemParameter     = { link = '@parameter.reference' },
  CocSemProperty      = { link = '@property' },
  CocSemType          = { link = '@type' },
  CocSemTypeParameter = { link = '@type' },
  CocSemVariable      = { link = '@variable' },
  CocSemDeprecated    = { link = '@text.strike' },

  CocSemDeclarationVariable = { link = 'Identifier' },
  CocSemDeclarationParameter = { link = '@parameter' },

  -- Miscellaneous
  FzfLuaBorder = { link = 'FloatBorder' },
}

local api = vim.api
local cmd = vim.cmd

local function apply_highlights()
  for name, hl in pairs(hl_map) do
    hl.default = true
    api.nvim_set_hl(0, name, hl)
  end
end

local au_group = api.nvim_create_augroup('highlights', {})
api.nvim_create_autocmd('ColorScheme', { group = au_group, callback = apply_highlights })
cmd.colorscheme(require('globals').theme)

require('heirline')
