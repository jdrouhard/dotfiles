local map = vim.keymap.set
local fn  = vim.fn

-- editing
map('i', 'jk', '<ESC>')
map('n', 'j',  'gj')
map('n', 'k',  'gk')

map('',  'Y', 'y$')
map('v', '<', '<gv')
map('v', '>', '>gv')

map('i', '<tab>',   'pumvisible() ? "<C-n>" : "<tab>"',   { expr = true })
map('i', '<s-tab>', 'pumvisible() ? "<C-p>" : "<s-tab>"', { expr = true })

-- buffers
map('n', '<c-s>',      '<cmd>w<CR>')
map('n', '<c-h>',      '<cmd>bprevious<CR>')
map('n', '<c-l>',      '<cmd>bnext<CR>')
map('',  '<c-q>',      '<cmd>bdelete!<CR>')
map('',  '<leader>w',  '<c-w>')
map('',  '<F3>',       require('utils').show_highlights_at_pos)
map('',  '<F4>',       '<cmd>A<CR>')

-- misc
local resolved_plugins = fn.resolve(fn.stdpath('config') .. '/lua/plugins/init.lua')
map('n', '<leader>m',  '<cmd>:Make<CR>')
map('n', '<C-k>',      '<cmd>cp<CR>')
map('n', '<C-j>',      '<cmd>cn<CR>')
map('n', '<leader>ev', '<cmd>e $MYVIMRC<CR>')
map('n', '<leader>ep', '<cmd>e ' .. resolved_plugins .. '<CR>')
