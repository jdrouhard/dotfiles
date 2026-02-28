pcall(vim.loader.enable)

require('options')
require('lazy-bootstrap')
require('theme')

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('commands')
    require('mappings')

    -- Performance issues still present with ui2.
    -- It seems to constantly redraw the entire screen. Re-enable when resolved.
    -- require('vim._core.ui2').enable({})

    local fn = vim.fn
    local local_init = fn.resolve(fn.stdpath('data') .. '/site/init.lua')
    if fn.filereadable(local_init) > 0 then
      vim.cmd('luafile ' .. local_init)
    end
  end,
})
