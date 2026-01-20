;; Copyright (c) Sam Gaw
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

;; Tags for code navigation (definitions and references)

;; =============================================================================
;; Definitions
;; =============================================================================

;; Module definition: -module(name).
(module_attribute
  name: (atom) @name) @definition.module

;; Function definition (each clause)
(function_clause
  name: (atom) @name) @definition.function

;; Record definition: -record(name, {...}).
(record_decl
  name: (atom) @name) @definition.class

;; Type definitions: -type name() :: ..., -opaque name() :: ...
(type_alias
  name: (type_name
    name: (atom) @name)) @definition.type

(opaque
  name: (type_name
    name: (atom) @name)) @definition.type

(nominal
  name: (type_name
    name: (atom) @name)) @definition.type

;; Callback definition: -callback name(...) -> ...
(callback
  fun: (atom) @name) @definition.interface

;; Macro definition: -define(NAME, ...).
(pp_define
  lhs: (macro_lhs
    name: (atom) @name)) @definition.macro

(pp_define
  lhs: (macro_lhs
    name: (var) @name)) @definition.macro

;; =============================================================================
;; References
;; =============================================================================

;; Ignore common keywords that aren't real function calls
(call
  expr: (atom) @ignore
  (#any-of? @ignore
    "error" "throw" "exit"
    "self" "spawn" "spawn_link" "spawn_monitor"
    "link" "unlink" "monitor" "demonitor"
    "register" "unregister" "whereis"
    "send" "receive"
    "get" "put" "erase"
    "hd" "tl" "length"
    "tuple_size" "element" "setelement"
    "map_size" "is_map_key"
    "is_atom" "is_binary" "is_bitstring" "is_boolean"
    "is_float" "is_function" "is_integer" "is_list"
    "is_map" "is_number" "is_pid" "is_port" "is_reference"
    "is_tuple" "is_record"
    "abs" "ceil" "floor" "round" "trunc"
    "binary_part" "bit_size" "byte_size"
    "node" "nodes" "make_ref"
    "size" "max" "min"))

;; Local function call
(call
  expr: (atom) @name) @reference.call

;; Remote function call: module:function(...)
(call
  expr: (remote
    module: (remote_module
      module: (atom) @module)
    fun: (atom) @name)) @reference.call

;; Internal fun reference: fun name/arity
(internal_fun
  fun: (atom) @name) @reference.call

;; External fun reference: fun module:name/arity
(external_fun
  module: (module
    name: (atom) @module)
  fun: (atom) @name) @reference.call

;; Module references in behaviours: -behaviour(module).
(behaviour_attribute
  name: (atom) @name) @reference.module

;; Module references in imports: -import(module, [...]).
(import_attribute
  module: (atom) @name) @reference.module

;; Function/arity in exports, imports, optional_callbacks
;; These reference functions defined elsewhere
(export_attribute
  funs: (fa
    fun: (atom) @name)) @reference.call

(import_attribute
  funs: (fa
    fun: (atom) @name)) @reference.call

(optional_callbacks_attribute
  callbacks: (fa
    fun: (atom) @name)) @reference.call

;; Spec references the function it documents
(spec
  fun: (atom) @name) @reference.call
