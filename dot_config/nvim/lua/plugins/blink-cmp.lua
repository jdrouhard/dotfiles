local M = {
  'saghen/blink.cmp',
  event = 'VeryLazy',
  enabled = require('globals').blink_cmp,
  -- dev = true,

  -- use LuaSnip until nvim allows disabling default tab/s-tab keymaps for native snippets
  dependencies = {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
  },

  version = '1.*',
  -- build = 'cargo build --release',
}

---@module 'blink.cmp'
---@type blink.cmp.Config
M.opts = {
  keymap = {
    preset = 'default',
    ['<CR>'] = { 'accept', 'fallback' },
    ['<C-e>'] = { 'hide', 'fallback' },
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
  },
  completion = {
    list = {
      selection = {
        preselect = false,
        auto_insert = true,
      },
    },
    documentation = {
      auto_show = true,
    },
  },
  signature = {
    enabled = true,
  },
  snippets = {
    preset = 'luasnip',
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'normal',
  },
}

return M
