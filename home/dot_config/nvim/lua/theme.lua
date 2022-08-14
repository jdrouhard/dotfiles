local g = vim.g
local api = vim.api
local cmd = vim.cmd
local opt = vim.opt

local M = {}

M.theme = 'tokyonight'

local lsp_hl_map = {
  Class         = { link = 'TSType' },
  Comment       = { link = 'TSComment' },
  Enum          = { link = 'TSType' },
  EnumMember    = { link = 'TSConstant' },
  Function      = { link = 'TSFunction' },
  Macro         = { link = 'TSMacro' },
  Method        = { link = 'TSFunction' },
  Namespace     = { link = 'TSNamespace' },
  Parameter     = { link = 'TSParameterReference' },
  Property      = { link = 'TSProperty' },
  Type          = { link = 'TSType' },
  TypeParameter = { link = 'TSType' },
  Variable      = { link = 'TSVariable' },
  Deprecated    = { link = 'TSStrike' },

  DeclarationVariable =  { link = 'Identifier' },
  DeclarationParameter = { link = 'TSParameter' },
}

local hl_map = {
  TSKeywordAccess     = { link = 'Statement' },
  TSStatement         = { link = 'Statement' },
  TSStorageClass      = { link = 'StorageClass' },
  TSStructure         = { link = 'Keyword' },

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

  if g.colors_name == 'tokyonight' then
    api.nvim_set_hl(0, 'TSParameterReference', { fg = '#cfc9c2' })
  end
end

function M.setup()
    opt.termguicolors = true

    g.oceanic_next_terminal_italic = true
    g.oceanic_next_terminal_bold = true

    g.tokyonight_style = 'night'
    g.tokyonight_italic_functions = true

    hl_cache = hl_map
    hl_cache = vim.tbl_extend('error', hl_cache, lsp_highlights('CocSem'))
    hl_cache = vim.tbl_extend('error', hl_cache, lsp_highlights('Lsp'))

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
    cmd([[silent! colorscheme ]] .. M.theme)

    require('config.heirline').setup()
    require('config.bufferline')
end

return M
