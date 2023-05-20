local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

api.nvim_create_user_command('StripTrailingWhitespace', '<line1>,<line2>s/\\s\\+$//e | noh | norm! ``', { range = '%' })

local init = api.nvim_create_augroup('init', {})

local autocmds = {
  { 'FileType',    { pattern = { 'cmake', 'xml', 'lua' }, command = [[setlocal tabstop=2 | setlocal shiftwidth=2]], } },
  { 'FileType',    { pattern = { 'cpp', 'python' }, command = [[setlocal textwidth=90 | setlocal formatoptions=crqnj]], } },
  { 'FileType',    { pattern = 'gitcommit', command = [[setlocal formatlistpat=^\\s*[0-9*-]\\+[\\]:.)}\\t\ ]\\s* | setlocal formatoptions+=n]], } },
  { 'VimResized',  { command = [[exec "normal! \<c-w>="]], } },
  { 'BufReadPost', { command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]], } },
  { 'SwapExists',  { command = [[let v:swapchoice = 'e']], } },
}

for _, autocmd in ipairs(autocmds) do
  api.nvim_create_autocmd(autocmd[1], vim.tbl_extend('force', { group = init }, autocmd[2]))
end

local local_init = fn.resolve(fn.stdpath('data') .. '/site/init.lua')
if fn.filereadable(local_init) > 0 then
  cmd('luafile ' .. local_init)
end
