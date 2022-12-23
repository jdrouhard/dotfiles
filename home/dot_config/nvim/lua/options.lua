local g   = vim.g
local o   = vim.o
local opt = vim.opt

g.mapleader = [[ ]]
g.alternateNoDefaultAlternate = true

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
opt.wildignore  = { '*.o', '*.obj', '*.dwo' }
opt.listchars   = { tab = '▸ ', trail = '·' }

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
