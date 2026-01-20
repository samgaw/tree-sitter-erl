; Scopes - structures that introduce new variable scopes
(fun_decl) @local.scope
(anonymous_fun) @local.scope
(case_expr) @local.scope
(receive_expr) @local.scope
(try_expr) @local.scope

; Definitions
(function_clause name: (atom) @local.definition.function)
(var) @local.definition

; References
(var) @local.reference
