local fn = vim.fn
local utils = require'utils'
local autocmd = utils.autocmd
local map = utils.map
local packer = nil

local use_builtin_lsp = false

local function init()
    if packer == nil then
        packer = require'packer'
        packer.init {
            disable_commands = true,
            display = { open_cmd = 'vnew \\[packer\\]' }
        }
    end

    local use = packer.use
    packer.reset()

    use 'wbthomason/packer.nvim'

    use {
        'lewis6991/gitsigns.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require'gitsigns'.setup{ current_line_blame = true }
        end
    }
    use 'bfrg/vim-cpp-modern'

    use {
        'folke/tokyonight.nvim', branch = 'main',
        --use 'bluz71/vim-moonfly-colors'
        --use 'bluz71/vim-nightfly-guicolors'
        --use 'joshdick/onedark.vim'
        --use 'mhartington/oceanic-next'
        --use 'morhetz/gruvbox'

        config = function()
            vim.g.tokyonight_italic_functions = true
            vim.cmd [[colorscheme tokyonight]]
        end
    }

    use { 'ojroques/nvim-bufdel', cmd = 'BufDel' }

    use {
        'junegunn/fzf',
        run = function() fn['fzf#install']() end,
        requires = 'junegunn/fzf.vim',
        config = [[require'config.fzf']]
    }

    use {
        'junegunn/vim-easy-align',
        config = function()
            local map = require'utils'.map
            map({'n', 'x'}, 'ga', '<plug>(EasyAlign)', { noremap = false })
        end
    }

    use { 'sakhnik/nvim-gdb', run = ':UpdateRemotePlugins' }

    use 'justinmk/vim-dirvish'
    use { 'tpope/vim-dispatch', cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }
    use { 'tpope/vim-eunuch', cmd = { 'Delete', 'Unlink', 'Move', 'Rename', 'Mkdir' } }
    use {
        'tpope/vim-fugitive',
        config = function()
            local map = require'utils'.map
            map('n', '<leader>gg', '<cmd>Git blame<CR>')
            map('n', '<leader>gd', '<cmd>Gdiff<CR>')
        end
    }

    use 'scrooloose/nerdcommenter'

    use {
        'nvim-treesitter/nvim-treesitter',
        requires = 'nvim-treesitter/playground',
        run = ':TSUpdate',
        config = [[require'config.treesitter']]
    }
    use {
        'shadmansaleh/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
            'folke/tokyonight.nvim'
        },
        config = [[require'config.lualine']]
    }

    use {
        'jose-elias-alvarez/buftabline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = [[require'config.buftabline']]
    }

    use {
        'neoclide/coc.nvim',
        disable = use_builtin_lsp,
        branch = 'release',
        requires = {
            'antoinemadec/coc-fzf'
        },
        config = [[require'config.coc']]
    }

    use {
        'neovim/nvim-lspconfig',
        disable = not use_builtin_lsp,
        requires = {
            'ojroques/nvim-lspfuzzy',
            { 'hrsh7th/nvim-compe', requires = 'hrsh7th/vim-vsnip' }
        },
        config = [[require'lsp_config']]
    }

end

local plugins = setmetatable({}, {
    __index = function(_, key)
        init()
        return packer[key]
    end,
})

return plugins
