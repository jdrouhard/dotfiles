local M = {
  'rebelot/heirline.nvim',
  dependencies = {
    'kyazdani42/nvim-web-devicons',
  }
}

function M.config()
  local conditions    = require('heirline.conditions')
  local devicons      = require('nvim-web-devicons')
  local heirline      = require('heirline')
  local heirline_util = require('heirline.utils')
  local status        = require('plugins.lsp.status')

  local os_sep = package.config:sub(1, 1)

  local icons = {
    padlock      = '',
    circle_small = '●', -- ●
    circle       = '', -- 
    circle_plus  = '', -- 
    dot_circle_o = '', -- 
    circle_o     = '⭘', -- ⭘
  }

  local mode = setmetatable({
    n        = 'normal',
    no       = 'op',
    nov      = 'op',
    noV      = 'op',
    ['no']  = 'op',
    niI      = 'normal',
    niR      = 'normal',
    niV      = 'normal',
    nt       = 'normal',
    v        = 'visual',
    V        = 'visual_lines',
    ['']    = 'visual_block',
    s        = 'select',
    S        = 'select',
    ['']    = 'block',
    i        = 'insert',
    ic       = 'insert',
    ix       = 'insert',
    R        = 'replace',
    Rc       = 'replace',
    Rv       = 'v_replace',
    Rx       = 'replace',
    c        = 'command',
    cv       = 'command',
    ce       = 'command',
    r        = 'enter',
    rm       = 'more',
    ['r?']   = 'confirm',
    ['!']    = 'shell',
    t        = 'terminal',
    ['null'] = 'none',
  }, {
    __call = function(self, raw_mode)
      return self[raw_mode]
    end
  })

  local mode_label = {
    normal       = 'NORMAL',
    op           = 'OP',
    visual       = 'VISUAL',
    visual_lines = 'VISUAL LINES',
    visual_block = 'VISUAL BLOCK',
    select       = 'SELECT',
    block        = 'BLOCK',
    insert       = 'INSERT',
    replace      = 'REPLACE',
    v_replace    = 'V-REPLACE',
    command      = 'COMMAND',
    enter        = 'ENTER',
    more         = 'MORE',
    confirm      = 'CONFIRM',
    shell        = 'SHELL',
    terminal     = 'TERMINAL',
    none         = 'NONE'
  }

  local mode_colors = {
    normal       = 'blue',
    op           = 'cyan',
    visual       = 'purple',
    visual_lines = 'purple',
    visual_block = 'purple',
    select       = 'cyan',
    block        = 'cyan',
    insert       = 'green',
    replace      = 'red',
    v_replace    = 'red',
    command      = 'orange',
    enter        = 'orange',
    more         = 'red',
    confirm      = 'purple',
    shell        = 'green',
    terminal     = 'green',
    none         = 'status_fg'
  }

  local function setup_colors()
    local get_highlight = heirline_util.get_highlight
    local get = function(name)
      local highlight = get_highlight(name)
      if highlight.reverse then
        highlight.fg, highlight.bg = highlight.bg, highlight.fg
      end
      if not highlight then
        highlight = {}
      end
      return highlight
    end

    return {
      bright_bg  = get('Folded').bg,
      red        = get('DiagnosticError').fg,
      dark_red   = get('DiffDelete').bg,
      green      = get('String').fg,
      blue       = get('Function').fg,
      gray       = get('Comment').fg,
      orange     = get('Constant').fg,
      purple     = get('Statement').fg,
      cyan       = get('Special').fg,
      diag_warn  = get('DiagnosticWarn').fg,
      diag_error = get('DiagnosticError').fg,
      diag_hint  = get('DiagnosticHint').fg,
      diag_info  = get('DiagnosticInfo').fg,
      git_del    = get('GitSignsDelete').fg,
      git_add    = get('GitSignsAdd').fg,
      git_change = get('GitSignsChange').fg,
      status_fg  = get('StatusLine').fg,
      status_bg  = get('StatusLine').bg,
      search_fg  = get('Search').fg,
      search_bg  = get('Search').bg,
    }
  end

  -- Flexible components priorities
  local priority = {
    CurrentPath = 60,
    Git = 40,
    Lsp = 30,
    WorkDir = 25,
  }

  local Align = { provider = '%=' }
  local Space = setmetatable({ provider = ' ' }, {
    __call = function(_, n)
      return { provider = string.rep(' ', n) }
    end
  })
  --local null  = { provider = '' }

  local ReadOnly = {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = icons.padlock,
    hl = function()
      if conditions.is_active() then
        return { fg = 'red' }
      end
    end
  }

  local ReadWrite = {
    provider = icons.circle,
    hl = function()
      if vim.bo.modified then
        return { fg = 'green' }
      end
    end
  }

  local FileStatus = {
    fallthrough = false,
    ReadOnly, ReadWrite,
  }

  local VimModeInactive = {
    condition = function()
      return not conditions.is_active()
    end,
    hl = { fg = 'gray' },
    Space, FileStatus, Space
  }

  local VimModeActive = {
    condition = function()
      return conditions.is_active()
    end,
    hl = function(self)
      return { bg = mode_colors[self.mode], fg = 'status_bg', bold = true }
    end,
    Space, FileStatus, Space,
    {
      provider = function(self)
        return mode_label[self.mode]
      end,
    },
    Space,
  }

  local VimMode = {
    init = function(self)
      self.mode = mode[vim.fn.mode(1)] -- :h mode()
    end,
    VimModeActive, VimModeInactive, Space
  }

  local FileIcon = {
    init = function(self)
      if self.filetype ~= '' then
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ':e')
        self.icon, self.icon_color = devicons.get_icon_color(filename, extension, { default = true })
      end
    end,
    provider = function(self)
      if self.icon then return self.icon end
    end,
    hl = function(self)
      return { fg = self.icon_color }
    end,
  }

  local FileType = {
    init = function(self)
      self.filetype = vim.bo.filetype
    end,
    FileIcon, Space,
    {
      provider = function(self)
        return self.filetype
      end
    },
    Space
  }

  local WorkDir = {
    condition = function(self) return self.pwd end,
    hl = { fg = 'gray' },
    flexible = priority.WorkDir,
    {
      provider = function(self) return self.pwd end,
    },
    {
      provider = function(self)
        return vim.fn.pathshorten(self.pwd)
      end,
    },
    {
      provider = ''
    },
  }

  local CurrentPath = {
    condition = function(self) return self.current_path end,
    flexible = priority.CurrentPath,
    {
      provider = function(self) return self.current_path end,
    },
    {
      provider = function(self)
        return vim.fn.pathshorten(self.current_path, 2)
      end,
    },
    {
      provider = ''
    },
    hl = { fg = 'blue' }
  }

  local FileName = {
    provider = function(self) return self.filename end,
    hl = { bold = true }
  }

  local GPS = {
    condition = function(self)
      if package.loaded['nvim-gps'] then
        self.nvim_gps = require('nvim-gps')
        return self.nvim_gps.is_available()
      end
      return false
    end,
    provider = function(self)
      local location = self.nvim_gps.get_location()
      if location ~= '' then
        return '> ' .. location .. ' '
      end
    end,
    hl = { fg = 'gray' },
  }

  local FileProperties = {
    condition = function(self)
      local encoding = (vim.bo.fileencoding ~= '' and vim.bo.fileencoding) or vim.o.encoding
      self.encoding = (encoding ~= 'utf-8') and encoding or nil

      local fileformat = vim.bo.fileformat

      -- if fileformat == 'dos' then
      --    fileformat = ' '
      -- elseif fileformat == 'mac' then
      --    fileformat = ' '
      -- else  -- unix'
      --    fileformat = ' '
      --    -- fileformat = nil
      -- end

      if fileformat == 'dos' then
        fileformat = 'CRLF'
      elseif fileformat == 'mac' then
        fileformat = 'CR'
      else -- unix'
        -- fileformat = 'LF'
        fileformat = nil
      end

      self.fileformat = fileformat

      return self.fileformat or self.encoding
    end,
    provider = function(self)
      local sep
      if self.fileformat and self.encoding then sep = ' ' end
      return table.concat { ' ', self.fileformat or '', sep or '', self.encoding or '', ' ' }
    end,
  }

  local FileNameBlock = {
    {
      fallthrough = false,
      {
        condition = conditions.is_active,
        WorkDir, CurrentPath, FileName
      }, {
        FileName,
        hl = { fg = 'gray', bold = true, force = true }
      },
    },
    -- This means that the statusline is cut here when there's not enough space.
    { provider = '%<' }
  }

  local DapMessages = {
    -- display the dap messages only on the debugged file
    condition = function(self)
      if package.loaded['dap'] then
        self.dap = require('dap')
        local session = self.available and self.dap.session()
        if session then
          local filename = vim.api.nvim_buf_get_name(0)
          if session.config then
            local progname = session.config.program
            return filename == progname
          end
        end
      end
      return false
    end,
    provider = function(self)
      return ' ' .. self.dap.status() .. ' '
    end,
  }

  local Diagnostics = {
    condition = conditions.has_diagnostics,
    init = function(self)
      local get_icon  = function(name)
        local sign = vim.fn.sign_getdefined(name)
        if not vim.tbl_isempty(sign) then
          return sign[1].text
        else
          return ''
        end
      end
      self.error_icon = get_icon('DiagnosticSignError')
      self.warn_icon  = get_icon('DiagnosticSignWarn')
      self.info_icon  = get_icon('DiagnosticSignInfo')
      self.hint_icon  = get_icon('DiagnosticSignHint')
      self.errors     = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings   = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.hints      = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.info       = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    {
      provider = function(self)
        -- 0 is just another output, we can decide to print it or not!
        if self.errors > 0 then
          return table.concat { self.error_icon, self.errors, ' ' }
        end
      end,
      hl = { fg = 'diag_error' }
    },
    {
      provider = function(self)
        if self.warnings > 0 then
          return table.concat { self.warn_icon, self.warnings, ' ' }
        end
      end,
      hl = { fg = 'diag_warn' }
    },
    {
      provider = function(self)
        if self.info > 0 then
          return table.concat { self.info_icon, self.info, ' ' }
        end
      end,
      hl = { fg = 'diag_info' }
    },
    {
      provider = function(self)
        if self.hints > 0 then
          return table.concat { self.hint_icon, self.hints, ' ' }
        end
      end,
      hl = { fg = 'diag_hint' }
    },
    Space(2)
  }

  local GitBranch = {
    condition = conditions.is_git_repo,
    init = function(self)
      self.git_status = vim.b.gitsigns_status_dict
    end,
    hl = { fg = 'purple' },
    provider = function(self)
      return table.concat { ' ', self.git_status.head, ' ' }
    end,
  }

  local GitChanges = {
    condition = function(self)
      if conditions.is_git_repo() then
        self.git_status = vim.b.gitsigns_status_dict
        local has_changes = self.git_status.added ~= 0 or
            self.git_status.removed ~= 0 or
            self.git_status.changed ~= 0
        return has_changes
      end
    end,
    {
      provider = function(self)
        local count = self.git_status.added or 0
        return count > 0 and table.concat { '+', count, ' ' }
      end,
      hl = { fg = 'git_add' }
    },
    {
      provider = function(self)
        local count = self.git_status.changed or 0
        return count > 0 and table.concat { '~', count, ' ' }
      end,
      hl = { fg = 'git_change' }
    },
    {
      provider = function(self)
        local count = self.git_status.removed or 0
        return count > 0 and table.concat { '-', count, ' ' }
      end,
      hl = { fg = 'git_del' }
    },
    Space
  }

  local Git = {
    flexible = priority.Git,
    { GitBranch, GitChanges },
    { GitBranch }
  }

  local LspIndicator = {
    provider = icons.circle_small .. ' ',
  }

  local LspServer = {
    Space,
    {
      provider = function(self)
        local names = self.lsp_names
        if #names == 1 then
          names = names[1]
        else
          names = table.concat(vim.tbl_flatten({ '[', names, ']' }), ' ')
        end
        return names
      end,
    },
    Space(2),
  }

  local LspServerMessages = {
    Space,
    {
      provider = function(self)
        local status_msgs = status.statusline()
        local msgs = {}
        for _, name in ipairs(self.lsp_names) do
          local client_msgs = status_msgs[name]
          if client_msgs then
            table.insert(msgs, string.format('%s: %s', name, table.concat(client_msgs, ' ')))
          else
            table.insert(msgs, name)
          end
        end

        if #msgs == 1 then
          msgs = msgs[1]
        else
          msgs = table.concat(vim.tbl_flatten({ '[', msgs, ']' }), ' ')
        end
        return msgs
      end,
    },
    Space(2),
  }

  local Lsp = {
    condition = conditions.lsp_attached,
    init = function(self)
      local names = {}
      for _, server in pairs(vim.lsp.buf_get_clients(0)) do
        table.insert(names, server.name)
      end
      self.lsp_names = names
    end,
    hl = { fg = 'cyan', bold = true },
    flexible = priority.Lsp,
    LspServerMessages,
    LspServer,
    LspIndicator,
  }

  local Coc = {
    condition = function()
      return false
      --local info = _G.packer_plugins['coc.nvim']
      --return info and info.loaded
    end,
    hl = { fg = 'cyan', bold = true },
    provider = function()
      return vim.fn['coc#status']()
    end,
    Space(2)
  }

  local SearchResults = {
    condition = function(self)
      local lines = vim.api.nvim_buf_line_count(0)
      if lines > 50000 then return end

      local query = vim.fn.getreg('/')
      if query == '' then return end

      if query:find('@') then return end

      local search_count = vim.fn.searchcount({ recompute = 1, maxcount = -1 })
      local active = false
      if vim.v.hlsearch and vim.v.hlsearch == 1 and search_count.total > 0 then
        active = true
      end
      if not active then return end

      query = query:gsub([[^\V]], '')
      query = query:gsub([[\<]], ''):gsub([[\>]], '')

      self.query = query
      self.count = search_count
      return true
    end,
    {
      provider = function(self)
        return table.concat {
          -- ' ', self.query, ' ', self.count.current, '/', self.count.total, ' '
          ' ', self.count.current, '/', self.count.total, ' '
        }
      end,
      hl = { fg = 'search_fg', bg = 'search_bg' }
    },
    Space
  }

  local Ruler = {
    -- %-2 : make item takes at least 2 cells and be left justified
    -- %l  : current line number
    -- %L  : number of lines in the buffer
    -- %c  : column number
    --provider = ' %7(%l:%3L%)  %-2c ',
    --provider = ' %7(%l:%L%)  %-2c ',
    provider = ' %7(%l:%-2c%) ',
    hl = { bold = true }
  }

  local ScrollPercentage = {
    condition = function() return conditions.width_percent_below(4, 0.035) end,
    -- %P  : percentage through file of displayed window
    provider = ' %3(%P%)',
    hl = function()
      if conditions.is_active() then
        return nil
      else
        return { fg = 'gray' }
      end
    end
  }
  local ActiveStatusline = {
    VimMode,
    SearchResults,
    FileNameBlock,
    Space(4),
    GPS,
    Align,
    Coc,
    Lsp,
    DapMessages,
    Diagnostics,
    Git,
    Space,
    FileProperties, FileType,
    Ruler, ScrollPercentage
  }

  local InactiveStatusline = {
    condition = function() return not conditions.is_active() end,
    VimMode,
    FileNameBlock, Align, ScrollPercentage
  }

  local HelpBufferStatusline = {
    condition = function()
      return vim.bo.filetype == 'help'
    end,
    Space, FileStatus, Space,
    {
      provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
        return vim.fn.fnamemodify(filename, ':t')
      end,
    },
    Align,
    ScrollPercentage
  }

  local StatusLines = {
    init = function(self)
      local pwd = vim.fn.getcwd(0) -- Present working directory.
      local current_path = vim.api.nvim_buf_get_name(0)
      local filename

      if current_path == '' then
        pwd = vim.fn.fnamemodify(pwd, ':~')
        current_path = nil
        filename = ' [No Name]'
      elseif current_path:find(pwd, 1, true) then
        filename = vim.fn.fnamemodify(current_path, ':t')
        current_path = vim.fn.fnamemodify(current_path, ':~:.:h')
        pwd = vim.fn.fnamemodify(pwd, ':~') .. os_sep
        if current_path == '.' then
          current_path = nil
        else
          current_path = current_path .. os_sep
        end
      else
        pwd = nil
        filename = vim.fn.fnamemodify(current_path, ':t')
        current_path = vim.fn.fnamemodify(current_path, ':~:.:h') .. os_sep
      end

      self.pwd = pwd
      self.current_path = current_path -- The opened file path relevant to pwd.
      self.filename = filename
    end,
    fallthrough = false,
    hl = function()
      if conditions.is_active() then
        return { bg = 'status_bg' }
      else
        return { fg = 'gray', bg = 'status_bg' }
      end
    end,
    HelpBufferStatusline, InactiveStatusline, ActiveStatusline
  }

  heirline.load_colors(setup_colors())

  vim.api.nvim_create_augroup('Heirline', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
      heirline_util.on_colorscheme(setup_colors())
    end,
    group = 'Heirline',
  })

  heirline.setup(StatusLines)
end

return M
