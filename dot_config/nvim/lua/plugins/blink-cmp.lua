local M = {
  'saghen/blink.cmp',
  event = 'VeryLazy',
  enabled = require('globals').blink_cmp,
  -- dev = true,

  version = 'v0.*',
  -- build = 'cargo build --release',
}

---@module 'blink.cmp'
---@type blink.cmp.Config
M.opts = {
  keymap = {
    preset = 'default',
    ['<CR>'] = { 'accept', 'fallback' },
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
  },
  windows = {
    autocomplete = { selection = 'auto_insert', },
    documentation = { auto_show = true },
  },
  highlight = { use_nvim_cmp_as_default = true, },
  nerd_font_variant = 'normal',

  -- accept = { auto_brackets = { enabled = true, kind_resolution = { enabled = false } } }

  trigger = { signature_help = { enabled = true, }, },
  fuzzy = { sorts = { 'score' } }
}

return M
