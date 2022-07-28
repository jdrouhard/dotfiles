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
   replace      = "orange",
   v_replace    = "orange",
   command      = "orange",
   enter        = "orange",
   more         = "red",
   confirm      = "purple",
   shell        = "red",
   terminal     = "green",
   none         = "status_fg"
}

M.setup_colors = function()
  local get_highlight = require('heirline.utils').get_highlight
  return {
    bright_bg  = get_highlight("Folded").bg,
    red        = get_highlight("DiagnosticError").fg,
    dark_red   = get_highlight("DiffDelete").bg,
    green      = get_highlight("String").fg,
    blue       = get_highlight("Function").fg,
    gray       = get_highlight("Comment").fg,
    orange     = get_highlight("Constant").fg,
    purple     = get_highlight("Statement").fg,
    cyan       = get_highlight("Special").fg,
    search     = get_highlight("Search").bg,
    diag_warn  = get_highlight("DiagnosticWarn").fg,
    diag_error = get_highlight("DiagnosticError").fg,
    diag_hint  = get_highlight("DiagnosticHint").fg,
    diag_info  = get_highlight("DiagnosticInfo").fg,
    git_del    = get_highlight("GitSignsDelete").fg,
    git_add    = get_highlight("GitSignsAdd").fg,
    git_change = get_highlight("GitSignsChange").fg,
    status_fg  = get_highlight("Statusline").fg,
    status_bg  = get_highlight("Statusline").bg,
  }
end

return M
