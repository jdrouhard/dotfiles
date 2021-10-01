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
        }
    end

    local use = packer.use
    packer.reset()

    use 'wbthomason/packer.nvim'

    use 'lewis6991/impatient.nvim'

    use 'bfrg/vim-cpp-modern'

    use 'EdenEast/nightfox.nvim'
    use 'bluz71/vim-nightfly-guicolors'
    use 'folke/tokyonight.nvim'
    use 'mhartington/oceanic-next'
    --'bluz71/vim-moonfly-colors',
    --'joshdick/onedark.vim',
    --'morhetz/gruvbox',

    use {
        'mhinz/vim-sayonara',
        cmd = 'Sayonara',
        setup = function()
            local map = require('utils').map
            map('', '<c-q>', '<cmd>Sayonara!<CR>', {silent = true, nowait = true})
        end,
    }

    use {
        'junegunn/fzf',
        run = function() fn['fzf#install']() end,
        opt = true,
        --requires = 'junegunn/fzf.vim',
    }

    use {
        {
            'ibhagwan/fzf-lua',
            requires = {
                'nvim-fzf',
                'plenary.nvim',
                'kyazdani42/nvim-web-devicons'
            },
            wants = {'nvim-fzf', 'plenary.nvim' },
            cmd = { 'FzfLua', 'FzfCocLocations' },
            --setup = [[require('config.fzf_setup')]],
            config = [[require('config.fzf')]],
            module = 'fzf',
        },
        {
            'vijaymarupudi/nvim-fzf',
            after = 'fzf-lua'
        }
    }

    use {
        'nvim-lua/plenary.nvim',
        opt = true,
        config = function()
            require('plenary.filetype').add_file('overrides')
        end
    }

    use {
        {
            'nvim-telescope/telescope.nvim',
            requires = {
                'plenary.nvim',
                'telescope-coc.nvim',
                'telescope-fzf-native.nvim',
            },
            wants = {
                'plenary.nvim',
                'telescope-coc.nvim',
                'telescope-fzf-native.nvim'
            },
            cmd = { 'Telescope', 'Tgrep' },
            setup = [[require('config.telescope_setup')]],
            config = [[require('config.telescope')]],
            module = 'telescope',
        },
        {
            'fannheyward/telescope-coc.nvim',
            after = 'telescope.nvim'
        },
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            after = 'telescope.nvim',
            run = 'make'
        }
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
        requires = 'plenary.nvim',
        wants = 'plenary.nvim',
        event = 'BufRead',
        config = function()
            require('gitsigns').setup{ current_line_blame = true }
        end
    }

    use {
        'scrooloose/nerdcommenter',
        event = 'BufRead',
    }

    use {
        'kyazdani42/nvim-web-devicons',
        config = function() require('nvim-web-devicons').setup({
            override = {
                ["tex"] = {
                    icon = '⁦'.. 'ﭨ' .. '⁩',
                    color = "#3D6117",
                    name = "Tex"
                }
            }
        })
        end,
    }

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
        'neoclide/coc.nvim',
        disable = use_builtin_lsp,
        branch = 'release',
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
