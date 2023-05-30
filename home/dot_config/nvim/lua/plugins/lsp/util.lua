local api = vim.api
local tokens = vim.lsp.semantic_tokens

local M = {}

M.pending_requests = vim.defaulttable()

function M.track_request(request_event)
  local requests = M.pending_requests

  local bufnr = request_event.buf
  local client_id = request_event.data.client_id
  local request_id = request_event.data.request_id
  local request = request_event.data.request

  if request.type == 'pending' and
      not request.method:match('semanticTokens') and
      not request.method:match('documentSymbol') then
    requests[bufnr][client_id][request_id] = request
  elseif vim.tbl_get(requests, bufnr, client_id, request_id) then
    requests[bufnr][client_id][request_id] = nil
    if vim.tbl_isempty(requests[bufnr][client_id]) then
      requests[bufnr][client_id] = nil
    end
    if vim.tbl_isempty(requests[bufnr]) then
      requests[bufnr] = nil
    end
  end
end

function M.cancel_pending_requests(bufnr)
  local requests = M.pending_requests
  if not rawget(requests, bufnr) then
    return
  end
  for client_id, reqs in pairs(requests[bufnr]) do
    local client = vim.lsp.get_client_by_id(client_id)
    if client then
      for id, _ in pairs(reqs) do
        client.cancel_request(id)
      end
    end
  end
end

function M.toggle_tokens(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  local highlighter = tokens.__STHighlighter.active[bufnr]
  for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
    if not highlighter then
      tokens.start(bufnr, client.id)
    else
      tokens.stop(bufnr, client.id)
    end
  end
end

return M
