local api = vim.api
local lspconfig = require('lspconfig')
local status = require('config.lsp.status')
local clangd_ext = require('config.lsp.clangd_ext')

local use_float_progress = true
status.setup(not use_float_progress)
if use_float_progress then
  require('config.lsp.float_progress').setup()
end

require('semantic-tokens').setup()

--require('lsp_signature').setup({
--  bind = true,
--  toggle_key = '<C-g>',
--  handler_opts = {
--    border = 'none'
--  }
--})

vim.fn.sign_define('LightBulbSign', { text = '', texthl = 'DiagnosticSignWarn', linehl='', numhl='' })

local au_group = api.nvim_create_augroup('lsp_aucmds', {})

local function on_attach(client, bufnr)
    local function buf_map(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true })
    end

    status.on_attach()

    buf_map('n', 'gD',         function() require('fzf-lua').lsp_declarations() end)
    buf_map('n', 'gd',         function() require('fzf-lua').lsp_definitions() end)
    buf_map('n', 'gi',         function() require('fzf-lua').lsp_implementations() end)
    buf_map('n', 'gTD',        function() require('fzf-lua').lsp_typedefs() end)
    buf_map('n', 'gr',         function() require('fzf-lua').lsp_references() end)
    buf_map('n', '<leader>ac', function() require('fzf-lua').lsp_code_actions() end)
    buf_map('n', 'K',          vim.lsp.buf.hover)
    buf_map('n', '<leader>rn', vim.lsp.buf.rename)
    buf_map('n', ']e',         vim.diagnostic.goto_next)
    buf_map('n', '[e',         vim.diagnostic.goto_prev)

    buf_map({'n','i','s'}, '<C-g>', vim.lsp.buf.signature_help)

    --buf_map('n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<CR>')
    --buf_map('n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>')
    --buf_map('n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>')
    --buf_map('n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>')
    --buf_map('n', 'gS',         '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    --buf_map('n', 'gTD',        '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    --buf_map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    --buf_map('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>')
    --buf_map('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    --buf_map('n', ']e',         '<cmd>lua vim.diagnostic.goto_next()<CR>')
    --buf_map('n', '[e',         '<cmd>lua vim.diagnostic.goto_prev()<CR>')

    if client.server_capabilities.documentFormattingProvider then
        if vim.fn.has('nvim-0.8') > 0 then
          buf_map('n', '<leader>f', vim.lsp.buf.format)
        else
          buf_map('n', '<leader>f', vim.lsp.buf.formatting_sync)
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
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
        desc = 'lsp.buf.document_highlight',
      })
      api.nvim_create_autocmd('CursorMoved', {
        group = au_group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
        desc = 'lsp.buf.clear_references',
      })
    end
    if client.server_capabilities.semanticTokensProvider then
      local has_semantic_tokens, semantic_tokens = pcall(require, 'vim.lsp.semantic_tokens')
      if has_semantic_tokens then
        api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
          group = au_group,
          buffer = bufnr,
          callback = function() semantic_tokens.refresh(bufnr) end,
          desc = 'lsp.semantic_tokens.refresh',
        })
      end
    end
    api.nvim_create_autocmd({ 'CursorMoved', 'BufLeave' }, {
      group = au_group,
      buffer = bufnr,
      callback = function() require('utils').lsp_cancel_pending_requests() end,
      desc = 'lsp.cancel_pending_requests',
    })

    api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = au_group,
      buffer = bufnr,
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
