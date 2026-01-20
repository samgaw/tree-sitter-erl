;; Copyright (c) Facebook, Inc. and its affiliates.
;;
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;     http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.
;; ---------------------------------------------------------------------

;; Based initially on the contents of https://github.com/WhatsApp/tree-sitter-erlang/issues/2 by @Wilfred
;; and https://github.com/the-mikedavis/tree-sitter-erlang/blob/main/queries/highlights.scm
;;
;; The tests are also based on those in
;; https://github.com/the-mikedavis/tree-sitter-erlang/tree/main/test/highlight
;;

;; Last match wins in this file.
;; As of https://github.com/tree-sitter/tree-sitter/blob/master/CHANGELOG.md#breaking-1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Primitive types
(string) @string
(char) @constant
(integer) @number
(float) @number.float
(var) @variable
(atom) @string.special.symbol

;; Language constants (must come after atom to override)
((atom) @constant.builtin
  (#any-of? @constant.builtin "true" "false" "undefined"))

;;; Comments
((var) @comment.discard
 (#match? @comment.discard "^_"))

(dotdotdot) @comment.discard
(comment) @comment

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Functions
(fa fun: (atom) @function)
(type_name name: (atom) @function)
(call expr: (atom) @function)
(function_clause name: (atom) @function)
(internal_fun fun: (atom) @function)

;; This is a fudge, we should check that the operator is '/'
;; But our grammar does not (currently) provide it
(binary_op_expr lhs: (atom) @function rhs: (integer))

;; Built-in functions (BIFs) - guard-safe functions and common BIFs
;; Must come after general function rules since last match wins
(call expr: (atom) @function.builtin
  (#any-of? @function.builtin
    ;; Type checking
    "is_atom" "is_binary" "is_bitstring" "is_boolean" "is_float"
    "is_function" "is_integer" "is_list" "is_map" "is_map_key"
    "is_number" "is_pid" "is_port" "is_reference" "is_tuple"
    ;; Guard-safe BIFs
    "abs" "bit_size" "byte_size" "element" "hd" "length"
    "map_size" "node" "round" "self" "size" "tl" "trunc" "tuple_size"))

;; Others
(remote_module module: (atom) @module)
(remote fun: (atom) @function)
(macro_call_expr name: (var) @constant)
(macro_call_expr name: (var) @keyword.directive args: (_) )
(macro_call_expr name: (atom) @keyword.directive)
(record_field_name name: (atom) @property)
(record_name name: (atom) @type)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Attributes

;; module attribute
(module_attribute
  name: (atom) @module)

;; behaviour
(behaviour_attribute name: (atom) @module)

;; export

;; Import attribute
(import_attribute
    module: (atom) @module)

;; export_type

;; optional_callbacks

;; compile
(compile_options_attribute
    options: (tuple
      expr: (atom)
      expr: (list
        exprs: (binary_op_expr
          lhs: (atom)
          rhs: (integer)))))

;; file attribute

;; record
(record_decl name: (atom) @type)
(record_decl name: (macro_call_expr name: (var) @constant))
(record_field name: (atom) @property)

;; type alias

;; opaque

;; Spec attribute
(spec fun: (atom) @function)
(spec
  module: (module name: (atom) @module)
  fun: (atom) @function)

;; callback
(callback fun: (atom) @function)

;; doc/moduledoc attributes (OTP 27+)
(doc_attribute
  (string) @comment.documentation)
(moduledoc_attribute
  (string) @comment.documentation)

;; wild attribute
(wild_attribute name: (attr_name name: (atom) @keyword))

;; fun decl

;; include/include_lib

;; ifdef/ifndef
(pp_ifdef name: (_) @keyword.directive)
(pp_ifndef name: (_) @keyword.directive)

;; define
(pp_define
    lhs: (macro_lhs
      name: (var) @constant))
(pp_define
    lhs: (macro_lhs
      name: (_) @keyword.directive
      args: (var_args args: (var))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reserved words
[ "after"
  "and"
  "band"
  "begin"
  "behavior"
  "behaviour"
  "bnot"
  "bor"
  "bsl"
  "bsr"
  "bxor"
  "callback"
  "case"
  "catch"
  "compile"
  "define"
  "div"
  "doc"
  "elif"
  "else"
  "end"
  "endif"
  "export"
  "export_type"
  "file"
  "fun"
  "if"
  "ifdef"
  "ifndef"
  "import"
  "include"
  "include_lib"
  "module"
  "moduledoc"
  "of"
  "opaque"
  "optional_callbacks"
  "or"
  "receive"
  "record"
  "spec"
  "try"
  "type"
  "undef"
  "unit"
  "when"
  "xor"] @keyword

["andalso" "orelse"] @keyword.operator

;; Punctuation
["," "." ";"] @punctuation.delimiter
["(" ")" "{" "}" "[" "]" "<<" ">>"] @punctuation.bracket

;; Operators
["!"
 "->"
 "<-"
 "#"
 "::"
 "|"
 ":"
 "="
 "||"

 "+"
 "-"
 "bnot"
 "not"

 "/"
 "*"
 "div"
 "rem"
 "band"
 "and"

 "+"
 "-"
 "bor"
 "bxor"
 "bsl"
 "bsr"
 "or"
 "xor"

 "++"
 "--"

 "=="
 "/="
 "=<"
 "<"
 ">="
 ">"
 "=:="
 "=/="
 ] @operator

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Binary type specifiers
(bit_type_list
  types: (atom) @type.builtin
  (#any-of? @type.builtin
    ;; Types
    "integer" "float" "binary" "bytes" "bitstring" "bits"
    ;; Unicode
    "utf8" "utf16" "utf32"
    ;; Signedness
    "signed" "unsigned"
    ;; Endianness
    "big" "little" "native"))
