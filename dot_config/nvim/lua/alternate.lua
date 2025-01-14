local api = vim.api
local fn = vim.fn
local fs = vim.fs

local alt_map = {
  hpp = { 'cpp', 'cc', 'cxx', 'C', 'c', },
  hxx = { 'cxx', 'cpp', 'cc', 'C', 'c', },
  hh = { 'cc', 'cpp', 'cxx', 'C', 'c', },
  h = { 'c', 'cpp', 'cxx', 'cc', 'C', },
  cpp = { 'hpp', 'hh', 'hxx', 'H', 'h' },
  cxx = { 'hxx', 'hpp', 'hh', 'H', 'h', },
  cc = { 'hh', 'hpp', 'hxx', 'H', 'h', },
  c = { 'h' },
}

--- @param path string
--- @return string dir, string file, string ext
local function split_filename(path)
  return string.match(path, "(.-)[\\/]?([^\\/]-)%.?([^\\/%.]*)$")
end

--- Like vim.fn.bufwinid except it works across tabpages.
--- @param bufnr integer
local function bufwinid(bufnr)
  for _, win in ipairs(api.nvim_list_wins()) do
    if api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end
end


local M = {}

--- @param bufnr integer|nil
--- @param limit integer|nil
--- @param root_marker (string|string[]|fun(name: string, pattern:string): boolean|nil)
--- @return string[] alternates
function M.find_alternates(bufnr, limit, root_marker)
  if not bufnr then
    bufnr = 0
  end

  if not limit then
    limit = math.huge
  end

  if not root_marker then
    root_marker = { '.git' }
  end

  if type(root_marker) == 'string' then
    root_marker = { root_marker }
  end

  local root = fs.root(bufnr, root_marker)
  local path = api.nvim_buf_get_name(bufnr)
  local _, base, ext = split_filename(path)
  local alt_exts = alt_map[ext] or {}
  local checked = {}

  local function scan_dir(scan)
    local dirs = { scan }
    local files = {}

    local function add(match)
      files[#files + 1] = fs.normalize(match)
      if #files == limit then
        return true
      end
    end

    while #dirs > 0 do
      local dir = table.remove(dirs, 1)
      checked[dir] = true
      for entry, type in fs.dir(dir) do
        local f = fs.joinpath(dir, entry)
        if not entry:match('^%.') then
          if (type == 'file' or type == 'link') then
            local _, entry_base, entry_ext = split_filename(entry)
            if entry_base == base and vim.list_contains(alt_exts, entry_ext) then
              if add(f) then
                return files
              end
            end
          end
          if type == 'directory' and not checked[f] then
            dirs[#dirs + 1] = f
          end
        end
      end
    end
    return files
  end

  for dir in fs.parents(path) do
    local matching_files = scan_dir(dir)
    if #matching_files > 0 then
      return matching_files
    end
    if dir == root then
      break
    end
  end

  return {}
end

--- @param bufnr integer|nil
--- @param root_marker (string|string[]|fun(name: string, path: string): boolean|nil)
function M.jump_alternate(bufnr, root_marker)
  if not bufnr or bufnr == 0 then
    bufnr = api.nvim_get_current_buf()
  end

  local function jump(alt_bufnr)
    -- Save position in jumplist
    vim.cmd("normal! m'")

    local win = bufwinid(alt_bufnr) or api.nvim_get_current_win()
    vim.bo[alt_bufnr].buflisted = true
    api.nvim_win_set_buf(win, alt_bufnr)
    api.nvim_set_current_win(win)
  end

  if vim.b[bufnr].alternate then
    jump(vim.b[bufnr].alternate)
  else
    local alternates = M.find_alternates(bufnr, 1, root_marker)
    if #alternates > 0 then
      local alt_bufnr = fn.bufadd(alternates[1])
      if not alt_bufnr then return end

      vim.b[bufnr].alternate = alt_bufnr
      jump(alt_bufnr)
    end
  end
end

return M
