local api = vim.api
local fn = vim.fn
local lsp = vim.lsp

local M = {
  'neovim/nvim-lspconfig',
  event = 'BufReadPost',
  cond = require('globals').native_lsp,
  dependencies = { 'hrsh7th/cmp-nvim-lsp' },
}

function M.config()
  require('neodev').setup({
    snippet = true,
  })

  local status = require('plugins.lsp.status')
  local clangd_ext = require('plugins.lsp.clangd_ext')
  local sumneko_ext = require('plugins.lsp.sumneko_ext')
  local semantic_tokens = require('plugins.lsp.semantic_tokens')
  local fzf_config = require('plugins.fzf-lua')

  local use_float_progress = false
  status.setup(not use_float_progress)
  if use_float_progress then
    require('plugins.lsp.float_progress').setup()
  end

  semantic_tokens.setup(require('theme').transform_token)

  fn.sign_define('LightBulbSign',
    { text = '', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' })

  local au_group = api.nvim_create_augroup('lsp_aucmds', {})

  local function on_attach(client, bufnr)
    status.on_attach()

    local function buf_map(mode, lhs, rhs)
      local map = vim.keymap.set
      map(mode, lhs, rhs, { buffer = true, silent = true })
    end

    local fzf_list = function(jump_single)
      return {
        on_list = function(result)
          fzf_config.locations({ prompt = result.title, items = result.items,
            jump_to_single_result = jump_single })
        end
      }
    end

    if require('globals').telescope then
      local builtins = require('telescope.builtin')
      --buf_map('n', 'gD', builtins.lsp_declarations)
      buf_map('n', 'gd', builtins.lsp_definitions)
      buf_map('n', 'gi', builtins.lsp_implementations)
      buf_map('n', 'gTD', builtins.lsp_type_definitions)
      buf_map('n', 'gr', builtins.lsp_references)
      buf_map('n', 'gws', builtins.lsp_workspace_symbols)
    else
      buf_map('n', 'gD', function() lsp.buf.declaration(fzf_list()) end)
      buf_map('n', 'gd', function() lsp.buf.definition(fzf_list()) end)
      buf_map('n', 'gi', function() lsp.buf.implementation(fzf_list()) end)
      buf_map('n', 'gTD', function() lsp.buf.type_definition(fzf_list()) end)
      buf_map('n', 'gr', function() lsp.buf.references(nil, fzf_list(false)) end)
      buf_map('n', 'gws',
        function() lsp.buf.workspace_symbol(fn.expand('<cword>'), fzf_list(false)) end)
    end

    buf_map('n', 'K', lsp.buf.hover)
    buf_map('n', '<leader>ac', lsp.buf.code_action)
    buf_map('n', '<leader>rn', lsp.buf.rename)
    buf_map('n', ']e', vim.diagnostic.goto_next)
    buf_map('n', '[e', vim.diagnostic.goto_prev)

    buf_map({ 'n', 'i', 's' }, '<C-g>', lsp.buf.signature_help)

    buf_map('n', '<leader>tt', require('utils').toggle_tokens)

    if client.server_capabilities.documentFormattingProvider then
      buf_map('n', '<leader>f', lsp.buf.format)
    end

    if client.server_capabilities.documentRangeFormattingProvider then
      buf_map('x', '<leader>f', lsp.buf.format)
    end

    if client.server_capabilities.documentHighlightProvider then
      api.nvim_create_autocmd('CursorHold', {
        group = au_group,
        buffer = bufnr,
        callback = lsp.buf.document_highlight,
        desc = 'lsp.buf.document_highlight',
      })
      api.nvim_create_autocmd('CursorMoved', {
        group = au_group,
        buffer = bufnr,
        callback = lsp.buf.clear_references,
        desc = 'lsp.buf.clear_references',
      })
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
          workspace = { checkThirdParty = false },
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
    require('lspconfig')[client].setup(config)
  end

end

return M
