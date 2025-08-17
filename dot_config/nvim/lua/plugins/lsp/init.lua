local M = {
  'neovim/nvim-lspconfig',
  event = { 'VeryLazy', 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  cond = require('globals').native_lsp and not vim.g.vscode,
  dependencies = {
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          'luvit-meta/library',
          '~/.hammerspoon/Spoons/EmmyLua.spoon/annotations',
        },
      },
      dependencies = {
        { 'Bilal2453/luvit-meta' },
      }
    },
  },
}

function M.config()
  local api = vim.api
  local fn = vim.fn
  local lsp = vim.lsp

  local util = require('plugins.lsp.util')
  local status = require('plugins.lsp.status')
  local clangd_ext = require('plugins.lsp.clangd_ext')
  local lua_ls_ext = require('plugins.lsp.lua_ls_ext')

  lsp.set_log_level('OFF')

  local use_float_progress = false
  status.setup(not use_float_progress)
  if use_float_progress then
    require('plugins.lsp.float_progress').setup()
  end

  local function on_attach(client, bufnr)
    local au_group = api.nvim_create_augroup('lsp_aucmds:' .. bufnr, {})

    local function buf_map(mode, lhs, rhs)
      local map = vim.keymap.set
      map(mode, lhs, rhs, { buffer = true, silent = true, nowait = true })
    end

    if require('globals').fzflua then
      local fzf_config = require('plugins.fzf-lua')
      local fzf_list = function(label, jump_single)
        return {
          on_list = function(result)
            fzf_config.locations({
              label = label,
              items = result.items,
              jump1 = jump_single
            })
          end
        }
      end

      buf_map('n', 'gD', function() lsp.buf.declaration(fzf_list('Declarations')) end)
      buf_map('n', 'gd', function() lsp.buf.definition(fzf_list('Definitions')) end)
      buf_map('n', 'gi', function() lsp.buf.implementation(fzf_list('Implementations')) end)
      buf_map('n', 'gTD', function() lsp.buf.type_definition(fzf_list('Type Definitions')) end)
      buf_map('n', 'gr', function() lsp.buf.references(nil, fzf_list('References', false)) end)
      buf_map('n', 'gws',
        function() lsp.buf.workspace_symbol(fn.expand('<cword>'), fzf_list('Workspace Symbols', false)) end)
    else
      local picker = require('snacks.picker')
      local opts = { jump = { reuse_win = false } }
      buf_map('n', 'gD', function() picker.lsp_declarations(opts) end)
      buf_map('n', 'gd', function() picker.lsp_definitions(opts) end)
      buf_map('n', 'gi', function() picker.lsp_implementations(opts) end)
      buf_map('n', 'gTD', function() picker.lsp_type_definitions(opts) end)
      buf_map('n', 'gr', function() picker.lsp_references(opts) end)
      buf_map('n', 'gws', function() picker.lsp_workspace_symbols() end)
    end

    buf_map({ 'n', 'v' }, '<leader>ac', lsp.buf.code_action)
    buf_map('n', '<leader>rn', lsp.buf.rename)
    buf_map('n', ']e',
      function() vim.diagnostic.jump({ count = 1, severity = { min = vim.diagnostic.severity.ERROR } }) end)
    buf_map('n', '[e',
      function() vim.diagnostic.jump({ count = -1, severity = { min = vim.diagnostic.severity.ERROR } }) end)

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
      local captures = vim.treesitter.get_captures_at_pos(ev.buf, token.line, token.start_col)
      for _, capture in ipairs(captures) do
        if capture.capture == 'variable.builtin' then
          lsp.semantic_tokens.highlight_token(token, ev.buf, ev.data.client_id,
            '@variable.builtin.' .. vim.bo[ev.buf].filetype)
          return
        end
      end
      if token.type == 'parameter' and not token.modifiers.declaration and not token.modifiers.definition then
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
        fallbackFlags = { '-std=c++23' },
      },
    },
    basedpyright = {},
    lua_ls = {
      handlers = lua_ls_ext.handlers,
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
        },
      },
    },
    rust_analyzer = {
      cmd = { 'rustup', 'run', 'stable', 'rust-analyzer' },
    },
  }

  local capabilities = { textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } }
  capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

  lsp.config('*', { capabilities = capabilities })

  local function setup(server, opts)
    lsp.config(server, opts or servers[server] or {})
    lsp.enable(server)
  end

  for server, opts in pairs(servers) do
    setup(server, opts)
  end
end

return M
