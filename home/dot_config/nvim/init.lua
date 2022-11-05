pcall(require, 'impatient')

local g   = vim.g
local o   = vim.o
local cmd = vim.cmd
local api = vim.api
local fn  = vim.fn
local opt = vim.opt
local map = vim.keymap.set

g.mapleader = [[ ]]

o.ttimeoutlen   = 0
o.updatetime    = 100
o.undofile      = true
o.path          = vim.env.PWD .. '/**'

o.showmode      = false
o.ruler         = false
o.hidden        = true
o.foldenable    = false
o.number        = true
o.numberwidth   = 5
o.signcolumn    = 'yes'
--o.cmdheight     = 2
--o.cul           = true
o.lazyredraw    = true
o.smartcase     = true
o.visualbell    = true
o.ignorecase    = true

o.expandtab     = true
o.shiftround    = true
o.shiftwidth    = 4
o.matchtime     = 3
o.scrolloff     = 3
o.linebreak     = true
o.breakindent   = true
o.showbreak     = '↪'
o.showmatch     = true
o.inccommand    = 'nosplit'
o.list          = true

opt.shortmess   :append('c')
opt.diffopt     :append('linematch:60')
opt.wildignore  = { '*.o', '*.obj' ,'*.dwo' }
opt.listchars   = { tab = '▸ ', trail = '·' }

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
g.alternateNoDefaultAlternate = true

map('n', '<c-s>',      '<cmd>w<CR>')
map('n', '<c-h>',      '<cmd>bprevious<CR>')
map('n', '<c-l>',      '<cmd>bnext<CR>')
map('',  '<c-q>',      '<cmd>bdelete!<CR>')
map('',  '<leader>w',  '<c-w>')
map('',  '<F4>',       '<cmd>A<CR>')
map('',  '<F5>',       '<cmd>AI<CR>')

-- misc
local resolved_plugins = fn.resolve(fn.stdpath('config') .. '/lua/plugins.lua')
map('n', '<leader>m',  '<cmd>make<CR>')
map('n', '<C-k>',      '<cmd>cp<CR>')
map('n', '<C-j>',      '<cmd>cn<CR>')
map('n', '<leader>ev', '<cmd>e $MYVIMRC<CR>')
map('n', '<leader>ep', '<cmd>e ' .. resolved_plugins .. '<CR>')

vim.filetype.add({
  extension = {
    sqli = 'sql',
    inc = 'cpp',
  }
})

api.nvim_create_user_command('StripTrailingWhitespace', '<line1>,<line2>s/\\s\\+$//e | noh | norm! ``', { range = '%' })

api.nvim_create_augroup('init', {})

local autocmds = {
  { 'FileType',    { pattern = { 'cmake', 'xml', 'lua' }, command = [[setlocal tabstop=2 | setlocal shiftwidth=2]], } },
  { 'FileType',    { pattern = { 'cpp', 'python' }, command = [[setlocal textwidth=90 | setlocal formatoptions=crqnj]], } },
  { 'FileType',    { pattern = 'gitcommit', command = [[setlocal formatlistpat=^\\s*[0-9*-]\\+[\\]:.)}\\t\ ]\\s* | setlocal formatoptions+=n]], } },
  { 'VimResized',  { command = [[exec "normal! \<c-w>="]], } },
  { 'BufReadPost', { command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]], } },
  { 'SwapExists',  { command = [[let v:swapchoice = 'e']], } },
}

for _, autocmd in ipairs(autocmds) do
  api.nvim_create_autocmd(autocmd[1], vim.tbl_extend('force', { group = 'init' }, autocmd[2]))
end

local local_init = fn.resolve(fn.stdpath('data') .. '/site/init.lua')
if fn.filereadable(local_init) > 0 then
  cmd('luafile ' .. local_init)
end

require('plugins').bootstrap()

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

local disabled_providers = {
    "ruby",
    "node",
    "perl",
}

for _, plugin in pairs(disabled_builtins) do
    g["loaded_" .. plugin] = 1
end

for _, plugin in pairs(disabled_providers) do
    g["loaded_" .. plugin .. "_provider"] = 0
end
