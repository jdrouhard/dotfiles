local g = vim.g
local o = vim.o
local api = vim.api
local cmd = vim.cmd

local M = {}

local hl_map = {
  ['@keyword.access'] = { link = 'Statement' },
  ['@statement']      = { link = 'Statement' },
  ['@structure']      = { link = '@keyword' },
  ['@deprecated']     = { link = '@text.strike' },
  ['@text.strike']    = { strikethrough = true },

  -- Native LSP groups
  ['@lsp.type.comment']   = { link = '@comment' },
  ['@lsp.type.event']     = { link = 'Identifier' },
  ['@lsp.type.function']  = { link = '@function' },
  ['@lsp.type.keyword']   = { link = '@keyword' },
  ['@lsp.type.macro']     = { link = '@macro' },
  ['@lsp.type.method']    = { link = '@method' },
  ['@lsp.type.modifier']  = { link = 'Identifier' },
  ['@lsp.type.namespace'] = { link = '@namespace' },
  ['@lsp.type.operator']  = { link = '@operator' },
  ['@lsp.type.parameter'] = { link = '@parameter' },
  ['@lsp.type.property']  = { link = '@property' },
  ['@lsp.type.regexp']    = { link = 'SpecialChar' },
  ['@lsp.type.string']    = { link = '@string' },
  ['@lsp.type.number']    = { link = '@number' },
  ['@lsp.type.type']      = { link = '@type' },
  ['@lsp.type.variable']  = { link = '@variable' },
  ['@lsp.mod.deprecated'] = { link = '@deprecated' },

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
}

function M.apply_highlights()
  for name, hl in pairs(hl_map) do
    api.nvim_set_hl(0, name, hl)
  end
end

function M.setup()
  o.termguicolors = true

  g.oceanic_next_terminal_italic = true
  g.oceanic_next_terminal_bold = true

  require('tokyonight').setup {
    style = 'moon',
    on_highlights = function(hl, c)
      hl['@parameter.reference'] = {
        fg = require('tokyonight.util').lighten(c.yellow, 0.25)
      }
      --hl['@variable.declaration'] = {
      --  fg = c.magenta,
      --}
    end,
  }

  local au_group = api.nvim_create_augroup('highlights', {})
  api.nvim_create_autocmd('ColorScheme', { group = au_group, callback = M.apply_highlights })
  cmd.colorscheme(require('globals').theme)

  require('bufferline')
  require('heirline')
end

return M
