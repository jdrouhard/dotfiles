local g   = vim.g
local o   = vim.o
local opt = vim.opt

g.clipboard = 'osc52'
g.mapleader = [[ ]]
g.alternateNoDefaultAlternate = true

o.ttimeoutlen   = 0
o.updatetime    = 100
o.undofile      = true
o.path          = vim.fn.getcwd(-1, -1) .. '/**'

o.showtabline   = 1
o.showmode      = false
o.ruler         = false
o.hidden        = true
o.foldenable    = false
o.number        = true
o.numberwidth   = 5
o.signcolumn    = 'yes'
o.foldcolumn    = '1'
--o.cmdheight     = 2
--o.cul           = true
o.smartcase     = true
o.visualbell    = true
o.ignorecase    = true

o.expandtab     = true
o.shiftround    = true
o.shiftwidth    = 2
o.matchtime     = 3
o.scrolloff     = 3
o.linebreak     = true
o.breakindent   = true
o.showbreak     = '↪'
o.showmatch     = true
o.inccommand    = 'nosplit'
o.list          = true

opt.shortmess   :append('cI')
opt.diffopt     :append('linematch:60')
opt.wildignore  = { '*.o', '*.obj', '*.dwo' }
opt.listchars   = { tab = '▸ ', trail = '·' }
opt.mousescroll = { 'ver:1', 'hor:6' }
opt.jumpoptions = { 'view' }

local disabled_providers = {
  'ruby',
  'node',
  'perl',
  'python3',
}

for _, plugin in pairs(disabled_providers) do
  g['loaded_' .. plugin .. '_provider'] = 0
end
