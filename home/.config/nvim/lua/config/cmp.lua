local api = vim.api
local cmp = require 'cmp'
local lspkind = require 'lspkind'
local luasnip = require 'luasnip'

api.nvim_del_keymap('i', '<tab>')
api.nvim_del_keymap('i', '<s-tab>')

local function check_backspace()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local feedkeys = vim.fn.feedkeys
local pumvisible = vim.fn.pumvisible
local replace_termcodes = vim.api.nvim_replace_termcodes
local backspace_keys = replace_termcodes('<Tab>', true, true, true)
local snippet_next_keys = replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true)
local snippet_prev_keys = replace_termcodes('<Plug>luasnip-jump-prev', true, true, true)

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    formatting = {
        format = lspkind.cmp_format({ with_text = true, menu = ({
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            nvim_lua = "[Lua]",
            path = "[Path]",
        })}),
    },
    mapping = {
        ['<CR>'] = cmp.mapping.confirm(),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                feedkeys(snippet_next_keys, '')
            elseif check_backspace() then
                feedkeys(backspace_keys, 'n')
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                feedkeys(snippet_prev_keys, '')
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'buffer' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'path' },
        { name = 'luasnip' },
    },
}
