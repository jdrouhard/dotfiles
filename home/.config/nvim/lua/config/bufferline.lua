local colors = require('tokyonight.colors').setup({})
local map = require('utils').map

require('bufferline').setup{
    options = {
        numbers = 'ordinal',
        number_style = '',
        show_tab_indicators = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        max_name_length = 64,
        separator_style = 'slant',
    },
    --highlights = {
        --fill = {
            --guibg = colors.bg_statusline,
            --guifg = colors.fg_sidebar
        --},
        --separator = {
            --guibg = colors.bg_statusline,
            --guifg = colors.bg_statusline,
        --},
--            buffer_selected = {
--                gui = "",
--                guifg = colors.black,
--                guibg = colors.blue
--            },
        --modified = {
            --guibg = colors.blue,
            --guifg = colors.black
        --},
        --modified_selected = {
            --gui = "bold,italic",
            --guibg = colors.green,
            --guifg = colors.black
        --},
        --modified_visible = {
            --guibg = colors.blue,
            --guifg = colors.black
        --}
    --}
}

map('n', 'gb', '<cmd>BufferLinePick<cr>')
