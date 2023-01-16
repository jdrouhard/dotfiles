local api = vim.api
local util = vim.lsp.util
local semantic_tokens = vim.lsp.semantic_tokens

local function transformer(token)
  local hl_groups = {}

  hl_groups[#hl_groups + 1] = {
    name = '@' .. token.type,
    priority = vim.highlight.priorities.semantic_tokens,
  }

  for _, modifier in ipairs(token.modifiers) do
    hl_groups[#hl_groups + 1] = {
      name = '@' .. modifier,
      priority = vim.highlight.priorities.semantic_tokens + 1,
    }
  end

  return hl_groups
end

---@private
local function binary_search(tokens, line)
  local lo = 1
  local hi = #tokens
  while lo < hi do
    local mid = math.floor((lo + hi) / 2)
    if tokens[mid].line < line then
      lo = mid + 1
    else
      hi = mid
    end
  end
  return lo
end

local function on_win(self, topline, botline)
  for _, state in pairs(self.client_state) do
    local current_result = state.current_result
    if current_result.version and current_result.version == util.buf_versions[self.bufnr] then
      if not current_result.namespace_cleared then
        api.nvim_buf_clear_namespace(self.bufnr, state.namespace, 0, -1)
        current_result.namespace_cleared = true
      end

      local highlights = current_result.highlights
      local idx = binary_search(highlights, topline)

      for i = idx, #highlights do
        local token = highlights[i]

        if token.line > botline then
          break
        end

        if not token.extmark_added then
          for _, hl_group in ipairs(transformer(token) or {}) do
            api.nvim_buf_set_extmark(self.bufnr, state.namespace, token.line, token.start_col, {
              hl_group = hl_group.name,
              end_col = token.end_col,
              priority = hl_group.priority,
              strict = false,
            })
          end

          token.extmark_added = true
        end
      end
    end
  end
end

local M = {}

function M.setup(custom_transformer)
  -- override the on_win decorator function in the semantic tokens built-in module
  semantic_tokens.__STHighlighter.on_win = on_win
  if custom_transformer then
    transformer = custom_transformer
  end
end

return M
