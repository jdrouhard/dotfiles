local api = vim.api
local lspconfig = require('lspconfig')
local status = require('config.lsp.status')
local clangd_ext = require('config.lsp.clangd_ext')

status.setup()
require('semantic-tokens').setup()
vim.fn.sign_define('LightBulbSign', { text = '', texthl = 'DiagnosticSignWarn', linehl='', numhl='' })

local au_group = api.nvim_create_augroup('lsp_aucmds', {})

local function on_attach(client)
    local function buf_map(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true })
    end

    status.on_attach()
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
    buf_map('n', ']e',         '<cmd>lua vim.diagnostic.goto_next()<CR>')
    buf_map('n', '[e',         '<cmd>lua vim.diagnostic.goto_prev()<CR>')

    if client.server_capabilities.documentFormattingProvider then
        if vim.fn.has('nvim-0.8') > 0 then
          buf_map('n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>')
        else
          buf_map('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting_sync()<CR>')
        end
    end

    if client.server_capabilities.documentRangeFormattingProvider then
        -- TODO: support <cmd> with a smart function to get *current* visual selection
        -- Follow neovim/neovim#13896
        buf_map('x', '<leader>f', ':lua vim.lsp.buf.range_formatting()<CR>')
    end

    if client.server_capabilities.documentHighlightProvider then
      api.nvim_create_autocmd('CursorHold', {
        group = au_group,
        buffer = 0,
        callback = vim.lsp.buf.document_highlight,
        desc = 'lsp.buf.document_highlight',
      })
      api.nvim_create_autocmd('CursorMoved', {
        group = au_group,
        buffer = 0,
        callback = vim.lsp.buf.clear_references,
        desc = 'lsp.buf.clear_references',
      })
    end
    if client.server_capabilities.semanticTokensProvider then
      api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        group = au_group,
        buffer = 0,
        callback = function() require('vim.lsp.semantic_tokens').refresh(vim.api.nvim_get_current_buf()) end,
        desc = 'lsp.semantic_tokens.refresh',
      })
    end
    api.nvim_create_autocmd({ 'CursorMoved', 'BufLeave' }, {
      group = au_group,
      buffer = 0,
      callback = function() require('utils').lsp_cancel_pending_requests() end,
      desc = 'lsp.cancel_pending_requests',
    })

    api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = au_group,
      buffer = 0,
      callback = function() require('nvim-lightbulb').update_lightbulb() end,
      desc = 'nvim-lightbulb.update_lightbulb',
    })
end

local servers = {
  clangd = {
    cmd = { 'clangd', '--header-insertion=never' },
    handlers = clangd_ext.handlers,
    init_options = {
        clangdFileStatus = true,
        fallbackFlags = { '-std=c++20' },
    },
  },
  pyright = {},
}

local capabilities = { textDocument = { completion = { completionItem = {}}}}
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
