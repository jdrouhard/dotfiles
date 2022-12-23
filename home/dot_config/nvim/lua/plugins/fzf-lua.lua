local M = {
  'ibhagwan/fzf-lua',
  cmd = { 'FzfLua', 'FzfCocLocations' },
  dependencies = {
    'kyazdani42/nvim-web-devicons',
  },
}

function M.locations(opts)
  local core = require('fzf-lua.core')
  local config = require('fzf-lua.config')
  local make_entry = require('fzf-lua.make_entry')
  local path = require('fzf-lua.path')

  opts = config.normalize_opts(opts, config.globals.lsp)
  if not opts then return end
  if not opts.cwd or #opts.cwd == 0 then
    opts.cwd = vim.loop.cwd()
  end
  if not opts.prompt then
    opts.prompt = 'Locations'
  end
  opts.prompt = opts.prompt .. (opts.prompt_postfix or '')

  if opts.force_uri == nil then opts.force_uri = true end
  opts = core.set_fzf_field_index(opts)

  local entries = {}
  for _, entry in ipairs(opts.items) do
    if not opts.current_buffer_only or
        vim.api.nvim_buf_get_name(opts.bufnr) == entry.filename then
      entry = make_entry.lcol(entry, opts)
      entry = make_entry.file(entry, opts)
      if entry then
        entries[#entries + 1] = entry
      end
    end
  end

  if #entries == 1 and opts.jump_to_single_result then
    local location = path.entry_to_file(entries[1], opts, opts.force_uri)
    vim.lsp.util.jump_to_location(location, 'utf-8')
    return
  end

  return core.fzf_exec(entries, opts)
end

function M.config()
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
    lsp = {
      jump_to_single_result = true,
    },
  }
end

function M.init()
  if require('globals').telescope then
    return
  end

  local map = vim.keymap.set

  map('n', '<leader>s', '<cmd>FzfLua grep<CR>')
  map('n', '<leader>ag', '<cmd>FzfLua grep_cword<CR>')
  map('n', '<leader>rg', '<cmd>FzfLua live_grep<CR>')
  map('n', '<leader>AG', '<cmd>FzfLua grep_cWORD<CR>')
  map('x', '<leader>ag', '<cmd>FzfLua grep_visual<CR>')

  map('n', '<c-p>', '<cmd>FzfLua files<CR>')
  map('n', '<leader>l', '<cmd>FzfLua buffers<CR>')
  map('n', '<leader>gf', '<cmd>FzfLua git_files<CR>')
  map('n', '<leader>h', '<cmd>FzfLua commands<CR>')
  map('n', '<leader>?', '<cmd>FzfLua help_tags<CR>')
  map('n', '<leader>qf', '<cmd>FzfLua quickfix<CR>')
  map('n', '<leader>gs', '<cmd>FzfLua git_status<CR>')
  map('n', '<leader>gl', '<cmd>FzfLua git_commits<CR>')
  map('n', '<leader>gbl', '<cmd>FzfLua git_bcommits<CR>')

  vim.g.coc_enable_locationlist = false

  local au_group = vim.api.nvim_create_augroup('fzf_coc', {})
  vim.api.nvim_create_autocmd('User', {
    group = au_group,
    pattern = 'CocLocationsChange',
    callback = function()
      local items = vim.lsp.util.locations_to_items(vim.g.coc_jump_locations, 'utf-8')
      require('plugins.fzf-lua').locations({ prompt = 'CocLocations', items = items })
    end,
    nested = true,
  })
end

return M
