local api = vim.api
local lspconfig = require('lspconfig')
local status = require('config.lsp.status')
local clangd_ext = require('config.lsp.clangd_ext')
local sumneko_ext = require('config.lsp.sumneko_ext')
local fzf_config = require('config.fzf')

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

vim.fn.sign_define('LightBulbSign', { text = '', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' })

local au_group = api.nvim_create_augroup('lsp_aucmds', {})

local function on_attach(client, bufnr)
  local function buf_map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true })
  end

  status.on_attach()

  local fzf_list = function(jump_single)
    return {
      on_list = function(result)
        fzf_config.locations({ prompt = result.title, items = result.items, jump_to_single_result = jump_single })
      end
    }
  end

  buf_map('n', 'gD', function() vim.lsp.buf.declaration(fzf_list()) end)
  buf_map('n', 'gd', function() vim.lsp.buf.definition(fzf_list()) end)
  buf_map('n', 'gi', function() vim.lsp.buf.implementation(fzf_list()) end)
  buf_map('n', 'gTD', function() vim.lsp.buf.type_definition(fzf_list()) end)
  buf_map('n', 'gr', function() vim.lsp.buf.references(nil, fzf_list(false)) end)
  buf_map('n', 'gws', function() vim.lsp.buf.workspace_symbol(vim.fn.expand('<cword>'), fzf_list(false)) end)

  buf_map('n', 'K', vim.lsp.buf.hover)
  buf_map('n', '<leader>ac', vim.lsp.buf.code_action)
  buf_map('n', '<leader>rn', vim.lsp.buf.rename)
  buf_map('n', ']e', vim.diagnostic.goto_next)
  buf_map('n', '[e', vim.diagnostic.goto_prev)

  buf_map({ 'n', 'i', 's' }, '<C-g>', vim.lsp.buf.signature_help)

  if client.server_capabilities.documentFormattingProvider then
    buf_map('n', '<leader>f', vim.lsp.buf.format)
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    buf_map('x', '<leader>f', vim.lsp.buf.format)
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
  sumneko_lua = {
    cmd = { 'lua-language-server' },
    handlers = sumneko_ext.handlers,
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        runtime = { version = 'LuaJIT' },
        workspace = {
          library = api.nvim_get_runtime_file('', true),
        },
        telemetry = { enable = false },
      },
    },
  },
  rust_analyzer = {
    cmd = { 'rustup', 'run', 'stable', 'rust-analyzer' },
  },
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

for client, config in pairs(servers) do
  config.on_attach = on_attach
  config.capabilities = vim.tbl_deep_extend(
    'keep',
    config.capabilities or {},
    capabilities
  )
  lspconfig[client].setup(config)
end
