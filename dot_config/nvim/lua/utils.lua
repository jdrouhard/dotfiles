local api = vim.api

local M = {}

function M.show_highlights_at_pos(bufnr, row, col, filter)
  local ns = api.nvim_create_namespace('personal_utils')
  local items = vim.inspect_pos(bufnr, row, col, filter)
  local lines = { '' }
  local marks = {}

  local function append(str, hl)
    local line = #lines
    local cb = lines[line] and lines[line]:len() or 0
    local ce = cb + str:len()
    lines[line] = (lines[line] or '') .. str
    if hl then
      marks[#marks + 1] = {
        line = line - 1,
        col = cb,
        end_col = ce,
        hl_group = hl
      }
    end
  end

  local function nl()
    lines[#lines + 1] = ''
  end

  local function item(data, comment)
    append('  - ')
    append(data.hl_group, data.hl_group)
    append(' ')
    if data.hl_group ~= data.hl_group_link then
      append('links to', 'MoreMsg')
      append(' ')
      append(data.hl_group_link, data.hl_group_link)
      append('   ')
    end
    if comment then
      append(comment, 'Comment')
    end
    nl()
  end

  -- treesitter
  if #items.treesitter > 0 then
    append('Treesitter', 'Title')
    nl()
    for _, capture in ipairs(items.treesitter) do
      item(
        capture,
        string.format(
          'priority: %d  language: %s',
          capture.metadata.priority or vim.hl.priorities.treesitter,
          capture.lang
        )
      )
    end
    nl()
  end

  -- semantic tokens
  if #items.semantic_tokens > 0 then
    append('Semantic Tokens', 'Title')
    nl()
    local sorted_marks = vim.fn.sort(items.semantic_tokens, function(left, right)
      local left_first = left.opts.priority < right.opts.priority
          or left.opts.priority == right.opts.priority and left.opts.hl_group < right.opts.hl_group
      return left_first and -1 or 1
    end)
    for _, extmark in ipairs(sorted_marks) do
      item(extmark.opts, 'priority: ' .. extmark.opts.priority)
    end
    nl()
  end

  -- syntax
  if #items.syntax > 0 then
    append('Syntax', 'Title')
    nl()
    for _, syn in ipairs(items.syntax) do
      item(syn)
    end
    nl()
  end

  -- extmarks
  if #items.extmarks > 0 then
    append('Extmarks', 'Title')
    nl()
    for _, extmark in ipairs(items.extmarks) do
      if extmark.opts.hl_group then
        item(extmark.opts, extmark.ns)
      else
        append('  - ')
        append(extmark.ns, 'Comment')
        nl()
      end
    end
    nl()
  end

  if #lines[#lines] == 0 then
    table.remove(lines)
  end

  if #lines == 1 and lines[1] == '' then
    lines[1] = 'No items found at position '
        .. items.row
        .. ','
        .. items.col
        .. ' in buffer '
        .. items.buffer
  end

  local scratchbuf, _ = vim.lsp.util.open_floating_preview(lines, '', { stylize_markdown = false })
  for _, mark in ipairs(marks) do
    api.nvim_buf_set_extmark(scratchbuf, ns, mark.line, mark.col, {
      end_col = mark.end_col,
      hl_group = mark.hl_group
    })
  end
end

return M
