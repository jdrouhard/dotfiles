local fn = vim.fn
local packer = nil

local packer_repo = 'https://github.com/wbthomason/packer.nvim'
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local compile_path = fn.stdpath('data') .. '/site/lua/packer_compiled.lua'

local use_builtin_lsp = true

local function init()
    if not packer then
      packer = require('packer')
      packer.init {
        compile_path = compile_path,
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
    use 'bluz71/vim-moonfly-colors'
    use 'folke/tokyonight.nvim'
    use 'mhartington/oceanic-next'

    use {
        'mhinz/vim-sayonara',
        cmd = 'Sayonara',
        setup = function()
            vim.keymap.set('', '<c-q>', '<cmd>Sayonara!<CR>')
        end,
    }

    use {
        'junegunn/fzf',
        run = function() fn['fzf#install']() end,
        opt = true,
        --requires = 'junegunn/fzf.vim',
    }

    use {
        'ibhagwan/fzf-lua',
        requires = 'kyazdani42/nvim-web-devicons',
        cmd = { 'FzfLua', 'FzfCocLocations' },
        setup = [[require('config.fzf_setup')]],
        config = [[require('config.fzf')]],
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
            --setup = [[require('config.telescope_setup')]],
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
            vim.keymap.set({'n', 'x'}, 'ga', '<plug>(EasyAlign)', { noremap = false })
        end
    }

    use 'justinmk/vim-dirvish'
    use { 'tpope/vim-dispatch', cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }
    use { 'tpope/vim-eunuch', cmd = { 'Delete', 'Unlink', 'Move', 'Rename', 'Mkdir' } }
    use {
        'tpope/vim-fugitive',
        config = function()
            local map = vim.keymap.set
            map('n', '<leader>gg', '<cmd>Git blame<CR>')
            map('n', '<leader>gd', '<cmd>Gdiff<CR>')
        end
    }
    use 'tpope/vim-repeat'

    use {
      'haya14busa/vim-asterisk',
      config = function()
        local map = vim.keymap.set
        vim.g['asterisk#keeppos'] = true
        map({'n', 'x'}, '*',  '<plug>(asterisk-z*)',  { noremap = false })
        map({'n', 'x'}, '#',  '<plug>(asterisk-z#)',  { noremap = false })
        map({'n', 'x'}, 'g*', '<plug>(asterisk-gz*)', { noremap = false })
        map({'n', 'x'}, 'g#', '<plug>(asterisk-gz#)', { noremap = false })
      end
    }

    use {
        'lewis6991/gitsigns.nvim',
        requires = 'plenary.nvim',
        wants = 'plenary.nvim',
        event = 'BufRead',
        config = [[require('config.gitsigns')]]
    }

    use {
        'numToStr/Comment.nvim',
        event = 'BufRead',
        config = [[require('config.comment')]]
    }

    use {
        'ggandor/lightspeed.nvim',
        keys = { "s", "S", "t", "T", "f", "F" },
        requires = 'tpope/vim-repeat'
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {
          { 'nvim-treesitter/playground', after = 'nvim-treesitter' },
          { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' }
        },
        --event = 'BufRead',
        ft = { 'cpp', 'c', 'python', 'bash', 'cmake', 'lua', 'query', 'json', 'javascript' },
        run = ':TSUpdate',
        config = [[require('config.treesitter')]]
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
            'folke/tokyonight.nvim',
            'lewis6991/gitsigns.nvim',
            'SmiteshP/nvim-gps',
        },
        config = [[require('config.lualine')]]
    }

    use {
        'SmiteshP/nvim-gps',
        requires = 'nvim-treesitter/nvim-treesitter',
        after = 'nvim-treesitter',
        config = function()
          require('nvim-gps').setup()
        end,
    }

    use {
        'akinsho/nvim-bufferline.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = [[require('config.bufferline')]],
    }

    use {
      'stevearc/dressing.nvim',
      config = function()
        require('dressing').setup {
          select = {
            backend = 'fzf_lua',
          },
        }
      end,
    }

    use {
      'antoinemadec/FixCursorHold.nvim',
      setup = function()
        vim.g.cursorhold_updatetime = 100
      end
    }

    use {
        'neoclide/coc.nvim',
        cond = not use_builtin_lsp,
        branch = 'release',
        ft = { 'cpp', 'c', 'python', 'lua', 'cmake', 'json' },
        config = [[require('config.coc')]]
    }

    use {
        'neovim/nvim-lspconfig',
        cond = use_builtin_lsp,
        config = [[require('lsp_config')]],
        ft = { 'cpp', 'c', 'python', 'lua' },
    }

    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'L3MON4D3/LuaSnip',
            'hrsh7th/cmp-nvim-lsp',
            'onsails/lspkind-nvim',
            { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
            { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        },
        config = [[require('config.cmp')]],
        event = { 'InsertEnter *', 'CmdlineEnter' },
    }

    use {
        'kosayoda/nvim-lightbulb',
        event = 'BufRead'
    }

    use { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = [[vim.g.startuptime_tries = 10]] }

end

local plugins = setmetatable({}, {
  __index = function(_, key)
    if not packer then
      init()
    end
    return packer[key]
  end,
})

function plugins.bootstrap()
  local api = vim.api
  local cmd = vim.cmd

  api.nvim_create_augroup('plugins', {})
  if fn.empty(fn.glob(install_path)) > 0 then
    api.nvim_echo({{'Installing packer.nvim', 'Type'}}, true, {})
    fn.system({'git', 'clone', packer_repo, install_path})
    api.nvim_command('packadd packer.nvim')
    api.nvim_create_autocmd('User', {
      group = 'plugins',
      pattern = 'PackerComplete',
      once = true,
      nested = true,
      command = [[luafile $MYVIMRC]],
    })
    plugins.sync()
  else
    require('packer_compiled')

    cmd [[command! PackerInstall           lua require('plugins').install()]]
    cmd [[command! PackerUpdate            lua require('plugins').update()]]
    cmd [[command! PackerSync              lua require('plugins').sync()]]
    cmd [[command! PackerClean             lua require('plugins').clean()]]
    cmd [[command! -nargs=* PackerCompile  lua require('plugins').compile(<q-args>)]]
    cmd [[command! PackerStatus            lua require('plugins').status()]]
    cmd [[command! PackerProfile           lua require('plugins').profile_output()]]
    cmd [[command! -nargs=+ -complete=customlist,v:lua.require('plugins').loader_complete PackerLoad lua require('plugins').loader(<q-args>)]]

    api.nvim_create_autocmd('BufWritePost', {
      group = 'plugins',
      pattern = 'plugins.lua',
      command = [[source <afile> | execute "lua package.loaded['plugins'] = nil" | PackerCompile]]
    })
  end
end

return plugins
