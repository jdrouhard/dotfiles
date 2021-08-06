local utils = require 'utils'
local map = utils.map
local lsp_status = require 'lsp_status'
local lsp_clangd_ext = require 'lsp_clangd_ext'

local custom_lsp_attach = function(client)
    -- See `:help nvim_buf_set_keymap()` for more information
    map('n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>')
    map('n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>')
    map('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>')
    map('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>')

    -- Use LSP as the handler for omnifunc.
    --    See `:help omnifunc` and `:help ins-completion` for more information.
    --vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- For plugins with an `on_attach` callback, call them here. For example:
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

require'lspconfig'.clangd.setup {
    cmd = { '/home/jdrouhard/clang-dev/bin/clangd', '--header-insertion=never' },
    on_attach = custom_lsp_attach,
    handlers = lsp_clangd_ext.handlers,
    init_options = {
        clangdFileStatus = true
    },
    capabilities = capabilities,
}

require'lspfuzzy'.setup {}

require'compe'.setup {
    enabled = true;
    source = {
        path = true;
        buffer = true;
        calc = true;
        nvim_lsp = true;
        vsnip = true;
    };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

map({'i', 's'}, '<Tab>',   'v:lua.tab_complete()', {expr = true, noremap = false})
map({'i', 's'}, '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true, noremap = false})
