local M = {
  'numToStr/Comment.nvim',
  event = 'VeryLazy',
}

function M.config()
  local util = require('Comment.utils')
  local lrepl = '[>'
  local rrepl = '<]'
  local use_padding = false

  local post_hook = function(ctx)
    local srow = ctx.range.srow
    local erow = ctx.range.erow

    if srow == -1 then
      return
    end

    local lcs, rcs = util.parse_cstr({}, ctx)
    local padding = util.get_pad(use_padding)
    local partial_block = ctx.cmotion == util.cmotion.char or ctx.cmotion == util.cmotion.v

    -- we only care about placeholders when there is an "end" marker for the comment
    if util.is_empty(rcs) then
      return
    end

    local lines = util.get_lines(ctx.range)

    if ctx.cmode == util.cmode.comment then
      -- comment
      for line_no = 1, #lines do
        local line = lines[line_no]
        local scol = 1
        local ecol = line:len() + 1

        if line_no == 1 and partial_block then
          scol = ctx.range.scol + lcs:len() + padding:len() + 1
        elseif line_no == 1 or ctx.ctype == 1 then
          local _, j = line:find(vim.pesc(lcs) .. padding)
          scol = j + 1
        end

        if line_no == #lines and partial_block then
          ecol = ctx.range.ecol + 1
          if srow == erow then
            ecol = ecol + lcs:len() + padding:len()
          end
        elseif line_no == #lines or ctx.ctype == 1 then
          local i, _ = line:find(padding .. vim.pesc(rcs) .. '$')
          ecol = i - 1
        end


        local before = line:sub(1, scol - 1)
        local after = line:sub(ecol + 1)
        line = line:sub(scol, ecol)
        line = line:gsub(vim.pesc(lcs), lrepl)
        line = line:gsub(vim.pesc(rcs), rrepl)

        lines[line_no] = before .. line .. after
      end
    elseif ctx.cmode == util.cmode.uncomment then
      -- uncomment
      for idx = 1, #lines do
        lines[idx] = lines[idx]:gsub(vim.pesc(lrepl), lcs)
        lines[idx] = lines[idx]:gsub(vim.pesc(rrepl), rcs)
      end
    end

    vim.api.nvim_buf_set_lines(0, srow - 1, erow, false, lines)

  end

  require('Comment').setup {
    post_hook = post_hook,
    padding = use_padding
  }
end

return M
