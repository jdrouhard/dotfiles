local cmd = vim.cmd

cmd [[hi! link TSKeywordAccess Statement]]
cmd [[hi! link TSStatement Statement]]
cmd [[hi! link TSStorageClass StorageClass]]
cmd [[hi! link TSStructure Structure]]

require'nvim-treesitter.configs'.setup {
  ensure_installed = {'cpp', 'python', 'bash', 'cmake', 'lua' },
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
  playground = {
    enable = false,
    disable = {},
    updatetime = 25, -- debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- whether the query persists across vim sessions
  }
}
