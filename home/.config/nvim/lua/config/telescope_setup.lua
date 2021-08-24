local utils = require('utils')
local map = utils.map

local M = {}

M.grep = function()
    local term = vim.fn.input("Grep For > ")
    if not term or term == '' then
        return
    end
    return require('telescope.builtin').grep_string({ search = term })
end

vim.cmd[[command! Tgrep lua require('config.telescope').grep()]]

map('n', '<leader>s',  '<cmd>Tgrep<CR>')
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

vim.g.coc_enable_locationlist = false

vim.cmd[[
    augroup telescope_coc
        au!
        au User CocLocationsChange nested Telescope coc locations
    augroup END
]]

return M
