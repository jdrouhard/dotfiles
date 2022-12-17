; extends

(operator_cast) [ "operator" ] @function

(auto) @type

[
 "class"
 "struct"
 "union"
 "template"
 "typename"
] @structure

[
 "using"
] @statement

[
 "private"
 "protected"
 "public"
] @keyword.access

[
 "inline"
 "virtual"
 "explicit"
 "override"
 "final"
] @keyword.function

[
 "static"
 "volatile"
 "extern"
 "const"
 "mutable"
 "constexpr"
 "constinit"
 "consteval"
 "thread_local"
] @storageclass

[
 "static_assert"
 "sizeof"
] @keyword.operator
