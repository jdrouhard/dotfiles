; extends

(operator_cast) [ "operator" ] @function

(module_name) @module

((module_name) @module.builtin
  (#eq? @module.builtin "std"))

((namespace_identifier) @module.builtin
  (#eq? @module.builtin "std"))

(using_declaration
  (identifier) @module.builtin
  (#eq? @module.builtin "std"))

(alignas_qualifier (identifier) @type)

(lambda_specifier) @keyword.modifier

[
 "alignas"
 "constinit"
 "consteval"
 "thread_local"
] @keyword

[
 "extern"
] @keyword.modifier

[
 "module"
 "import"
 "export"
] @keyword.import

[
 "inline"
 "explicit"
 "override"
 "final"
 "virtual"
] @keyword.function

[
 "[:"
 ":]"
] @punctuation.bracket

"^^" @operator
