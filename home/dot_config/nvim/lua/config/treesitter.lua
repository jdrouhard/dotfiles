local opt = vim.opt

require('nvim-treesitter.configs').setup {
  ensure_installed = { 'cpp', 'python', 'bash', 'cmake', 'lua', 'query', 'json', 'javascript', 'rust' },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
  playground = {
    enable = false,
    updatetime = 25, -- debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- whether the query persists across vim sessions
  }
}

opt.foldmethod = "expr"
opt.foldexpr   = "nvim_treesitter#foldexpr()"
