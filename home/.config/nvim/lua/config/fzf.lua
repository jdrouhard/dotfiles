local g = vim.g
local utils = require'utils'
local map = utils.map

vim.env.FZF_DEFAULT_OPTS = [[--inline-info --bind up:preview-up,down:preview-down,pgup:preview-page-up,pgdn:preview-page-down]]

g.fzf_layout = { window = { width = 0.9, height = 0.6 }, down = '~15%' }
g.fzf_commits_log_options = '--graph --color=always --all --pretty=tformat:"%C(auto)%h%d %s %C(green)(%ar)%Creset %C(blue)<%an>%Creset"'

local remap = { noremap = false }

map('n', '<leader>s',  ':Rg<space>')
map('n', '<leader>ag', ':Rg <C-R><C-W><CR>')
map('n', '<leader>AG', ':Rg <C-R><C-A><CR>')
map('x', '<leader>ag', 'y:Rg <C-R>"<CR>')

map('n', '<c-p>',       '<cmd>Files<CR>')
map('n', '<leader>l',   '<cmd>Buffers<CR>')
map('n', '<leader>t',   '<cmd>GFiles<CR>')
map('n', '<leader>h',   '<cmd>Commands<CR>')
map('n', '<leader>?',   '<cmd>Helptags<CR>')
map('n', '<leader>gs',  '<cmd>GFiles?<CR>')
map('n', '<leader>gl',  '<cmd>Commits<CR>')
map('n', '<leader>gbl', '<cmd>BCommits<CR>')

map('i', '<C-x><C-f>', '<plug>(fzf-complete-path)', remap)
map('i', '<C-x><C-l>', '<plug>(fzf-complete-line)', remap)

map('n', '<leader><tab>', '<plug>(fzf-maps-n)', remap)
map('x', '<leader><tab>', '<plug>(fzf-maps-x)', remap)
map('o', '<leader><tab>', '<plug>(fzf-maps-o)', remap)

_G.rg = function(args, bang)
    vim.fn['fzf#vim#grep']([[rg --vimgrep --color=always --ignore-case ]] .. args, 1,
                            bang == 1 and vim.fn['fzf#vim#with_preview']('up:60%')
                                       or vim.fn['fzf#vim#with_preview']('right:50%:hidden', '?'),
                            bang)
end

vim.cmd [[command! -bang -nargs=* Rg call v:lua.rg(shellescape(<q-args>), <bang>0)]]
