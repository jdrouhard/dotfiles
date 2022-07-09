local map = vim.keymap.set

require('bufferline').setup {
    options = {
        themable = false,
        numbers = 'ordinal',
        show_tab_indicators = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        max_name_length = 64,
        separator_style = 'slant',
        diagnostics = 'nvim_lsp',
    },
}

map('n', '<leader>b', '<cmd>BufferLinePick<cr>')
map('n', '<c-h>', '<cmd>BufferLineCyclePrev<cr>')
map('n', '<c-l>', '<cmd>BufferLineCycleNext<cr>')
