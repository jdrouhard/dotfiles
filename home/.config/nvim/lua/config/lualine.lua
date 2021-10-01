local vim = vim
local fn = vim.fn
local b = vim.b
local g = vim.g
local lualine_config = require('lualine.config').get_config()
local sections = lualine_config.sections

local function git_info()
    local info = b.gitsigns_status or ''
    if info ~= '' then
        info = info .. '  '
    end
    local head = b.gitsigns_head or ''
    if head ~= '' then
        head = ' ' .. head
    end
    return info .. head
end

local function coc_status()
    local status = g.coc_status or ''
    return status:gsub("%%", "%%%1")
end

local function lsp_status()
    local status = g.lsp_status or ''
    return status:gsub("%%", "%%%1")
end

local function tag_name()
    local success, val = pcall(fn['nvim_treesitter#statusline'], 45)
    if success then
        return val
    end
    return fn['Tlist_Get_Tagname_By_Line']()
end


--table.insert(sections.lualine_b, 1, { 'diff', colored = false })
sections.lualine_b = { git_info, { 'diagnostics', sources = { 'nvim_lsp', 'coc' } } }
sections.lualine_c = { { 'filename', path = 1 }, coc_status, lsp_status }
table.insert(sections.lualine_x, 1, tag_name)

require('lualine').setup{
    options = {
        theme = require('theme').lualine_theme,
        section_separators = '',
        component_separators = ''
    },
    extensions = { 'quickfix', 'fugitive' },
    sections = sections
}
