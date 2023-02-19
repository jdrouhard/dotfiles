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

function M.transform_token(token)
  local name = '@' .. token.type
  local priority = vim.highlight.priorities.semantic_tokens

  local is_declaration = vim.tbl_contains(token.modifiers, 'declaration')
  if token.type == 'parameter' and not is_declaration then
    name = name .. '.reference'
  elseif token.type == 'variable' and is_declaration then
    name = name .. '.declaration'
  end

  local hl_groups = {}
  hl_groups[#hl_groups + 1] = {
    name = name,
    priority = priority,
  }

  for _, modifier in ipairs(token.modifiers) do
    local mod_name = '@' .. modifier
    local mod_priority = priority - 1

    if modifier == 'constructorOrDestructor' then
      mod_name = '@constructor'
      mod_priority = priority + 1
    end

    hl_groups[#hl_groups + 1] = {
      name = mod_name,
      priority = mod_priority,
    }
  end

  return hl_groups
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
