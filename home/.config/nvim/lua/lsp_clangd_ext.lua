local file_status_update = function(_, message, ctx, _)
    local client_id = ctx.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    if not client then
        vim.notify("LSP[id=" .. client_id .. "] client shutdown after sending the message", vim.log.levels.ERROR)
        vim.api.nvim_command('redrawstatus')
    end
    if not client.status then
        client.status = {}
    end
    client.status[message.uri] = message.state ~= 'idle' and message.state or nil;
end;

local M = {}

M.handlers = {
    ['textDocument/clangd.fileStatus'] = file_status_update
}

return M
