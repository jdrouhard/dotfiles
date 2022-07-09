local M = {}

local actions = require('telescope.actions')
local mappings = {
    ["<c-k>"] = actions.move_selection_previous,
    ["<c-j>"] = actions.move_selection_next,
    ["<c-b>"] = actions.preview_scrolling_up,
    ["<c-f>"] = actions.preview_scrolling_down,
}

require('telescope').setup {
    defaults = {
        mappings = {
            i = mappings,
            n = mappings,
        },
        winblend = 10,
        layout_strategy = 'flex',
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
        }
    },
    pickers = {
        grep_string = {
            use_regex = true,
        },
        buffers = {
            sort_lastused = true,
            --previewer = false,
        }
    }
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('coc')

return M
