local fn = vim.fn
local utils = require('utils')
local autocmd = utils.autocmd
local map = utils.map
local packer = nil

local use_builtin_lsp = false

local function init()
    if packer == nil then
        packer = require('packer')
        packer.init {
            compile_path = vim.fn.stdpath('data') .. '/site/plugin/packer_compiled.lua',
            disable_commands = true,
            display = { open_cmd = 'vnew \\[packer\\]' },
            luarocks = {
                python_cmd = 'python3'
            },
        }
    end

    local use = packer.use
    packer.reset()

    use 'wbthomason/packer.nvim'

    use { 'lewis6991/impatient.nvim', rocks = 'mpack' }

    use 'bfrg/vim-cpp-modern'

    use 'bluz71/vim-nightfly-guicolors'
    use 'mhartington/oceanic-next'
    --'bluz71/vim-moonfly-colors',
    --'joshdick/onedark.vim',
    --'morhetz/gruvbox',

    use {
        'folke/tokyonight.nvim', branch = 'main',
        config = function()
            vim.g.oceanic_next_terminal_italic=1
            vim.g.oceanic_next_terminal_bold=1
            vim.g.tokyonight_italic_functions = true
            vim.cmd [[colorscheme tokyonight]]
            --vim.cmd [[colorscheme OceanicNext]]
            --vim.cmd [[colorscheme nightfly]]
        end,
    }

    use {
        'EdenEast/nightfox.nvim',
        config = function()
            vim.g.nightfox_italic_comments = true
            vim.g.nightfox_italic_functions = true
            --vim.cmd [[colorscheme nightfox]]
        end
    }

    use {
        'famiu/bufdelete.nvim',
        cmd = { 'Bdelete', 'Bwipeout' },
        setup = function()
            local map = require('utils').map
            map('',  '<leader>bd', '<cmd>Bdelete!<CR>', { silent = true, nowait = true })
            map('',  '<c-q>',      '<cmd>Bdelete!<CR>', { silent = true, nowait = true })
        end,
    }

    use {
        'junegunn/fzf',
        run = function() fn['fzf#install']() end,
        opt = true,
        --requires = 'junegunn/fzf.vim',
        --requires = {
            --{ 'ibhagwan/fzf-lua',
                --requires = {
                    --'vijaymarupudi/nvim-fzf',
                    --'kyazdani42/nvim-web-devicons'
                --}
            --}
        --},
        --config = [[require('config.fzf')]]
    }

    use {
        'nvim-lua/plenary.nvim',
        config = function()
            require('plenary.filetype').add_file('overrides')
        end
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim', after = 'telescope.nvim' },
            { 'fannheyward/telescope-coc.nvim', after = 'telescope.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        },
        cmd = { 'Telescope', 'Tgrep' },
        setup = [[require('config.telescope_setup')]],
        config = [[require('config.telescope')]]
    }

    use {
        'junegunn/vim-easy-align',
        config = function()
            local map = require('utils').map
            map({'n', 'x'}, 'ga', '<plug>(EasyAlign)', { noremap = false })
        end
    }

    use 'justinmk/vim-dirvish'
    use { 'tpope/vim-dispatch', cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }
    use { 'tpope/vim-eunuch', cmd = { 'Delete', 'Unlink', 'Move', 'Rename', 'Mkdir' } }
    use {
        'tpope/vim-fugitive',
        config = function()
            local map = require('utils').map
            map('n', '<leader>gg', '<cmd>Git blame<CR>')
            map('n', '<leader>gd', '<cmd>Gdiff<CR>')
        end
    }

    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim', after = 'gitsigns.nvim' },
        event = 'BufRead',
        config = function()
            require('gitsigns').setup{ current_line_blame = true }
        end
    }

    use 'scrooloose/nerdcommenter'

    use 'kyazdani42/nvim-web-devicons'

    use {
        'nvim-treesitter/nvim-treesitter',
        requires = 'nvim-treesitter/playground',
        run = ':TSUpdate',
        config = [[require('config.treesitter')]]
    }

    use {
        'shadmansaleh/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
            'folke/tokyonight.nvim'
        },
        config = [[require('config.lualine')]]
    }

    use {
        'akinsho/nvim-bufferline.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = [[require('config.bufferline')]],
    }

    use {
        'jdrouhard/buftabline.nvim',
        opt = true,
        requires = 'kyazdani42/nvim-web-devicons',
        config = [[require('config.buftabline')]]
    }

    use {
        'neoclide/coc.nvim',
        disable = use_builtin_lsp,
        branch = 'release',
        --requires = {
            --'antoinemadec/coc-fzf'
        --},
        event = 'BufRead',
        setup = function()
            vim.g.coc_default_semantic_highlight_groups = true
        end,
        config = [[require('config.coc')]]
    }

    use {
        'neovim/nvim-lspconfig',
        disable = not use_builtin_lsp,
        requires = {
            'ojroques/nvim-lspfuzzy',
            { 'hrsh7th/nvim-compe', requires = 'hrsh7th/vim-vsnip' }
        },
        config = [[require('lsp_config')]]
    }

    use { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = [[vim.g.startuptime_tries = 10]] }

end

local plugins = setmetatable({}, {
    __index = function(_, key)
        init()
        return packer[key]
    end,
})

return plugins
