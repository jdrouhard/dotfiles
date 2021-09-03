local utils = require('utils')
local map = utils.map

map('n', '<leader>s',  '<cmd>FzfLua grep<CR>')
map('n', '<leader>ag', '<cmd>FzfLua grep_cword<CR>')
map('n', '<leader>rg', '<cmd>FzfLua live_grep<CR>')
map('n', '<leader>AG', '<cmd>FzfLua grep_cWORD<CR>')
map('x', '<leader>ag', '<cmd>FzfLua grep_visual<CR>')

map('n', '<c-p>',       '<cmd>FzfLua files<CR>')
map('n', '<leader>l',   '<cmd>FzfLua buffers<CR>')
map('n', '<leader>t',   '<cmd>FzfLua git_files<CR>')
map('n', '<leader>h',   '<cmd>FzfLua commands<CR>')
map('n', '<leader>?',   '<cmd>FzfLua help_tags<CR>')
map('n', '<leader>qf',  '<cmd>FzfLua quickfix<CR>')
map('n', '<leader>gs',  '<cmd>FzfLua git_status<CR>')
map('n', '<leader>gl',  '<cmd>FzfLua git_commits<CR>')
map('n', '<leader>gbl', '<cmd>FzfLua git_bcommits<CR>')

vim.g.coc_enable_locationlist = false

vim.cmd[[
    augroup fzf_coc
        au!
        au User CocLocationsChange nested FzfCocLocations
    augroup END
]]


--local remap = { noremap = false }

--map('i', '<C-x><C-f>', '<plug>(fzf-complete-path)', remap)
--map('i', '<C-x><C-l>', '<plug>(fzf-complete-line)', remap)

--map('n', '<leader><tab>', '<plug>(fzf-maps-n)', remap)
--map('x', '<leader><tab>', '<plug>(fzf-maps-x)', remap)
--map('o', '<leader><tab>', '<plug>(fzf-maps-o)', remap)
