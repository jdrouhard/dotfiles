local g = vim.g
local api = vim.api
local cmd = vim.cmd
local opt = vim.opt

local M = {}

M.theme = 'tokyonight'
--M.theme = 'nightfox'
--M.theme = 'duskfox'
--M.theme = 'kanagawa'

local lsp_hl_map = {
  Class         = { link = '@type' },
  Comment       = { link = '@comment' },
  Enum          = { link = '@type' },
  EnumMember    = { link = '@constant' },
  Function      = { link = '@function' },
  Macro         = { link = '@macro' },
  Method        = { link = '@function' },
  Namespace     = { link = '@namespace' },
  Parameter     = { link = '@parameter.reference' },
  Property      = { link = '@property' },
  Type          = { link = '@type' },
  TypeParameter = { link = '@type' },
  Variable      = { link = '@variable' },
  Deprecated    = { link = '@text.strike' },

  DeclarationVariable = { link = 'Identifier' },
  DeclarationParameter = { link = '@parameter' },
}

local hl_map = {
  ['@keyword.access'] = { link = 'Statement' },
  ['@statement']      = { link = 'Statement' },
  ['@structure']      = { link = '@keyword' },

  CocErrorHighlight   = { link = 'DiagnosticUnderlineError' },
  CocWarningHighlight = { link = 'DiagnosticUnderlineWarn' },
  CocInfoHighlight    = { link = 'DiagnosticUnderlineInfo' },
  CocHintHighlight    = { link = 'DiagnosticUnderlineHint' },
  CocHighlightText    = { link = 'LspReferenceText' },
  CocHighlightRead    = { link = 'LspReferenceRead' },
  CocHighlightWrite   = { link = 'LspReferenceWrite' },
}

local function lsp_highlights(prefix)
  local hls = {}
  for name, hl in pairs(lsp_hl_map) do
    hls[string.format('%s%s', prefix, name)] = hl
  end
  return hls
end

local hl_cache = {}

function M.apply_highlights()
  for name, hl in pairs(hl_cache) do
    api.nvim_set_hl(0, name, hl)
  end
end

function M.setup()
  opt.termguicolors = true

  g.oceanic_next_terminal_italic = true
  g.oceanic_next_terminal_bold = true

  hl_cache = hl_map
  hl_cache = vim.tbl_extend('error', hl_cache, lsp_highlights('CocSem'))
  hl_cache = vim.tbl_extend('error', hl_cache, lsp_highlights('Lsp'))

  require('tokyonight').setup {
    style = 'night',
    styles = {
      functions = 'italic',
    },
    on_highlights = function(hl, _)
      hl.TSParameterReference = {
        fg = '#cfc9c2',
      }
    end,
  }

  require('nightfox').setup {
    options = {
      styles = {
        comments = 'italic',
        functions = 'italic',
        keywords = 'italic'
      }
    }
  }

  local au_group = vim.api.nvim_create_augroup('highlights', {})
  vim.api.nvim_create_autocmd('ColorScheme', { group = au_group, callback = M.apply_highlights })
  cmd([[colorscheme ]] .. M.theme)

  require('config.heirline').setup()
  require('config.bufferline')
end

return M
