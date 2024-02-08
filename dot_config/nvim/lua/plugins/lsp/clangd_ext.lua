local file_status_update = function(_, message, ctx, _)
  local client_id = ctx.client_id
  local client = vim.lsp.get_client_by_id(client_id)
  if not client then
    vim.notify("LSP[id=" .. client_id .. "] client shutdown after sending the message", vim.log.levels.ERROR)
  end
  if not client.status then
    client.status = {}
  end
  client.status[message.uri] = message.state ~= 'idle' and message.state or nil
  vim.cmd.redrawstatus({ bang = true })
end

local inactive_ns = vim.api.nvim_create_namespace('inactive_regions')

local inactive_regions_update = function(_, message, _, _)
  local uri = message.textDocument.uri
  local fname = vim.uri_to_fname(uri)
  local ranges = message.regions
  if #ranges == 0 and vim.fn.bufexists(fname) == 0 then
    return
  end

  local bufnr = vim.fn.bufadd(fname)
  if not bufnr then
    return
  end

  vim.api.nvim_buf_clear_namespace(bufnr, inactive_ns, 0, -1)

  for _, range in ipairs(ranges) do
    local lnum = range.start.line
    local end_lnum = range['end'].line

    vim.api.nvim_buf_set_extmark(bufnr, inactive_ns, lnum, 0, {
      line_hl_group = 'ClangdInactive',
      end_row = end_lnum,
      hl_eol = true,
      strict = false,
      priority = vim.highlight.priorities.semantic_tokens,
    })
  end
end

local M = {}

M.handlers = {
  ['textDocument/clangd.fileStatus'] = file_status_update,
  ['textDocument/inactiveRegions'] = inactive_regions_update
}

M.capabilities = {
  textDocument = {
    inactiveRegionsCapabilities = {
      inactiveRegions = true,
    },
  },
}

return M
