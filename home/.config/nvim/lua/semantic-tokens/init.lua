local api = vim.api
local cmd = vim.cmd

local config = require('semantic-tokens.config')
local highlight = require('semantic-tokens.highlight')
local st_util = require('semantic-tokens.util')

--TODO: config or util?
local function set_default_highlight_groups()
  if not config.options.use_default_highlight_groups then return end

  for name, links in pairs(config.options.default_highlight_groups) do
    local hl = links[1]
    if not st_util.highlight_exists(hl) then
      hl = links[2]
    end
    if hl then
      vim.cmd(string.format('highlight default link %s %s', st_util.format_hl_name(config.options.prefix, name), hl))
    end
  end
end

local function reset()
  set_default_highlight_groups()
  highlight.reset()
end

local M = {}

function M.setup(opts)
  config.set_config(opts or {})

  local ok, semantic_tokens = pcall(require, 'vim.lsp.semantic_tokens')
  if not ok then return end

  vim.lsp.handlers['textDocument/semanticTokens/full'] =
    vim.lsp.with(semantic_tokens.on_full, {
      on_token = highlight.highlight_token,
      on_invalidate_range = highlight.invalidate_highlight,
    })

  reset()

  local semantic_tokens_group = api.nvim_create_augroup('semantic_tokens', {})
  api.nvim_create_autocmd('ColorScheme', {
    group = semantic_tokens_group,
    callback = reset,
    desc = 'semantic-tokens: reset highlight groups and token mapping cache',
  })
end

return M
