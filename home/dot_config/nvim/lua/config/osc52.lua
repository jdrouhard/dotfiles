local api = vim.api
local fn = vim.fn
local osc52 = require('osc52')

osc52.setup({
  silent = true
})

-- Copy yanked text to system clipboard
-- If we are connected over ssh also copy using OSC52
local augroup = api.nvim_create_augroup('osc52_config', { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  desc = "[osc52] Copy to clipboard/OSC52",
  callback = function()
    if vim.v.operator == 'y' then
      local ok, yank_data = pcall(fn.getreg, '')
      if ok then
        if fn.has('clipboard') == 1 then
          pcall(fn.setreg, '+', yank_data)
        end
        if vim.env.SSH_CONNECTION then
          osc52.copy(yank_data)
        end
      end
    end
  end
})
