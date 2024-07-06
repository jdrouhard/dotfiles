local api = vim.api
local fn = vim.fn
local fs = vim.fs

local alt_map = {
  hpp = { 'cpp', 'c', 'cxx', },
  hxx = { 'cxx', 'c', 'cpp', },
  h = { 'c', 'cpp', 'cxx', },
  cpp = { 'hpp', 'h', 'hxx', },
  cxx = { 'hxx', 'h', 'hpp', },
  cc = { 'h', 'hpp', 'hxx', },
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
--- @return string[] alternates
function M.find_alternates(bufnr)
  if not bufnr then
    bufnr = 0
  end

  local base_dir = fn.getcwd()
  local path = api.nvim_buf_get_name(bufnr)
  local dir, base, ext = split_filename(path)
  local alt_exts = alt_map[ext] or {}
  local checked = {}

  local function scan_dir(scan)
    local files = {}
    local iter = fs.dir(scan, {
      depth = 10,
      skip = function(name)
        name = fs.joinpath(scan, name)
        if checked[name] ~= nil or fs.basename(name):match('^%.') then
          return false
        end
        checked[name] = true
        return true
      end,
    })

    for entry, type in iter do
      if (type == 'file' or type == 'link') then
        local _, entry_base, entry_ext = split_filename(entry)
        if entry_base == base and vim.list_contains(alt_exts, entry_ext) then
          files[#files + 1] = fs.joinpath(scan, entry)
        end
      end
    end
    return files
  end

  repeat
    local matching_files = scan_dir(dir)
    if #matching_files > 0 then
      return matching_files
    end
    dir = fs.dirname(dir) or base_dir
  until dir == base_dir

  return {}
end

function M.jump_alternate(bufnr)
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
    local alternates = M.find_alternates(bufnr)
    if #alternates > 0 then
      local alt_bufnr = fn.bufadd(alternates[1])
      if not alt_bufnr then return end

      vim.b[bufnr].alternate = alt_bufnr
      jump(alt_bufnr)
    end
  end
end

return M
