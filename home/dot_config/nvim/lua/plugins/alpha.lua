local M = {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  --dependencies = {
  --  'MaximilianLloyd/ascii.nvim',
  --},
}

function M.opts()
  local dashboard = require('alpha.themes.dashboard')
  local logo = {
    [[                                                    ]],
    [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
    [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
    [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
    [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
    [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
    [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
    [[                                                    ]],
  }
  dashboard.section.header.val = logo
  dashboard.opts.layout[1].val = 8

  --local logo = [[
  --⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  --⠀⠀⠀⠀⣤⣶⠿⠿⠿⠿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠻⠿⠿⠿⠿⠿⠷⠶⣶⣶⣦⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  --⠀⠀⠀⣼⡟⠛⠷⣦⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠿⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀
  --⠀⠀⠀⣿⠀⠀⠀⠀⠈⠙⠻⢶⣦⣤⣤⣤⣤⡤⠤⠤⠤⠤⠤⠤⢤⣤⣤⣤⣤⣀⣀⣀⣀⣀⡀⠉⠛⢿⣶⣄⠀⠀⠀⠀
  --⠀⠀⢰⡿⠀⠀⠀⣄⠀⠀⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠛⠛⢿⣷⠀⠀⠀
  --⠀⠀⢸⡇⠀⣀⠀⠀⠀⠛⠀⠀⣸⡇⠀⣰⠚⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠛⠛⠓⠒⠒⠲⠦⠤⠤⣄⡀⠀⠀⣿⠀⠀⠀
  --⠀⠀⣼⡇⠀⠀⠀⠛⠀⣤⠀⠀⣿⠁⢠⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢷⠀⠀⣿⠀⠀⠀
  --⠀⠀⣿⠁⠀⠰⠆⢀⣄⠀⠀⢠⣿⠀⢸⠀⠀⠀⠀⠀⢰⣾⡆⠀⠀⠀⠀⠀⠀⠀⢠⣤⡄⠀⠀⠀⠀⢸⠀⢰⣿⠀⠀⠀
  --⠀⢀⣿⠀⠀⠀⠀⠀⠁⠀⠀⢸⡇⠀⡜⠀⠀⠀⠀⠀⠀⠉⠀⠀⢀⣀⣀⣀⡀⠀⠈⠛⠃⠀⠀⠀⠀⡸⠀⢸⡿⠀⠀⠀
  --⠀⢸⣿⠀⢠⣤⣀⠀⠀⠀⠀⣼⠇⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⢿⠿⠃⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⣸⡇⠀⠀⠀
  --⠀⢸⡿⠀⢸⣏⣿⢷⡆⠀⠀⣿⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⣿⠇⠀⠀⠀
  --⠀⣼⡇⠀⠈⠻⠻⣾⠃⠀⢀⣿⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⠀⣿⠀⠀⠀⠀
  --⠀⣿⡇⠀⢸⣷⣦⣀⠀⠀⢸⡇⠀⠠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠀⢸⡏⠀⠀⠀⠀
  --⠀⣿⡇⠀⠀⣼⣿⡿⠀⠀⢸⠇⠀⠀⠧⣤⣄⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡇⠀⣼⠇⠀⠀⠀⠀
  --⢸⣿⠃⠰⢿⣿⣿⡆⠀⠀⣼⠀⡴⠛⣶⡄⠀⠀⠉⠉⠉⠉⠉⠉⠉⠉⠙⠛⠛⠛⠛⠛⠋⠉⠉⠉⠀⠀⣿⠀⠀⠀⠀⠀
  --⢸⣿⠀⠀⠀⠈⠉⠁⠀⠀⣿⣼⠃⠀⣸⣷⣶⣶⣶⣶⣶⣶⣶⣶⣤⣤⡄⠀⠀⠀⠀⢀⣤⡀⠀⠀⠀⢰⡏⠀⠀⠀⠀⠀
  --⢸⣿⠀⣴⣾⣿⣶⣄⠀⢀⣿⠇⠀⣼⠁⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠈⠛⠁⠀⠀⠀⣸⣷⣄⡀⠀⠀⠀
  --⣸⣿⠘⣿⡟⠙⣿⡿⠀⣸⠏⢀⣼⠃⠀⢠⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⠈⠉⠛⢶⣄⠀
  --⣿⣿⠀⠙⢳⣄⠘⠓⠚⠁⣠⡾⠁⠀⡖⠚⠀⠓⠄⠀⠀⠀⠀⠀⠀⢀⡾⠋⢆⠀⢀⡤⠄⡀⠀⠀⢠⣿⣶⣶⡄⠀⠙⣷
  --⣿⡇⠀⠀⠀⠙⠳⠶⠶⢾⡏⠀⠀⠀⠑⣆⠀⠒⠂⠀⠀⠀⠀⠀⠀⠀⠉⠀⠈⠀⠸⣄⣀⠄⠀⠀⢸⣿⣿⡿⠃⢀⣴⠏
  --⣿⣇⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠟⠛⠓⣄⠀⠀⠀⠀⠀⣿⣿⠟⠀⣠⠟⠁⠀
  --⠈⠙⠿⣦⣄⠀⠀⠀⠀⢸⡇⠀⠀⠀⣠⣤⣀⠀⠀⢀⣀⣀⠀⠀⠀⠀⣿⡀⠀⠀⡼⠀⠀⠀⠀⢠⣿⣿⣴⣠⣽⠆⠀⠀
  --⠀⠀⠀⠀⠉⠛⠶⣤⣄⣿⡇⠀⠀⠀⠀⠉⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠈⠙⠓⠋⠀⠀⠀⠀⠀⢸⡟⠈⠉⠉⠀⠀⠀⠀
  --⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠛⠻⠿⣶⡶⠶⢶⣶⣤⣤⣤⣤⣤⣤⣤⣤⣄⣀⣀⣀⣀⣀⣠⣤⣤⡿⠃⠀⠀⠀⠀⠀⠀⠀
  --⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣦⡀⠻⣧⠀⠀⠀⠀⢈⡟⠀⢸⡟⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
  --⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠴⠚⠋⠁⣠⡿⠀⠀⠀⠀⣸⠃⠀⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  --⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⣤⡶⠟⠉⠀⠀⠀⠀⢀⡟⠀⣸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  --⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⣄⣹⡇⠀⠀⠀⠀⠀⠀⣼⠃⢀⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  --⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠁⠀⠀⠀⠀⠀⢠⡟⠀⢸⣧⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  --⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣧⣀⣀⣠⡼⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  --⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  --]]
  --dashboard.section.header.val = vim.split(logo, '\n')

  local version_section = {
    type = 'text',
    val = vim.fn.execute('version'):match('NVIM v([^\n]*)'),
    opts = {
      position = 'center',
      hl = 'AlphaFooter',
    },
  }

  table.insert(dashboard.opts.layout, 3, version_section)

  dashboard.section.buttons.val = {
    dashboard.button('f', ' ' .. ' Find file', '<cmd>FzfLua files <CR>'),
    dashboard.button('n', ' ' .. ' New file', '<cmd>ene <BAR> startinsert <CR>'),
    dashboard.button('r', ' ' .. ' Recent files', '<cmd>FzfLua oldfiles <CR>'),
    dashboard.button('g', ' ' .. ' Find text', '<cmd>FzfLua live_grep <CR>'),
    dashboard.button('l', '󰒲 ' .. ' Lazy', '<cmd>Lazy<CR>'),
    dashboard.button('q', ' ' .. ' Quit', '<cmd>qa<CR>'),
  }
  for _, button in ipairs(dashboard.section.buttons.val) do
    button.opts.hl = 'AlphaButtons'
    button.opts.hl_shortcut = 'AlphaShortcut'
  end
  dashboard.section.header.opts.hl = 'AlphaHeader'
  dashboard.section.buttons.opts.hl = 'AlphaButtons'
  dashboard.section.footer.opts.hl = 'AlphaFooter'

  dashboard.opts.opts.redraw_on_resize = false
  dashboard.opts.opts.noautocmd = true

  return dashboard
end

function M.config(_, dashboard)
  -- close Lazy and re-open when the dashboard is ready
  if vim.bo.filetype == 'lazy' then
    vim.cmd.close()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaReady',
      callback = function()
        require('lazy').show()
      end,
    })
  end

  require('alpha').setup(dashboard.opts)

  vim.api.nvim_create_autocmd('User', {
    pattern = 'LazyVimStarted',
    callback = function()
      if vim.bo.filetype == 'alpha' then
        local stats = require('lazy').stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = '⚡ Startup time: ' .. ms .. 'ms'
        pcall(vim.cmd.AlphaRedraw)

        -- vim.api.nvim_win_set_cursor() adds a mark to the jumplist
        -- when moving from 1,0 to the first button when alpha is first
        -- enabled.
        -- seems like the startup setpcmark() adds a jump to the (1,0) pos
        -- of the opening scratch buffer which gets kept when alpha
        -- calls nvim_buf_set_lines followed by nvim_win_set_cursor
        -- TODO: investigate. might be a neovim bug.
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<c-o>', true, false, true), 'n', false)
      end
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'AlphaReady',
    callback = function(ev)
      -- See https://github.com/justinmk/vim-dirvish/issues/221
      vim.keymap.set('n', '-', ':bwipe <bar> Dirvish<cr>', { silent = true, buffer = ev.buf })

      vim.api.nvim_buf_create_user_command(ev.buf, 'G', 'bwipe <bar> Git', { force = true })
    end,
  })
end

return M
