pcall(vim.loader.enable)

require('options')
require('lazy-bootstrap')
require('theme')

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('commands')
    require('mappings')

    require('vim._core.ui2').enable({
      msg = {
        targets = {
          progress = 'msg',
          echo = 'msg',
          echomsg = 'msg',
          echoerr = 'msg',
        },
      },
    })

    if vim.env.TMUX then
      ---@param content string
      ---@return string
      local function wrap_tmux(content) return string.format('\27Ptmux;\27%s\27\\', content) end

      local api = vim.api
      local original_ui_send = api.nvim_ui_send

      ---@diagnostic disable-next-line: duplicate-set-field
      api.nvim_ui_send =
        ---@param content string
        function(content) original_ui_send(wrap_tmux(content)) end
    end

    local fn = vim.fn
    local local_init = fn.resolve(fn.stdpath('data') .. '/site/init.lua')
    if fn.filereadable(local_init) > 0 then
      vim.cmd('luafile ' .. local_init)
    end
  end,
})
