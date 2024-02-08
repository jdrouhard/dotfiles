local map = vim.keymap.set
local fn  = vim.fn

-- editing
map('i', 'jk', '<ESC>')
map('n', 'j',  'gj')
map('n', 'k',  'gk')

map('v', '<', '<gv')
map('v', '>', '>gv')

-- buffers
map('n', '<c-s>',      '<cmd>w<CR>')
map('',  '<leader>w',  '<c-w>')
map('',  '<F4>',       require('alternate').jump_alternate)

-- misc
local resolved_plugins = fn.resolve(fn.stdpath('config') .. '/lua/plugins/init.lua')
map('',  '<F2>',       require('utils').show_highlights_at_pos)
map('n', '<leader>m',  '<cmd>Make<CR>')
map('n', '<C-k>',      '<cmd>cp<CR>')
map('n', '<C-j>',      '<cmd>cn<CR>')
map('n', '<leader>ev', '<cmd>e $MYVIMRC<CR>')
map('n', '<leader>ep', '<cmd>e ' .. resolved_plugins .. '<CR>')
map('n', '<leader>d',  vim.diagnostic.open_float)
