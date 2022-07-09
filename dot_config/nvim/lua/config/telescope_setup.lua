local map = vim.keymap.set

local function grep()
    vim.ui.input({ prompt = "Grep For > " }, function(term)
      if not term or term == '' then
          return
      end
      return require('telescope.builtin').grep_string({ search = term })
    end)
end

map('n', '<leader>s', grep)
map('n', '<leader>ag', '<cmd>Telescope grep_string<CR>')
map('n', '<leader>rg', '<cmd>Telescope live_grep<CR>')
--map('n', '<leader>AG', '<cmd>Telescope grep_cWORD<CR>')
--map('x', '<leader>ag', '<cmd>Telescope grep_visual<CR>')

map('n', '<c-p>',       '<cmd>Telescope find_files<CR>')
map('n', '<leader>l',   '<cmd>Telescope buffers<CR>')
map('n', '<leader>t',   '<cmd>Telescope git_files<CR>')
map('n', '<leader>h',   '<cmd>Telescope commands<CR>')
map('n', '<leader>?',   '<cmd>Telescope help_tags<CR>')
map('n', '<leader>gs',  '<cmd>Telescope git_status<CR>')
map('n', '<leader>gl',  '<cmd>Telescope git_commits<CR>')
map('n', '<leader>gbl', '<cmd>Telescope git_bcommits<CR>')
map('n', '<leader>qf',  '<cmd>Telescope quickfix<CR>')

map('n', 'gr',          '<cmd>Telescope coc references<CR>')

vim.g.coc_enable_locationlist = false

local au_group = vim.api.nvim_create_augroup('telescope_coc', {})
vim.api.nvim_create_autocmd('User', {
  group = au_group,
  pattern = 'CocLocationsChange',
  command = 'Telescope coc locations',
  nested = true,
})
