local M = {
  'Bekaboo/dropbar.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
}

M.opts = {
  sources = {
    path = {
      max_depth = 1,
      modified = function(sym)
        return sym:merge({
          icon = '● ',
          icon_hl = 'String'
        })
      end,
    },
  },
}

function M.config(_, opts)
  local normal_hl = vim.api.nvim_get_hl(0, { name = 'Normal' })
  vim.api.nvim_set_hl(0, 'DropBarKindFile', { fg = normal_hl.fg, bold = true })
  require('dropbar').setup(opts)
end

return M
