local util = require('Comment.utils')

local lrepl = '[>'
local rrepl = '<]'
local padding = false

local post_hook = function(ctx)
  if srow == -1 then
    return
  end

  local srow = ctx.range.srow
  local erow = ctx.range.erow

  local lcs, rcs = util.parse_cstr({}, ctx)
  local padding = util.get_padding(padding)
  local partial_block = ctx.cmotion == util.cmotion.char or ctx.cmotion == util.cmotion.v

  -- we only care about placeholders when there is an "end" marker for the comment
  if not rcs then
    return
  end

  local lines = util.get_lines(ctx.range)

  if ctx.cmode == 1 then
    -- comment
    for line_no = 1, #lines do
      local line = lines[line_no]
      local scol = 1
      local ecol = line:len() + 1

      if line_no == 1 and partial_block then
        scol = ctx.range.scol + lcs:len() + padding:len() + 1
      elseif line_no == 1 or ctx.ctype == 1 then
        local i, j = line:find(util.escape(lcs) .. padding)
        scol = j + 1
      end

      if line_no == #lines and partial_block then
        ecol = ctx.range.ecol + 1
        if srow == erow then
          ecol = ecol + lcs:len() + padding:len()
        end
      elseif line_no == #lines or ctx.ctype == 1 then
        local i, j = line:find(padding .. util.escape(rcs) .. '$')
        ecol = i - 1
      end


      local before = line:sub(1, scol-1)
      local after = line:sub(ecol+1)
      line = line:sub(scol, ecol)
      line = line:gsub(util.escape(lcs), lrepl)
      line = line:gsub(util.escape(rcs), rrepl)

      lines[line_no] = before .. line .. after
    end
  elseif ctx.cmode == 2 then
    -- uncomment
    for idx = 1, #lines do
      lines[idx] = lines[idx]:gsub(util.escape(lrepl), lcs)
      lines[idx] = lines[idx]:gsub(util.escape(rrepl), rcs)
    end
  end

  vim.api.nvim_buf_set_lines(0, srow-1, erow, false, lines)

end

require('Comment').setup {
  post_hook = post_hook,
  padding = padding
}
