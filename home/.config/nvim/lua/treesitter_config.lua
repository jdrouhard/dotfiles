require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      ["keyword.access"] = "Keyword",
      ["statement"] = "Statement",
      ["storageclass"] = "StorageClass",
      ["structure"] = "Structure"
    },
  },
  indent = {
    enable = true,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- whether the query persists across vim sessions
  }
}
