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
  },
  custom_highlights = function(colors)
    return {
      ['@method'] = { link = '@function' },
      ['@lsp.type.method'] = { link = '@method' },
      ['@lsp.type.property.cpp'] = { link = '@property.cpp' },
      ['@lsp.typemod.parameter.reference'] = {
        fg = require('catppuccin.utils.colors').lighten(colors.maroon, 0.75),
        style = { 'italic' },
      }
    }
  end
}

return M
