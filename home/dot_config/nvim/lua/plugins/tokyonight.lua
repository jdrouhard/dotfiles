local M = {
  'folke/tokyonight.nvim',
}

M.opts = {
  style = 'moon',
  on_highlights = function(hl, c)
    hl['@lsp.typemod.parameter.reference'] = {
      fg = require('tokyonight.util').lighten(c.yellow, 0.25)
    }
  end,
}

return M
