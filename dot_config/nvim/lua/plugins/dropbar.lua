local M = {
  'Bekaboo/dropbar.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
}

M.opts = {
  sources = {
    path = {
      max_depth = 1,
      modified = function(sym)
        return sym:merge({
          icon = '● ',
          icon_hl = 'String'
        })
      end,
    },
  },
}

function M.config(_, opts)
  local dropbar = require('dropbar')
  local normal_hl = vim.api.nvim_get_hl(0, { name = 'Normal' })
  vim.api.nvim_set_hl(0, 'DropBarKindFile', { fg = normal_hl.fg, bold = true })

  local orig_enable = require('dropbar.configs').opts.bar.enable

  --- workaround neovim#22189 for git blame
  ---@type boolean|fun(buf: integer, win: integer, info: table?): boolean
  local enable = function(buf, win, info)
    local blame = vim.bo[buf].filetype == 'fugitiveblame'
    return blame or orig_enable(buf, win, info)
  end

  opts = vim.tbl_extend('keep', opts, {
    bar = {
      enable = enable,
      attach_events = {
        'OptionSet',
        'BufWinEnter',
        'BufWritePost',
        'User', -- for fugitive buffers
      },
      update_events = {
        win = {
          'CursorHold',
          'WinEnter',
          'WinResized',
        },
      },
    },
  })

  dropbar.setup(opts)
end

return M
