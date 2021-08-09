require'buftabline'.setup {
    tab_format = "▎#{n}: #{i} #{b}#{f} ",
    icon_colors = 'normal',
    buffer_id_index = true,
    disable_commands = true,
    go_to_maps = false,
    hlgroups = {
        spacing = 'lualine_c_normal',
        modified_current = "lualine_a_insert",
        modified_normal = "lualine_b_command",
        modified_active = "lualine_b_command",
    },
    show_tabpages = 'always',
}
