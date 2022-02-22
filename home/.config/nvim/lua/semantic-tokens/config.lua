local M = {}

M.config = {
  prefix = 'Lsp',
  priority = 110,
  use_default_highlight_groups = true,
  default_highlight_groups = {
    namespace     = {'TSNamespace',   'Include'},
    type          = {'TSType',        'Type'},
    class         = {'TSConstructor', 'Structure'},
    enum          = {'TSEnum',        'Type'},
    interface     = {'TSInterface',   'Type'},
    struct        = {'TSStruct',      'Structure'},
    typeParameter = {'TSParameter',   'Identifier'},
    parameter     = {'TSParameter',   'Identifier'},
    variable      = {'TSVariable',    'Identifier'},
    property      = {'TSProperty',    'Identifier'},
    enumMember    = {'TSEnumMember',  'Constant'},
    event         = {'TSEvent',       'Keyword'},
    ['function']  = {'TSFunction',    'Function'},
    method        = {'TSMethod',      'Function'},
    macro         = {'TSConstMacro',  'PreProc'},
    keyword       = {'TSKeyword',     'Keyword'},
    modifier      = {'TSModifier',    'StorageClass'},
    comment       = {'TSComment',     'Comment'},
    string        = {'TSString',      'String'},
    number        = {'TSNumber',      'Number'},
    boolean       = {'TSBoolean',     'Boolean'},
    regexp        = {'TSStringRegex', 'String'},
    operator      = {'TSOperator',    'Operator'},
    decorator     = {'TSSymbol',      'StorageClass'},
    deprecated    = {'TSStrike',      nil},
  }
}

M.set_config = function(opts)
  M.config = vim.tbl_deep_extend('keep', opts, M.config)
end

return M
