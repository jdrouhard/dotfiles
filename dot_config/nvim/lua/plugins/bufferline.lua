local M = {
  'akinsho/nvim-bufferline.lua',
  -- event = 'VeryLazy',
  keys = {
    { '<leader>b', '<cmd>BufferLinePick<cr>' },
    { '<c-h>', '<cmd>BufferLineCyclePrev<cr>' },
    { '<c-l>', '<cmd>BufferLineCycleNext<cr>' },
  },
  dependencies = 'nvim-tree/nvim-web-devicons',
}

function M.config()
  require('bufferline').setup {
    options = {
      style_preset = require('bufferline').style_preset.minimal,
      themable = false,
      numbers = 'ordinal',
      show_tab_indicators = true,
      show_buffer_close_icons = false,
      show_close_icon = false,
      max_name_length = 64,
      separator_style = 'think',
      diagnostics = 'nvim_lsp',
    },
  }
end

return M
