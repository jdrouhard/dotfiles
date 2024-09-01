local M = {
  'luukvbaal/statuscol.nvim',
  event = 'VeryLazy',
}

function M.config()
  local builtin = require('statuscol.builtin')
  require('statuscol').setup({
    relculright = true,
    segments = {
      { text = { builtin.foldfunc }, click = 'v:lua.ScFa', },
      { text = { '%s' },             click = 'v:lua.ScSa', },
      {
        text = { builtin.lnumfunc, ' ' },
        condition = { true, builtin.not_empty },
        click = 'v:lua.ScLa'
      },
    },
  })
end

return M
