local M = {
  'rcarriga/nvim-notify',
}

function M.opts()
  local stages_util = require('notify.stages.util')

  return {
    -- simply 'fade' but in the bottom right corner of the screen
    stages = {
      function(state)
        local next_height = state.message.height + 2
        local next_row = stages_util.available_slot(state.open_windows, next_height, stages_util.DIRECTION.BOTTOM_UP)
        if not next_row then
          return nil
        end
        return {
          relative = 'editor',
          anchor = 'SE',
          width = state.message.width,
          height = state.message.height,
          col = vim.opt.columns:get(),
          row = next_row,
          border = 'single',
          style = 'minimal',
          opacity = 0,
        }
      end,
      function()
        return {
          opacity = { 100 },
          col = { vim.opt.columns:get() },
        }
      end,
      function()
        return {
          col = { vim.opt.columns:get() },
          time = true,
        }
      end,
      function()
        return {
          opacity = {
            0,
            frequency = 2,
            complete = function(cur_opacity)
              return cur_opacity <= 4
            end,
          },
          col = { vim.opt.columns:get() },
        }
      end,
    }
  }
end

return M
