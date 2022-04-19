
local M = {}

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
