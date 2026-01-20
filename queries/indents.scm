; Indent after ->
(clause_body) @indent

; Indent inside blocks
(case_expr) @indent
(if_expr) @indent
(receive_expr) @indent
(try_expr) @indent
(fun_expr) @indent
(begin_end_expr) @indent

; Dedent on end keywords
"end" @dedent

; Align on delimiters
["(" "[" "{" "<<"] @indent
[")" "]" "}" ">>"] @dedent
