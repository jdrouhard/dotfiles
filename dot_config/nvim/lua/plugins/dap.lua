local M = {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'nvim-neotest/nvim-nio',
    },
  },
}

M.keys = {
  { '<F5>', function() require('dap').continue() end },
  { '<F9>', function() require('dap').toggle_breakpoint() end },
  { '<F10>', function() require('dap').step_over() end },
  { '<F11>', function() require('dap').step_into() end },
  { '<F12>', function() require('dap').step_out() end },
  { '<M-k>', function() require('dapui').eval() end, mode = { 'n', 'v' } },
  { '<leader>B', function()
      vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input)
        if input then
          require('dap').set_breakpoint(input)
        end
      end)
    end,
  },
}

function M.config()
  local dap = require('dap')
  local dapui = require('dapui')

  dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.after.event_exited['dapui_config'] = dapui.close

  vim.schedule(dapui.setup)

  dap.configurations.cpp = {
    {
      name = 'Launch lldb',
      type = 'lldb',
      request = 'launch',
      program = function()
        return require('dap.utils').pick_file()
      end,
      args = {},
      cwd = '${workspaceFolder}',
    },
    {
      name = 'Launch gdb',
      type = 'gdb',
      request = 'launch',
      program = function()
        return require('dap.utils').pick_file()
      end,
      args = {},
      cwd = '${workspaceFolder}',
    },
  }

  dap.configurations.c = dap.configurations.cpp

  dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-dap',
  }

  dap.adapters.gdb = {
    type = 'executable',
    command = 'gdb',
    args = { '--quiet', '--interpreter=dap' },
  }
end

return M
