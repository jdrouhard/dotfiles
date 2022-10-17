local defaults = {
  prefix = 'Lsp',
  priority = 110,
  use_default_highlight_groups = true,
  default_highlight_groups = {
    namespace     = {'@namespace',    'Include'},
    type          = {'@type',         'Type'},
    class         = {'@structure',    'Structure'},
    enum          = {'@type',         'Type'},
    interface     = {'@type',         'Type'},
    struct        = {'@structure',    'Structure'},
    typeParameter = {'@parameter',    'Identifier'},
    parameter     = {'@parameter',    'Identifier'},
    variable      = {'@variable',     'Identifier'},
    property      = {'@property',     'Identifier'},
    enumMember    = {'@constant',     'Constant'},
    event         = {'@keyword',      'Keyword'},
    ['function']  = {'@function',     'Function'},
    method        = {'@method',       'Function'},
    macro         = {'@macro',        'Macro'},
    keyword       = {'@keyword',      'Keyword'},
    modifier      = {'@storageclass', 'StorageClass'},
    comment       = {'@comment',      'Comment'},
    string        = {'@string',       'String'},
    number        = {'@number',       'Number'},
    boolean       = {'@boolean',      'Boolean'},
    regexp        = {'@string.regex', 'String'},
    operator      = {'@operator',     'Operator'},
    decorator     = {'@symbol',       'StorageClass'},
    deprecated    = {'@text.strike',  nil},
  }
}

local M = {}

M.options = {}

function M.set_config(opts)
  M.options = vim.tbl_deep_extend('force', {}, defaults, opts or {})
end

return M
