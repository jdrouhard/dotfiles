local lualine_config = require'lualine.config'.get_config()
local sections = lualine_config.sections

local function coc_status()
    local status = vim.g.coc_status or ''
    return status:gsub("%%", "%%%1")
end

local function lsp_status()
    local status = vim.g.lsp_status or ''
    return status:gsub("%%", "%%%1")
end

local function tag_name()
    local tag = vim.fn['nvim_treesitter#statusline'](90)
    return tag or vim.fn['Tlist_Get_Tagname_By_Line']()
end


table.insert(sections.lualine_b, 1, { 'diff', colored = false })
sections.lualine_c = { { 'filename', path = 1 }, coc_status, lsp_status }
table.insert(sections.lualine_x, 1, tag_name)

require'lualine'.setup{
    options = {
        theme = 'tokyonight',
        section_separators = '',
        component_separators = ''
    },
    extensions = { 'quickfix', 'fugitive', 'fzf' },
    sections = sections
}
