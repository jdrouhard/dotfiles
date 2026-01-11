return {
  'EdenEast/nightfox.nvim',
  'bluz71/vim-moonfly-colors',
  'bluz71/vim-nightfly-guicolors',
  'rebelot/kanagawa.nvim',

  {
    'navarasu/onedark.nvim',
    opts = {
      style = 'warmer',
      highlights = {
        ['@lsp.type.variable'] = { fg = 'none' },
      },
    },
  },

  {
    'rose-pine/neovim',
    name = 'rose-pine',
    opts = {
      highlight_groups = {
        ["@variable"] = { italic = false },
        ["@property"] = { italic = false },
      }
    }
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    opts = {
      integrations = {
        dap = {
          enabled = true,
          enable_ui = true,
        },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        notify = true,
      },
      custom_highlights = function(colors)
        return {
          ['@lsp.typemod.parameter.reference'] = {
            fg = require('catppuccin.utils.colors').lighten(colors.maroon, 0.75),
          },
        }
      end
    }
  },

  {
    'folke/tokyonight.nvim',
    opts = {
      style = 'night',
      on_highlights = function(hl, c)
        hl['@lsp.typemod.parameter.reference'] = {
          fg = require('tokyonight.util').lighten(c.yellow, 0.45)
        }
        hl['FzfLuaDirPart'] = {
          link = 'Comment',
        }
      end,
      plugins = {
        cmp = true,
      }
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

  {
    'zenbones-theme/zenbones.nvim',
    init = function()
      vim.g.bones_compat = true
    end,
  },
}
