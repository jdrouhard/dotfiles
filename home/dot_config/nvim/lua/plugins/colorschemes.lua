return {
  'EdenEast/nightfox.nvim',
  'bluz71/vim-moonfly-colors',
  'bluz71/vim-nightfly-guicolors',
  'rebelot/kanagawa.nvim',

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    opts = {
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
  },

  {
    'folke/tokyonight.nvim',
    opts = {
      style = 'moon',
      on_highlights = function(hl, c)
        hl['@lsp.typemod.parameter.reference'] = {
          fg = require('tokyonight.util').lighten(c.yellow, 0.25)
        }
      end,
    }
  },

  {
    'Mofiqul/dracula.nvim',
    priority = 1000,
    opts = {
      overrides = function(colors)
        local darken = require('tokyonight.util').darken
        return {
          LspReferenceRead = { link = 'CursorLine' },
          LspReferenceWrite = { link = 'CursorLine' },
          LspReferenceText = { link = 'CursorLine' },
          DiffFile = { link = 'Directory', },
          DiffAdd = { bg = darken(colors.bright_green, 0.35) },
          DiffDelete = { bg = darken(colors.red, 0.15) },
          DiffChange = { bg = darken(colors.cyan, 0.15) },
          DiffText = { bg = darken(colors.cyan, 0.35) },
          ['@lsp.type.typeParameter'] = { link = '@type' },
        }
      end,
    }
  },

}
