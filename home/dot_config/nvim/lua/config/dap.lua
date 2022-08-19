local dap = require('dap')
local dapui = require('dapui')
local map = vim.keymap.set

map('n',       '<S-F5>',     dap.continue)
map('n',       '<F9>',       dap.toggle_breakpoint)
map('n',       '<F10>',      dap.step_over)
map('n',       '<F11>',      dap.step_into)
map('n',       '<F12>',      dap.step_out)
map('n',       '<leader>dr', dap.repl.open)
map('n',       '<leader>dl', dap.run_last)
map({'n','v'}, '<M-k>',      dapui.eval)

map('n', '<leader>B', function()
  vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input)
    if input then
      dap.set_breakpoint(input)
    end
  end)
end)

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.after.event_exited['dapui_config'] = dapui.close

dapui.setup()

dap.configurations.cpp = {
    {
        name = 'Launch lldb',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        args = {},
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        runInTerminal = false,
    },
}

dap.configurations.c = dap.configurations.cpp

dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-vscode',
    name = 'lldb'
}
