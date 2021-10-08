local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local execute = vim.api.nvim_command
local autocmd = require('utils').autocmd

local packer_repo = 'https://github.com/wbthomason/packer.nvim'
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    api.nvim_echo({{'Installing packer.nvim', 'Type'}}, true, {})
    fn.system({'git', 'clone', packer_repo, install_path})
    execute('packadd packer.nvim')
    autocmd('bootstrap', {
        [[VimEnter * ++once lua require('plugins').sync()]],
        [[User PackerComplete ++once luafile $MYVIMRC]]
    })
    package.loaded['bootstrap'] = nil
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
end
