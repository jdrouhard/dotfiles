local file_status_update = function(_, _, message, client_id)
    local client = vim.lsp.get_client_by_id(client_id)
    if not client then
        vim.api.nvim_err_writeln("LSP[id=" .. client_id .. "] client shutdown after sending the message")
    end
    if not client.status then
        client.status = {}
    end
    client.status[message.uri] = message.state;
end;

local M = {}

M.handlers = {
    ['textDocument/clangd.fileStatus'] = file_status_update
}

return M
