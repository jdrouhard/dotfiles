local M = {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
}

M.keys = {
  { '<c-q>', function() require('snacks').bufdelete() end, mode = '', desc = 'delete buffer' },
}

M.opts = {
  bigfile = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
}

M.opts.dashboard = {
  preset = {
    ---@type snacks.dashboard.Item[]
    keys = {
      { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
      -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
  },
  sections = {
    { section = "header" },
    {
      text = { vim.fn.execute('version'):match('NVIM v([^\n]*)'), align = "center", hl = "header" },
      padding = 1,
    },
    { section = "keys",   gap = 1, padding = 1 },
    { section = "startup" },
  },
}

return M
