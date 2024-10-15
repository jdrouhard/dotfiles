local hl_map = {
  ['@keyword.access']                  = { link = 'Statement' },
  ['@statement']                       = { link = 'Statement' },
  ['@deprecated']                      = { link = '@text.strike' },
  ['@text.strike']                     = { strikethrough = true },
  ['@lsp.type.comment']                = {}, -- treesitter has better comment handling

  -- Native LSP groups
  ['@lsp.mod.deprecated']              = { link = '@text.strike' },

  --- clangd
  ['@lsp.mod.constructorOrDestructor'] = { link = '@constructor' },
  ClangdInactive                       = { link = 'ColorColumn' },

  -- Coc specific groups
  -- Misc
  CocHighlightText                     = { link = 'LspReferenceText' },
  CocHighlightRead                     = { link = 'LspReferenceRead' },
  CocHighlightWrite                    = { link = 'LspReferenceWrite' },

  -- LSP
  CocSemClass                          = { link = '@type' },
  CocSemEnum                           = { link = '@type' },
  CocSemEnumMember                     = { link = '@constant' },
  CocSemTypeTypeParameter              = { link = '@type' },

  -- Telescope
  TelescopePreviewLine                 = { link = 'Visual' },
  TelescopePreviewMatch                = { link = 'Search' },

  TelescopeBorder                      = { link = 'TelescopeNormal' },
  TelescopePromptBorder                = { link = 'TelescopeBorder' },
  TelescopeResultsBorder               = { link = 'TelescopeBorder' },
  TelescopePreviewBorder               = { link = 'TelescopeBorder' },

  TelescopeTitle                       = { link = 'TelescopeBorder' },
  TelescopePromptTitle                 = { link = 'TelescopeTitle' },
  TelescopeResultsTitle                = { link = 'TelescopeTitle' },
  TelescopePreviewTitle                = { link = 'TelescopeTitle' },
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
