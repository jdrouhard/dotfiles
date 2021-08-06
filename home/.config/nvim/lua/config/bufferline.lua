local color_config = require'tokyonight.config'
local colors = require'tokyonight.colors'.setup(color_config)

require'bufferline'.setup{
    options = {
        numbers = "buffer_id",
        number_style = "",
        show_tab_indicators = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        max_name_length = 64
    },
    highlights = {
        fill = {
            guibg = colors.bg_statusline,
            guifg = colors.fg_sidebar
        },
        background = {
            guibg = colors.bg_statusline,
            guifg = colors.fg_sidebar
        },
--            buffer_selected = {
--                gui = "",
--                guifg = colors.black,
--                guibg = colors.blue
--            },
        modified = {
            guibg = colors.blue,
            guifg = colors.black
        },
        modified_selected = {
            gui = "bold,italic",
            guibg = colors.green,
            guifg = colors.black
        },
        modified_visible = {
            guibg = colors.blue,
            guifg = colors.black
        }
    }
}
