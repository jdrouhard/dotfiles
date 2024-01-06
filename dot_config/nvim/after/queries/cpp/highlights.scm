; extends

(operator_cast) [ "operator" ] @function

(alignas_specifier (identifier) @type)

[
 "alignas"
] @keyword

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
