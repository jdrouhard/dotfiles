local cmd = vim.cmd
local utils = require('utils')
local buf_map = utils.buf_map
local lsp_status = require('lsp_status')
local lsp_clangd_ext = require('lsp_clangd_ext')

local function on_attach(client)
    --require('lsp_signature').on_attach { bind = true, handler_opts = { border = 'single' } }

    buf_map('n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<CR>')
    buf_map('n', 'gd',         '<cmd>lua require"telescope.builtin".lsp_definitions()<CR>')
    buf_map('n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>')
    buf_map('n', 'gi',         '<cmd>lua require"telescope.builtin".lsp_implementations()<CR>')
    buf_map('n', 'gS',         '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    buf_map('n', 'gTD',        '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    buf_map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    buf_map('n', 'gr',         '<cmd>lua require"telescope.builtin".lsp_references()<CR>')
    buf_map('n', '<leader>ac', '<cmd>lua require"telescope.builtin".lsp_code_actions()<CR>')
    --buf_map('n', 'gA',         '<cmd>lua vim.lsp.buf.code_action()<CR>')
    buf_map('n', ']e',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
    buf_map('n', '[e',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')

    if client.resolved_capabilities.document_formatting then
        buf_map('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
    end

    if client.resolved_capabilities.document_range_formatting then
        -- TODO: support <cmd> with a smart function to get *current* visual selection
        -- Follow neovim/neovim#13896
        buf_map('x', '<leader>f', ':lua vim.lsp.buf.range_formatting()<CR>')
    end

    cmd 'augroup lsp_aucmds'
    if client.resolved_capabilities.document_highlight then
        cmd 'au CursorHold <buffer> lua vim.lsp.buf.document_highlight()'
        cmd 'au CursorMoved <buffer> lua vim.lsp.buf.clear_references()'
    end

    --cmd 'au CursorHold,CursorHoldI <buffer> lua require"nvim-lightbulb".update_lightbulb {sign = {enabled = false}, virtual_text = {enabled = true, text = ""}, float = {enabled = false, text = "", win_opts = {winblend = 100, anchor = "NE"}}}'
    cmd 'augroup END'
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits', }
}
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

require('lspconfig').clangd.setup {
    cmd = { 'clangd', '--header-insertion=never' },
    on_attach = on_attach,
    handlers = lsp_clangd_ext.handlers,
    init_options = {
        clangdFileStatus = true
    },
    capabilities = capabilities,
}
