local cmd = vim.cmd
local utils = require('utils')
local buf_map = utils.buf_map
local lspconfig = require('lspconfig')
local lsp_status = require('lsp_status')
local lsp_clangd_ext = require('lsp_clangd_ext')

local function on_attach(client)
    lsp_status.on_attach()
    --require('lsp_signature').on_attach { bind = true, handler_opts = { border = 'single' } }

    buf_map('n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<CR>')
    --buf_map('n', 'gd',         '<cmd>lua require"telescope.builtin".lsp_definitions()<CR>')
    buf_map('n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>')
    buf_map('n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>')
    --buf_map('n', 'gi',         '<cmd>lua require"telescope.builtin".lsp_implementations()<CR>')
    buf_map('n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>')
    buf_map('n', 'gS',         '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    buf_map('n', 'gTD',        '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    buf_map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    --buf_map('n', 'gr',         '<cmd>lua require"telescope.builtin".lsp_references()<CR>')
    --buf_map('n', '<leader>ac', '<cmd>lua require"telescope.builtin".lsp_code_actions()<CR>')
    buf_map('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>')
    buf_map('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>')
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

    cmd [[augroup lsp_aucmds]]
    if client.resolved_capabilities.document_highlight then
        cmd [[au CursorHold <buffer> lua vim.lsp.buf.document_highlight()]]
        cmd [[au CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
    end
    if client.resolved_capabilities.semantic_tokens_full then
        cmd [[au BufEnter,CursorHold,InsertLeave <buffer> lua require'vim.lsp.semantic_tokens'.refresh()]]
    end
    cmd [[au CursorMoved <buffer> lua require('utils').lsp_cancel_pending_requests()]]

    cmd [[au CursorHold,CursorHoldI <buffer> lua require('nvim-lightbulb').update_lightbulb() ]]
    cmd [[augroup END]]
end

lsp_status.setup()
vim.fn.sign_define('LightBulbSign', { text = "", texthl = "LspDiagnosticsDefaultInformation", linehl="", numhl="" })

local servers = {
  clangd = {
    cmd = { 'clangd', '--header-insertion=never' },
    handlers = lsp_clangd_ext.handlers,
    init_options = {
        clangdFileStatus = true
    },
  },
  jedi_language_server = {},
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits', }
}
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

for client, config in pairs(servers) do
  config.on_attach = on_attach
  config.capabilities = vim.tbl_deep_extend(
    'keep',
    config.capabilities or {},
    capabilities
  )
  lspconfig[client].setup(config)
end
