local opt = vim.opt

local filetypes = { 'cpp', 'c', 'python', 'bash', 'cmake', 'lua', 'query', 'json', 'javascript', 'rust'  }

local M = {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'SmiteshP/nvim-gps',
  },
  ft = filetypes,
  build = ':TSUpdate',
}

function M.config()
  require('nvim-treesitter.configs').setup {
    ensure_installed = filetypes,
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

  require('nvim-gps').setup()
end

return M
