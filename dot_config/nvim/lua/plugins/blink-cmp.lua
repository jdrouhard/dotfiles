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

  version = 'v0.*',
  -- build = 'cargo build --release',
}

---@module 'blink.cmp'
---@type blink.cmp.Config
M.opts = {
  snippets = {
    expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
    active = function(filter)
      if filter and filter.direction then
        return require('luasnip').jumpable(filter.direction)
      end
      return require('luasnip').in_snippet()
    end,
    jump = function(direction) require('luasnip').jump(direction) end,
  },
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
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'normal',
  },
}

return M
