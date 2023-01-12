local M = {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
}

function M.config()
  require('noice').setup({
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
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
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
  })
end

return M
