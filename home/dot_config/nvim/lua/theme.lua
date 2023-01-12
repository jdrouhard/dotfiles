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
    on_highlights = function(hl, _)
      hl['@parameter.reference'] = {
        fg = '#cfc9c2',
      }
    end,
  }

  local au_group = vim.api.nvim_create_augroup('highlights', {})
  vim.api.nvim_create_autocmd('ColorScheme', { group = au_group, callback = M.apply_highlights })
  cmd([[colorscheme ]] .. require('globals').theme)

  require('bufferline')
  require('heirline')
end

return M
