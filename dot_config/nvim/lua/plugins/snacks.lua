local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
}

M.keys = {
  -- bufdelete
  { "<c-q>", function() Snacks.bufdelete() end, mode = "", desc = "delete buffer" },
}

if not require('globals').fzflua then
  local function search()
    Snacks.picker.grep({ hidden = true })

    -- Snacks.input({
    --   prompt = "Grep For",
    --   win = {
    --     relative = "editor",
    --     row = -2,
    --     col = false -- false so it merges to a falsey value
    --   }
    -- }, function(input)
    --   if input and input ~= '' then
    --     Snacks.picker.grep({ live = false, search = input })
    --   end
    -- end)
  end

  vim.list_extend(M.keys, {
    -- pickers
    { "<leader>s",   search, { desc = "grep" } },
    { "<leader>ag",  function() Snacks.picker.grep_word() end, mode = { "n", "x" } },
    { "<leader>rg",  function() Snacks.picker.grep() end },

    { "<c-p>",       function() Snacks.picker.files() end },
    { "<leader>d",   function() Snacks.picker.diagnostics_buffer() end },
    { "<leader>l",   function() Snacks.picker.buffers() end },
    { "<leader>h",   function() Snacks.picker.commands() end },
    { "<leader>?",   function() Snacks.picker.help() end },
    { "<leader>qf",  function() Snacks.picker.qflist() end },
    { "<leader>gf",  function() Snacks.picker.git_files() end },
    { "<leader>gs",  function() Snacks.picker.git_status() end },
    { "<leader>gl",  function() Snacks.picker.git_log() end },
    { "<leader>gbl", function() Snacks.picker.git_log_file() end },
    { "<leader>gp",  function() Snacks.picker.gh_pr() end },
    { "<leader>gP",  function() Snacks.picker.gh_pr({ state = 'all' }) end },
    { "<leader>gi",  function() Snacks.picker.gh_issue() end },
    { "<leader>gI",  function() Snacks.picker.gh_issue({ state = 'all' }) end },
  })
end

---@type snacks.Config
M.opts = {
  bigfile = { enabled = true },
  input = { enabled = true },
  image = { force = true },
  quickfile = { enabled = true },
}

M.opts.styles = {
  dashboard = {
    wo = { foldcolumn = "0", },
  },
  input = {
    relative = "cursor",
    row = -3,
    col = 0,
  },
}

M.opts.notifier = {
  margin = { bottom = 1 },
  top_down = false,
}

M.opts.dashboard = {
  preset = {
    ---@type snacks.dashboard.Item[]
    keys = {
      { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = " ", key = "c", desc = "Config", action = ":lua require('plugins.chezmoi').pick()" },
      -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
  },
  sections = {
    { section = "header" },
    {
      text = { vim.fn.execute("version"):match("NVIM v([^\n]*)"), align = "center", hl = "header" },
      padding = 1,
    },
    { section = "keys",   gap = 1, padding = 1 },
    { section = "startup" },
  },
}

M.opts.picker = {
  show_delay = 2000,
  -- layout = {
  --   preset = function()
  --     return vim.o.columns >= 120 and "telescope" or "vertical"
  --   end,
  -- },
  formatters = {
    file = { filename_first = true, truncate = 120, },
  },
  actions = {
    confirm = function(picker, item, action)
      local actions = require("snacks.picker.actions")
      local items = picker:selected()
      if #items > 0 then
        return actions.qflist(picker, item, action)
      else
        return actions.jump(picker, item, action)
      end
    end,
    show_commit = function(picker, item, _)
      picker:close()
      vim.cmd("Git show " .. item.commit)
    end,
    edit_at_commit = function(picker, item, _)
      picker:close()
      vim.cmd("Gedit " .. item.commit .. ":" .. item.file)
    end,
  },
  win = {
    input = {
      keys = {
        ["<Esc>"] = { "close", mode = { "n", "i" } },
        ["<a-a>"] = { "select_all", mode = { "n", "i" } },
        ["<F2>"] = "toggle_preview",
        ["<F4>"] = "toggle_maximize",
        -- ["<S-Tab>"] = { "select_and_next", mode = { "n", "i" } },
        -- ["<Tab>"] = { "select_and_prev", mode = { "n", "i" } },
      },
    },
  },
  sources = {
    files = { hidden = true, follow = true },
    git_log = { confirm = "show_commit", },
    git_log_file = { confirm = "edit_at_commit", },
    git_log_line = { confirm = "edit_at_commit", },
    gh_diff = { auto_close = false, layout = { preset = "left", }, },
    colorschemes = { layout = { preset = "ivy", }, },
  }
}

function M.config(_, opts)
  require('snacks').setup(opts)

  vim.api.nvim_create_autocmd('User', {
    pattern = 'SnacksDashboardOpened',
    callback = function(ev)
      -- vim.api.nvim_win_set_cursor() adds a mark to the jumplist
      -- when moving from 1,0 to the first button when snacks is first
      -- enabled.
      -- seems like the startup setpcmark() adds a jump to the (1,0) pos
      -- of the opening scratch buffer which gets kept when snacks
      -- calls nvim_buf_set_lines followed by nvim_win_set_cursor
      -- TODO: investigate. might be a neovim bug.
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<c-o>', true, false, true), 'n', false)
      vim.api.nvim_buf_create_user_command(ev.buf, 'G', 'bwipe <bar> Git', { force = true })
    end,
  })
end

return M
