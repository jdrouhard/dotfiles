local report_status = function(_, message, ctx, _)
  local client_id = ctx.client_id
  local client = vim.lsp.get_client_by_id(client_id)
  if not client then
    vim.notify("LSP[id=" .. client_id .. "] client shutdown after sending the message", vim.log.levels.ERROR)
  end
  client.status = message.text
  vim.cmd.redrawstatus({ bang = true })
end;

local M = {}

M.handlers = {
  ['$/status/report'] = report_status
}

return M
