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

  dashboard.section.header.val = logo
  dashboard.section.buttons.val = {
    dashboard.button('f', ' ' .. ' Find file', '<cmd>FzfLua files <CR>'),
    dashboard.button('n', ' ' .. ' New file', '<cmd>ene <BAR> startinsert <CR>'),
    dashboard.button('r', ' ' .. ' Recent files', '<cmd>FzfLua oldfiles <CR>'),
    dashboard.button('g', ' ' .. ' Find text', '<cmd>FzfLua live_grep <CR>'),
    dashboard.button('c', ' ' .. ' Config', '<cmd>e $MYVIMRC <CR>'),
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
  dashboard.opts.layout[1].val = 8
  return dashboard
end

function M.config(_, dashboard)
  -- close Lazy and re-open when the dashboard is ready
  if vim.o.filetype == 'lazy' then
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
      local stats = require('lazy').stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      dashboard.section.footer.val = '⚡ Startup time: ' .. ms .. 'ms'
      pcall(vim.cmd.AlphaRedraw)

      if vim.fn.argc(-1) == 0 then
        -- alpha adds something to the jumplist?
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<c-o>', true, false, true), 'n', false)
      end
    end,
  })
end

return M
