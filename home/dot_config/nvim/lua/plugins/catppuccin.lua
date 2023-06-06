local M = {
  'catppuccin/nvim',
  name = 'catppuccin',
}

M.opts = {
  integrations = {
    notify = true,
    leap = true,
    dap = {
      enabled = true,
      enable_ui = true,
    },
    native_lsp = {
      enabled = true,
      underlines = {
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
      },
    },
  },
  custom_highlights = function(colors)
    return {
      ['@method'] = { link = '@function' },
      ['@property.cpp'] = { link = '@property' },
      ['@lsp.type.method'] = { link = '@method' },
      ['@lsp.typemod.parameter.reference'] = {
        fg = require('catppuccin.utils.colors').lighten(colors.maroon, 0.75),
        style = { 'italic' },
      },
      ['AlphaHeader'] = { fg = colors.blue, },
      ['AlphaButtons'] = { fg = colors.sky, },
      ['AlphaShortcut'] = { fg = colors.peach, },
      ['AlphaFooter'] = { fg = colors.sapphire, },
    }
  end
}

return M
