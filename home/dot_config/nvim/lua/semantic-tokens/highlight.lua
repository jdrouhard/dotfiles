local api = vim.api
local lsp_util = require('vim.lsp.util')

local config = require('semantic-tokens.config')
local util = require('semantic-tokens.util')

local namespace = api.nvim_create_namespace('semantic-tokens')
local global_cache
local ft_cache

local function create_global_cache()
  return setmetatable({}, {
    __index = function(map_cache, name)
      local result = ''
      if util.highlight_exists(name) then
        result = name
      end
      rawset(map_cache, name, result)
      return result
    end
  })
end

local function create_ft_cache()
  return setmetatable({}, {
    __index = function(ft_cache, ft)
      local map = setmetatable({}, {
        __index = function(map_cache, name)
          local prefixed = ft .. name
          local result = ''
          if util.highlight_exists(prefixed) then
            result = prefixed
          else
            local main_hl = global_cache[name]
            if main_hl ~= '' then
              result = main_hl
            end
          end
          rawset(map_cache, name, result)
          return result
        end
      })
      rawset(ft_cache, ft, map)
      return map
    end,
  })
end

local function get_highlights(ft, type, modifiers)
  local prefix = config.options.prefix
  local priority = config.options.priority
  local result = {}

  local cache = ft_cache[ft]
  local function add_group(priority, ...)
    local group = cache[util.format_hl_name(prefix, ...)]
    if group ~= '' then
      result[#result + 1] = { name = group, priority = priority }
    end
  end

  -- priority: generic modifier, type, generic modifier + type
  add_group(priority + 1, type)
  for _, modifier in ipairs(modifiers) do
    add_group(priority, modifier)
    add_group(priority + 2, modifier, type)
  end

  return result
end

local M = {}

function M.reset()
  global_cache = create_global_cache()
  ft_cache = create_ft_cache()
end

function M.highlight_token(ctx, token)
  local line = token.line

  local function get_byte_pos(char_pos)
    return lsp_util._get_line_byte_from_position(ctx.bufnr, { line = line, character = char_pos }, token.offset_encoding)
  end

  local start_col = get_byte_pos(token.start_char)
  local end_col = get_byte_pos(token.start_char + token.length)
  local ft = api.nvim_buf_get_option(ctx.bufnr, 'filetype')
  local groups = get_highlights(ft, token.type, token.modifiers)

  for _, group in ipairs(groups) do
    api.nvim_buf_set_extmark(ctx.bufnr, namespace, line, start_col, {
      end_col = end_col,
      hl_group = group.name,
      priority = group.priority,
      strict = false,
    })
  end
end

function M.invalidate_highlight(ctx, line_start, line_end)
  api.nvim_buf_clear_namespace(ctx.bufnr, namespace, line_start, line_end)
end

return M
