local g = vim.g
local utils = require'utils'
local map = utils.map

require'fzf-lua'.setup {
    fzf_layout = 'default',
    winopts = {
        win_height = 0.6,
        win_width = 0.9
    },
    fzf_binds = {
        'f2:toggle-preview',
        'up:preview-up',
        'down:preview-down',
        'pgup:preview-page-up',
        'pgdn:preview-page-down'
    },
    preview_horizontal = 'right:50%',
    grep = {
        --rg_opts = '--vimgrep --hidden'
        rg_opts = "--hidden --column --line-number --no-heading " ..
                  "--color=always --smart-case -g '!{.git,node_modules}/*'",
    },
    files = {
        cmd = [[rg --files --hidden]]
    }
}

map('n', '<leader>s',  '<cmd>FzfLua grep<CR>')
map('n', '<leader>ag', '<cmd>FzfLua grep_cword<CR>')
map('n', '<leader>AG', '<cmd>FzfLua grep_cWORD<CR>')
map('x', '<leader>ag', 'y:FzfLua grep search=<C-R>"<CR>')

map('n', '<c-p>',       '<cmd>FzfLua files<CR>')
map('n', '<leader>l',   '<cmd>FzfLua buffers<CR>')
map('n', '<leader>t',   '<cmd>FzfLua git_files<CR>')
--map('n', '<leader>h', '<cmd>FzfLua commands<CR>') -- not yet implemented
map('n', '<leader>?',   '<cmd>FzfLua help_tags<CR>')
map('n', '<leader>gs',  '<cmd>FzfLua git_files<CR>')
map('n', '<leader>gl',  '<cmd>FzfLua git_commits<CR>')
map('n', '<leader>gbl', '<cmd>FzfLua git_bcommits<CR>')

--local remap = { noremap = false }

--map('i', '<C-x><C-f>', '<plug>(fzf-complete-path)', remap)
--map('i', '<C-x><C-l>', '<plug>(fzf-complete-line)', remap)

--map('n', '<leader><tab>', '<plug>(fzf-maps-n)', remap)
--map('x', '<leader><tab>', '<plug>(fzf-maps-x)', remap)
--map('o', '<leader><tab>', '<plug>(fzf-maps-o)', remap)
