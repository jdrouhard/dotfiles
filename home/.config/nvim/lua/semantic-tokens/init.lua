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

  M.reset()

  cmd[[augroup semantic_tokens]]
  cmd[[autocmd!]]
  cmd[[autocmd ColorScheme * lua require('semantic-tokens').reset()]]
  cmd[[augroup END]]
end

function M.reset()
  set_default_highlight_groups()
  highlight.reset()
end

return M
