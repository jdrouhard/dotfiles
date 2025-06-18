local M = {
  'nvim-treesitter/nvim-treesitter',
  -- dependencies = {
  --   'nvim-treesitter/nvim-treesitter-textobjects',
  -- },
  event = { 'VeryLazy', 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  branch = 'main',
  build = ':TSUpdate',
}

local parser_list = {
  'bash',
  'c',
  'cmake',
  'comment',
  'cpp',
  'javascript',
  'jinja',
  'jinja_inline',
  'json',
  'lua',
  'luadoc',
  'make',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'regex',
  'rust',
  'ssh_config',
  'vim',
  'vimdoc',
  'yaml',
}

function M.config(_, opts)
  local ts = require('nvim-treesitter')
  ts.setup(opts)
  ts.install(parser_list)

  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local ft = args.match or vim.bo[args.buf].filetype
      local parser_lang = vim.treesitter.language.get_lang(ft)
      if vim.tbl_contains(parser_list, parser_lang) then
        vim.treesitter.start(args.buf or 0, parser_lang)
      end
    end,
  })
end

return M
