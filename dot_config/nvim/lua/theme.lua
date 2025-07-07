local hl_map = {
  ['@lsp.type.comment']                     = {}, -- treesitter has better comment handling
  ['@lsp.typemod.namespace.defaultLibrary'] = { link = '@module.builtin' },

  --- clangd
  ['@lsp.mod.constructorOrDestructor']      = { link = '@constructor' },
  ClangdInactive                            = { link = 'ColorColumn' },

  -- Coc specific groups
  -- Misc
  CocHighlightText                          = { link = 'LspReferenceText' },
  CocHighlightRead                          = { link = 'LspReferenceRead' },
  CocHighlightWrite                         = { link = 'LspReferenceWrite' },

  -- LSP
  CocSemClass                               = { link = '@type' },
  CocSemEnum                                = { link = '@type' },
  CocSemEnumMember                          = { link = '@constant' },
  CocSemTypeTypeParameter                   = { link = '@type' },
}

local api = vim.api
local cmd = vim.cmd

local function apply_highlights()
  vim.schedule(function()
    for name, hl in pairs(hl_map) do
      if not vim.tbl_isempty(hl) then
        hl.default = true
      end
      api.nvim_set_hl(0, name, hl)
    end
  end)
end

local au_group = api.nvim_create_augroup('highlights', {})
api.nvim_create_autocmd('ColorScheme', { group = au_group, callback = apply_highlights })
cmd.colorscheme(require('globals').theme)
