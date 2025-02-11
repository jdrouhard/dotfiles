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

[
 "alignas"
] @keyword

[
 "module"
 "import"
 "export"
] @keyword.import

[
 "private"
 "protected"
 "public"
] @keyword.access

[
 "inline"
 "explicit"
 "override"
 "final"
 "virtual"
] @keyword.function

[
 "constexpr"
 "constinit"
 "consteval"
 "thread_local"
] @type.qualifier
