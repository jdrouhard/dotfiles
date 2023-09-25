local M = {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
}

M.opts = {
  cmdline = {
    enabled = false,
    view = 'cmdline',
  },
  messages = {
    enabled = false,
  },
  popupmenu = {
    enabled = false,
  },
  views = {
    mini = {
      position = {
        row = -2,
      }
    },
  },
  lsp = {
    hover = {
      enabled = false,
    },
    signature = {
      enabled = false,
    },
    message = {
      enabled = false,
    },
  },
  routes = {
    {
      filter = {
        event = 'msg_show',
        kind = 'search_count',
      },
      opts = { skip = true },
    },
  },
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    long_message_to_split = true, -- long messages will be sent to a split
  },
}

return M
