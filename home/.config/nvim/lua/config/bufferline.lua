local map = require('utils').map

require('bufferline').setup {
    options = {
        numbers = 'ordinal',
        show_tab_indicators = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        max_name_length = 64,
        separator_style = 'slant',
        diagnostics = 'nvim_lsp',
    },
}

map('n', 'gb', '<cmd>BufferLinePick<cr>')
map('n', '<c-h>', '<cmd>BufferLineCyclePrev<cr>')
map('n', '<c-l>', '<cmd>BufferLineCycleNext<cr>')
