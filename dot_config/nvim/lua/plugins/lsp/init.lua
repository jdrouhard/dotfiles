local api = vim.api
local fn = vim.fn
local lsp = vim.lsp

local M = {
  'neovim/nvim-lspconfig',
  event = { 'VeryLazy', 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  cond = require('globals').native_lsp and not vim.g.vscode,
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',

    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          'luvit-meta/library',
        },
      },
    },
    { 'Bilal2453/luvit-meta', lazy = true },
    {
      'kosayoda/nvim-lightbulb',
      opts = {
        sign = {
          text = '󰌶',
          hl = 'DiagnosticSignWarn',
        },
      }
    },
  },
}

function M.config()
  lsp.set_log_level('OFF')

  local util = require('plugins.lsp.util')
  local status = require('plugins.lsp.status')
  local clangd_ext = require('plugins.lsp.clangd_ext')
  local lua_ls_ext = require('plugins.lsp.lua_ls_ext')
  local fzf_config = require('plugins.fzf-lua')

  local use_float_progress = false
  status.setup(not use_float_progress)
  if use_float_progress then
    require('plugins.lsp.float_progress').setup()
  end

  local function on_attach(client, bufnr)
    local au_group = api.nvim_create_augroup('lsp_aucmds:' .. bufnr, {})

    local function buf_map(mode, lhs, rhs)
      local map = vim.keymap.set
      map(mode, lhs, rhs, { buffer = true, silent = true })
    end

    local fzf_list = function(label, jump_single)
      return {
        on_list = function(result)
          fzf_config.locations({
            label = label,
            items = result.items,
            jump_to_single_result = jump_single
          })
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
      buf_map('n', 'gD', function() lsp.buf.declaration(fzf_list('Declarations')) end)
      buf_map('n', 'gd', function() lsp.buf.definition(fzf_list('Definitions')) end)
      buf_map('n', 'gi', function() lsp.buf.implementation(fzf_list('Implementations')) end)
      buf_map('n', 'gTD', function() lsp.buf.type_definition(fzf_list('Type Definitions')) end)
      buf_map('n', 'gr', function() lsp.buf.references(nil, fzf_list('References', false)) end)
      buf_map('n', 'gws',
        function() lsp.buf.workspace_symbol(fn.expand('<cword>'), fzf_list('Workspace Symbols', false)) end)
    end

    buf_map({ 'n', 'v' }, '<leader>ac', lsp.buf.code_action)
    buf_map('n', '<leader>rn', lsp.buf.rename)
    buf_map('n', ']e', vim.diagnostic.goto_next)
    buf_map('n', '[e', vim.diagnostic.goto_prev)

    buf_map({ 'n', 'i', 's' }, '<C-g>', lsp.buf.signature_help)

    buf_map('n', '<leader>tt', util.toggle_tokens)

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

    api.nvim_create_autocmd('CursorHold', {
      group = au_group,
      buffer = bufnr,
      callback = function() require('nvim-lightbulb').update_lightbulb() end,
      desc = 'nvim-lightbulb.update_lightbulb',
    })
  end

  local au_group = api.nvim_create_augroup('lsp_aucmds', {})

  api.nvim_create_autocmd('LspAttach', {
    group = au_group,
    callback = function(ev)
      local bufnr = ev.buf
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      on_attach(client, bufnr)
    end
  })

  api.nvim_create_autocmd('LspTokenUpdate', {
    group = au_group,
    callback = function(ev)
      local token = ev.data.token
      if token.type == 'parameter' and not token.modifiers.declaration then
        local name = '@lsp.typemod.parameter.reference.' .. vim.bo[ev.buf].filetype
        lsp.semantic_tokens.highlight_token(token, ev.buf, ev.data.client_id, name)
      end
    end,
    desc = 'lsp.custom_semantic_token_highlights'
  })

  api.nvim_create_autocmd('LspRequest', {
    group = au_group,
    callback = function(ev) util.track_request(ev) end,
    desc = 'lsp.track_request',
  })

  api.nvim_create_autocmd({ 'CursorMoved', 'BufLeave' }, {
    group = au_group,
    callback = function(ev) util.cancel_pending_requests(ev.buf) end,
    desc = 'lsp.cancel_pending_requests',
  })

  local servers = {
    clangd = {
      cmd = { 'clangd', '--header-insertion=never' },
      handlers = clangd_ext.handlers,
      capabilities = clangd_ext.capabilities,
      init_options = {
        clangdFileStatus = true,
        fallbackFlags = { '-std=c++20' },
      },
    },
    pyright = {},
    lua_ls = {
      cmd = { 'lua-language-server' },
      handlers = lua_ls_ext.handlers,
      settings = {
        Lua = {
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
  capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

  for client, config in pairs(servers) do
    config.capabilities = vim.tbl_deep_extend(
      'keep',
      config.capabilities or {},
      capabilities
    )
    require('lspconfig')[client].setup(config)
  end
end

return M
