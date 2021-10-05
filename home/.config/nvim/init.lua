pcall(require, 'impatient')

local g = vim.g
local cmd = vim.cmd
local fn = vim.fn
local opt = vim.opt
local utils = require('utils')
local autocmd = utils.autocmd
local map = utils.map

require('plugin_bootstrap')
require('theme').setup()

g.mapleader = [[ ]]

opt.ttimeoutlen   = 0
opt.updatetime    = 100
opt.undofile      = true
opt.wildignore    = "*.o,*.obj,*.dwo"
opt.path          = vim.env.PWD .. '/**'
opt.shortmess     :append("c")

opt.showmode      = false
opt.ruler         = false
opt.hidden        = true
opt.foldenable    = false
opt.number        = true
opt.numberwidth   = 5
opt.signcolumn    = "yes"
opt.cmdheight     = 2
--opt.cul           = true
opt.lazyredraw    = true
opt.smartcase     = true
opt.visualbell    = true
opt.ignorecase    = true

opt.expandtab     = true
opt.shiftround    = true
opt.shiftwidth    = 4
opt.matchtime     = 3
opt.scrolloff     = 3
opt.linebreak     = true
opt.breakindent   = true
opt.showbreak     = "↪"
opt.showmatch     = true
opt.inccommand    = "nosplit"
opt.list          = true
opt.listchars     = "tab:▸ ,trail:·"

-- editing
map('i', 'jk', '<ESC>')
map('n', 'j',  'gj')
map('n', 'k',  'gk')

map('',  'Y', 'y$')
map('v', '<', '<gv')
map('v', '>', '>gv')

map('i', '<tab>',   'pumvisible() ? "<C-n>" : "<tab>"',   { silent = true, expr = true })
map('i', '<s-tab>', 'pumvisible() ? "<C-p>" : "<s-tab>"', { silent = true, expr = true })

-- buffers
g.alternateNoDefaultAlternate = true

map('n', '<c-h>',      '<cmd>bprevious<CR>')
map('n', '<c-l>',      '<cmd>bnext<CR>')
map('',  '<leader>bd', '<cmd>bdelete!<CR>', { silent = true, nowait = true })
map('',  '<c-q>',      '<cmd>bdelete!<CR>', { silent = true, nowait = true })
map('',  '<leader>w',  '<c-w>')
map('',  '<F4>',       '<cmd>A<CR>')
map('',  '<F5>',       '<cmd>AI<CR>')

-- misc
local resolved_plugins = fn.resolve(fn.stdpath('config') .. '/lua/plugins.lua')
map('n', '<leader>m',  '<cmd>make<CR>')
map('n', '<C-k>',      '<cmd>cp<CR>', { silent = true })
map('n', '<C-j>',      '<cmd>cn<CR>', { silent = true })
map('n', '<leader>ev', '<cmd>e $MYVIMRC<CR>')
map('n', '<leader>ep', '<cmd>e ' .. resolved_plugins .. '<CR>')

vim.cmd[[command! -range=% StripTrailingWhitespace <line1>,<line2>s/\s\+$//e | noh | norm! ``]]

autocmd('filetypes', {
    [[FileType            cmake,xml  setlocal tabstop=2 | setlocal shiftwidth=2]],
    [[FileType            cpp,python setlocal textwidth=90 | setlocal formatoptions=crqnj]],
    [[FileType            gitcommit  setlocal formatlistpat=^\\s*[0-9*-]\\+[\\]:.)}\\t\ ]\\s*]],
    [[FileType            gitcommit  setlocal formatoptions+=n]],
    [[BufRead,BufNewFile *.sqli      setlocal filetype=sql]],
    [[BufRead,BufNewFile *.spec      setlocal filetype=spec]],
    [[BufRead,BufNewFile *.inc       setlocal filetype=cpp]]
})

autocmd('window', {
    [[VimResized  * exe "normal! \<c-w>="]],
    [[BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]
})

autocmd('autoswap', [[SwapExists  * let v:swapchoice = 'e']])

local disabled_builtins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
}

for _, plugin in pairs(disabled_builtins) do
    g["loaded_" .. plugin] = 1
end
