local M = {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
}

local function search()
  -- vim.ui.input({ prompt = "Grep For", win = { row = -2 } }, function(input)
  --   Snacks.picker.grep({ live = false, search = input })
  -- end)
  local ok, res = pcall(vim.fn.input, 'Grep For> ')
  if ok and res ~= '' then
    Snacks.picker.grep({ live = false, search = res })
  end
end

M.keys = {
  -- bufdelete
  { '<c-q>', function() require('snacks').bufdelete() end, mode = '', desc = 'delete buffer' },

  -- pickers
  { '<leader>s',   search, { desc = 'grep' } },
  { '<leader>ag',  function() Snacks.picker.grep_word() end, mode = { 'n', 'x' } },
  { '<leader>rg',  function() Snacks.picker.grep() end },

  { '<c-p>',       function() Snacks.picker.files({ hidden = true }) end },
  { '<leader>l',   function() Snacks.picker.buffers() end },
  { '<leader>gf',  function() Snacks.picker.git_files() end },
  { '<leader>h',   function() Snacks.picker.commands() end },
  { '<leader>?',   function() Snacks.picker.help() end },
  { '<leader>qf',  function() Snacks.picker.qflist() end },
  { '<leader>gs',  function() Snacks.picker.git_status() end },
  { '<leader>gl',  function() Snacks.picker.git_log() end },
  { '<leader>gbl', function() Snacks.picker.git_log_file() end },
}

---@type snacks.Config
M.opts = {
  bigfile = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
}

M.opts.styles = {
  dashboard = {
    wo = { foldcolumn = "0", },
  }
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

M.opts.picker = {
  layout = 'telescope',
  formatters = {
    file = { filename_first = true, },
  },
  actions = {
    confirm = function(picker)
      local actions = require('snacks.picker.actions')
      local items = picker:selected()
      if #items > 0 then
        actions.qflist(picker)
      else
        actions.edit(picker)
      end
    end
  },
}

return M
