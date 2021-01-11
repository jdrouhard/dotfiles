local lsp_status = require 'lsp_status'
local lsp_clangd_ext = require 'lsp_clangd_ext'

local custom_lsp_attach = function(client)
    -- See `:help nvim_buf_set_keymap()` for more information
    vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<F3>', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true})

    -- Use LSP as the handler for omnifunc.
    --    See `:help omnifunc` and `:help ins-completion` for more information.
    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- For plugins with an `on_attach` callback, call them here. For example:
    require'completion'.on_attach(client)
end

require'lspconfig'.clangd.setup {
    cmd = { 'clangd', '--header-insertion=never' },
    on_attach = custom_lsp_attach,
    handlers = lsp_clangd_ext.handlers,
    init_options = {
        clangdFileStatus = true
    },
}

require'lspfuzzy'.setup {}
