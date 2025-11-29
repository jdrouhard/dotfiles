local M = {
  'ibhagwan/fzf-lua',
  cmd = { 'FzfLua', 'FzfCocLocations' },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
}

function M.locations(opts)
  local core = require('fzf-lua.core')
  local config = require('fzf-lua.config')
  local make_entry = require('fzf-lua.make_entry')
  local path = require('fzf-lua.path')
  local utils = require('fzf-lua.utils')

  opts = config.normalize_opts(opts, config.globals.lsp)
  if not opts then return end
  if not opts.cwd or #opts.cwd == 0 then
    opts.cwd = vim.loop.cwd()
  end

  -- `title_prefix` is prioritized over both `prompt` and `prompt_prefix`
  if (not opts.winopts or opts.winopts.title == nil) and opts.title_prefix then
    utils.map_set(opts,
      "winopts.title", { {
        string.format(" %s %s ", opts.title_prefix, opts.label),
        opts.hls.title
      } })
  elseif opts.prompt == nil and opts.prompt_postfix then
    opts.prompt = opts.label .. (opts.prompt_postfix or '')
  end

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

  if #entries == 1 and opts.jump1 then
    local location = path.entry_to_file(entries[1], opts, opts.force_uri)
    vim.lsp.util.show_document(location, 'utf-8', { focus = true })
    return
  end

  return core.fzf_exec(entries, opts)
end

M.opts = {
  'default-title',
  fzf_colors = true,
  fzf_opts = { ['--layout'] = 'default', },
  winopts = {
    preview = {
      horizontal = 'right:45%',
    },
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
  files = {
    formatter = { 'path.filename_first', 2 },
    follow = true,
  },
  grep = {
    formatter = { 'path.filename_first', 2 },
    no_esc = true,
  },
  lsp = {
    jump1 = true,
    formatter = { 'path.filename_first', 2 },
  },
  git = {
    commits = {
      actions = {
        ["enter"] = function(selected, opts)
          if #selected == 0 then return end
          vim.cmd("Git show " .. selected[1]:match("[^ ]+"))
        end
      }
    }
  }
}

if require('globals').fzflua then
  M.keys = {
    { '<leader>s',   '<cmd>FzfLua live_grep<CR>' },
    { '<leader>ag',  '<cmd>FzfLua grep_cword<CR>' },
    { '<leader>AG',  '<cmd>FzfLua grep_cWORD<CR>' },
    { '<leader>ag',  '<cmd>FzfLua grep_visual<CR>', mode = 'x' },

    { '<c-p>',       '<cmd>FzfLua files<CR>' },
    { '<leader>l',   '<cmd>FzfLua buffers<CR>' },
    { '<leader>gf',  '<cmd>FzfLua git_files<CR>' },
    { '<leader>h',   '<cmd>FzfLua commands<CR>' },
    { '<leader>?',   '<cmd>FzfLua help_tags<CR>' },
    { '<leader>qf',  '<cmd>FzfLua quickfix<CR>' },
    { '<leader>gs',  '<cmd>FzfLua git_status<CR>' },
    { '<leader>gl',  '<cmd>FzfLua git_commits<CR>' },
    { '<leader>gbl', '<cmd>FzfLua git_bcommits<CR>' },
  }
end

function M.init()
  vim.g.coc_enable_locationlist = false

  local au_group = vim.api.nvim_create_augroup('fzf_coc', {})
  vim.api.nvim_create_autocmd('User', {
    group = au_group,
    pattern = 'CocLocationsChange',
    callback = function()
      local items = vim.lsp.util.locations_to_items(vim.g.coc_jump_locations, 'utf-8')
      require('plugins.fzf-lua').locations({ title_prefix = 'Coc', label = 'Locations', items = items })
    end,
    nested = true,
  })
end

function M.config(_, opts)
  local actions = require('fzf-lua.actions')
  local path = require('fzf-lua.path')

  ---@diagnostic disable-next-line: redefined-local
  ---@diagnostic disable-next-line: duplicate-set-field
  actions.git_buf_edit = function(selected, opts)
    if #selected == 0 then return end
    local file = path.relative_to(path.normalize(vim.fn.expand("%:p")), path.git_root(opts, true))
    local hash = selected[1]:match("[^ ]+")
    vim.cmd("Gedit " .. hash .. ":" .. file)
  end

  require('fzf-lua').setup(opts)
end

return M
