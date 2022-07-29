local M = {}

M.icons = {
   powerline = {
      -- 
      vertical_bar_thin  = '│',
      vertical_bar       = '┃',
      block              = '█',
      ----------------------------------------------
      left  = '', left_filled  = '',
      right = '', right_filled = '',
      ----------------------------------------------
      slant_left    = '', slant_left_thin    = '',
      slant_right   = '', slant_right_thin   = '',
      ----------------------------------------------
      slant_left_2  = '', slant_left_2_thin  = '',
      slant_right_2 = '', slant_right_2_thin = '',
      ----------------------------------------------
      left_rounded  = '', left_rounded_thin  = '',
      right_rounded = '', right_rounded_thin = '',
      ----------------------------------------------
      trapezoid_left  = '', trapezoid_right = '',
      ----------------------------------------------
      line_number   = '', column_number = '',
   },
   padlock      = '',
   circle_small = '●', -- ●
   circle       = '', -- 
   circle_plus  = '', -- 
   dot_circle_o = '', -- 
   circle_o     = '⭘', -- ⭘
}

M.mode = setmetatable({
   n        = 'normal' ,
   no       = 'op',
   nov      = 'op',
   noV      = 'op',
   ["no"] = 'op',
   niI      = 'normal',
   niR      = 'normal',
   niV      = 'normal',
   nt       = 'normal',
   v        = "visual",
   V        = "visual_lines",
   [""]   = "visual_block",
   s        = "select",
   S        = "select",
   [""]   = "block",
   i        = "insert",
   ic       = "insert",
   ix       = "insert",
   R        = "replace",
   Rc       = "replace",
   Rv       = "v_replace",
   Rx       = "replace",
   c        = "command",
   cv       = "command",
   ce       = "command",
   r        = "enter",
   rm       = "more",
   ["r?"]   = "confirm",
   ["!"]    = "shell",
   t        = "terminal",
   ["null"] = "none",
}, {
   __call = function (self, raw_mode)
      return self[raw_mode]
   end
})

M.mode_label = {
   normal       = "NORMAL",
   op           = "OP",
   visual       = "VISUAL",
   visual_lines = "VISUAL LINES",
   visual_block = "VISUAL BLOCK",
   select       = "SELECT",
   block        = "BLOCK",
   insert       = "INSERT",
   replace      = "REPLACE",
   v_replace    = "V-REPLACE",
   command      = "COMMAND",
   enter        = "ENTER",
   more         = "MORE",
   confirm      = "CONFIRM",
   shell        = "SHELL",
   terminal     = "TERMINAL",
   none         = "NONE"
}

M.mode_colors = {
   normal       = "blue",
   op           = "cyan",
   visual       = "purple",
   visual_lines = "purple",
   visual_block = "purple",
   select       = "cyan",
   block        = "cyan",
   insert       = "green",
   replace      = "red",
   v_replace    = "red",
   command      = "orange",
   enter        = "orange",
   more         = "red",
   confirm      = "purple",
   shell        = "green",
   terminal     = "green",
   none         = "status_fg"
}

M.setup_colors = function()
  local get_highlight = require('heirline.utils').get_highlight
  local get = function(name)
    local highlight = get_highlight(name)
    if highlight.reverse then
      highlight.fg, highlight.bg = highlight.bg, highlight.fg
    end
    return highlight
  end

  return {
    bright_bg  = get("Folded").bg,
    red        = get("DiagnosticError").fg,
    dark_red   = get("DiffDelete").bg,
    green      = get("String").fg,
    blue       = get("Function").fg,
    gray       = get("Comment").fg,
    orange     = get("Constant").fg,
    purple     = get("Statement").fg,
    cyan       = get("Special").fg,
    diag_warn  = get("DiagnosticWarn").fg,
    diag_error = get("DiagnosticError").fg,
    diag_hint  = get("DiagnosticHint").fg,
    diag_info  = get("DiagnosticInfo").fg,
    git_del    = get("GitSignsDelete").fg,
    git_add    = get("GitSignsAdd").fg,
    git_change = get("GitSignsChange").fg,
    status_fg  = get("Statusline").fg,
    status_bg  = get("Statusline").bg,
    search_fg  = get("Search").fg,
    search_bg  = get("Search").bg,
  }
end

return M
