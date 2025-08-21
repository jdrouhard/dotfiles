local api = vim.api
local fn = vim.fn

api.nvim_create_user_command('StripTrailingWhitespace', '<line1>,<line2>s/\\s\\+$//e | noh | norm! ``', { range = '%' })

local init = api.nvim_create_augroup('init', {})

local autocmds = {
  { 'FileType',    { pattern = { 'cmake', 'xml', 'lua' }, command = [[setlocal tabstop=2 | setlocal shiftwidth=2]], } },
  { 'FileType',    { pattern = { 'cpp', 'python' }, command = [[setlocal textwidth=90 | setlocal formatoptions=crqnj]], } },
  { 'FileType',    { pattern = 'gitcommit', command = [[setlocal formatlistpat=^\\s*[0-9*-]\\+[\\]:.)}\\t\ ]\\s* | setlocal formatoptions+=n]], } },
  { 'FileType',    { pattern = 'checkhealth', callback = function(args) vim.bo[args.buf].syntax = 'ON' end } },
  { 'VimResized',  { command = [[exec "normal! \<c-w>="]], } },
  { 'BufReadPost', { command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]], } },
}

for _, autocmd in ipairs(autocmds) do
  api.nvim_create_autocmd(autocmd[1], vim.tbl_extend('force', { group = init }, autocmd[2]))
end

vim.filetype.add({
  filename = {
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
  },
  pattern = {
    ["docker%-compose%..*%.ya?ml"] = "yaml.docker-compose",
    ["compose%..*%.ya?ml"] = "yaml.docker-compose",
  }
})

-- Copy yanked text to system clipboard
api.nvim_create_autocmd('TextYankPost', {
  group = init,
  desc = 'Copy to clipboard',
  callback = function()
    if vim.v.operator == 'y' then
      local yank_data = fn.getreg(vim.v.event.regname)
      if fn.has('clipboard') == 1 then
        pcall(fn.setreg, '+', yank_data)
      end
    end
  end
})
