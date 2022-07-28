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

local M = {}

function M.locations(opts)
    opts = config.normalize_opts(opts, config.globals.lsp)
    if not opts.cwd then opts.cwd = vim.loop.cwd() end
    if not opts.prompt then
        opts.prompt = 'CocLocations' .. (opts.prompt_postfix or '')
    end
    opts = core.set_header(opts, 2)
    opts = core.set_fzf_field_index(opts)

    local locations = vim.lsp.util.locations_to_items(vim.g.coc_jump_locations, 'utf-8')
    local entries = {}
    for _, entry in ipairs(locations) do
      if not opts.current_buffer_only or
        vim.api.nvim_buf_get_name(opts.bufnr) == entry.filename then
        entry = core.make_entry_lcol(opts, entry)
        entry = core.make_entry_file(opts, entry)
        if entry then
          entries[#entries+1] = entry
        end
      end
    end

    opts.fzf_fn = entries

    return core.fzf_files(opts)
end

return M
