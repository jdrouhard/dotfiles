local cmd = vim.cmd
local opt = vim.opt

require('nvim-treesitter.configs').setup {
  ensure_installed = {'cpp', 'python', 'bash', 'cmake', 'lua', 'query', 'json', 'javascript'},
  highlight = {
    enable = true,
    --additional_vim_regex_highlighting = true,
    custom_captures = {
      ["statement"] = "TSStatement",
      ["keyword.access"] = "TSKeywordAccess",
      ["storageclass"] = "TSStorageClass",
      ["structure"] = "TSStructure"
    },
  },
  indent = {
    enable = false,
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
    enable = true,
    updatetime = 25, -- debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- whether the query persists across vim sessions
  }
}

opt.foldmethod = "expr"
opt.foldexpr   = "nvim_treesitter#foldexpr()"
