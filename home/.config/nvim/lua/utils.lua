local cmd = vim.cmd
local map_key = vim.api.nvim_set_keymap
local buf_map_key = vim.api.nvim_buf_set_keymap

local M = {}

function M.autocmd(group, cmds, clear)
  clear = clear == nil and true or clear
  if type(cmds) == 'string' then cmds = {cmds} end
  cmd('augroup ' .. group)
  if clear then cmd [[au!]] end
  for _, c in ipairs(cmds) do cmd('autocmd ' .. c) end
  cmd('augroup END')
end

local function do_map(api_fn, modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap
  opts.silent = opts.silent == nil and true or opts.silent
  if type(modes) == 'string' then modes = {modes} end
  for _, mode in ipairs(modes) do api_fn(mode, lhs, rhs, opts) end
  return opts
end

function M.map(modes, lhs, rhs, opts)
  do_map(map_key, modes, lhs, rhs, opts)
end

function M.buf_map(modes, lhs, rhs, opts)
  local function bind(...)
    return buf_map_key(0, ...)
  end
  do_map(bind, modes, lhs, rhs, opts)
end

function M.wrap_rtl_text(text)
  local lri = '⁦'
  local pdi = '⁩'
  return lri .. text .. pdi
end

function M.lsp_cancel_pending_requests(bufnr)
  vim.schedule(function()
    bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
    for _, client in ipairs(vim.lsp.buf_get_clients(bufnr)) do
      for id, request in pairs(client.requests or {}) do
        if request.type == 'pending' and request.bufnr == bufnr and not request.method:match('semanticTokens') then
          client.cancel_request(id)
        end
      end
    end
  end)
end

return M
