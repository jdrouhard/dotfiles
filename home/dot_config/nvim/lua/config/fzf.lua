require('fzf-lua').setup {
    fzf_layout = 'default',
    winopts = {
        --height = 0.6,
        width = 0.9,
        hl_border = 'FloatBorder',
    },
    keymap = {
        fzf = {
            ['f2'] = 'toggle-preview',
            ['alt-a'] = 'select-all',
            ['alt-d'] = 'deselect-all',
            ['up'] = 'preview-up',
            ['down'] = 'preview-down',
            ['ctrl-b'] = 'preview-page-up',
            ['ctrl-f'] = 'preview-page-down'
        },
        builtin = {
            ['<f2>'] = 'toggle-preview',
            ['<f4>'] = 'toggle-fullscreen',
            ['<c-b>'] = 'preview-page-up',
            ['<c-f>'] = 'preview-page-down',
        }
    },
    grep = {
        rg_opts = [[--vimgrep --smart-case --color=always -g '!{.git,node_modules}/*']],
        --rg_opts = "--hidden --column --line-number --no-heading " ..
                  --"--color=always --smart-case -g '!{.git,node_modules}/*'",
        no_esc = true,
    },
    files = {
        cmd = [[rg --files --hidden -g '!{.git,node_modules}/*']],
    },
    lsp = {
        jump_to_single_result = true,
    },
}

local core = require('fzf-lua.core')
local config = require('fzf-lua.config')
local make_entry = require('fzf-lua.make_entry')

local M = {}

function M.locations(opts)
    opts = config.normalize_opts(opts, config.globals.lsp)
    if not opts then return end
    if not opts.cwd or #opts.cwd == 0 then
        opts.cwd = vim.loop.cwd()
    end
    if not opts.prompt then
        opts.prompt = 'CocLocations' .. (opts.prompt_postfix or '')
    end
    if opts.force_uri == nil then opts.force_uri = true end
    opts = core.set_fzf_field_index(opts)

    local locations = vim.lsp.util.locations_to_items(vim.g.coc_jump_locations, 'utf-8')
    local entries = {}
    for _, entry in ipairs(locations) do
      if not opts.current_buffer_only or
        vim.api.nvim_buf_get_name(opts.bufnr) == entry.filename then
        entry = make_entry.lcol(entry, opts)
        entry = make_entry.file(entry, opts)
        if entry then
          entries[#entries+1] = entry
        end
      end
    end

    return core.fzf_exec(entries, opts)
end

return M
