local M = {
  'saghen/blink.cmp',
  event = 'VeryLazy',
  -- dev = true,

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
  sources = {
    per_filetype = {
      -- optionally inherit from the `default` sources
      lua = { inherit_defaults = true, 'lazydev' },
    },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
      lsp = {
        async = true,
      },
    },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'normal',
  },
}

return M
