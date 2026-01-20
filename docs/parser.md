# Parser

## The AST

Erlang has a relatively straightforward syntax compared to languages with extensive macro systems. The grammar closely follows the [Erlang Reference Manual](https://www.erlang.org/doc/reference_manual/users_guide.html).

Key aspects of Erlang syntax that the parser handles:

- **Atoms** - lowercase identifiers or quoted strings (e.g., `foo`, `'Hello World'`)
- **Variables** - uppercase identifiers (e.g., `Foo`, `_Bar`)
- **Functions** - defined with clauses separated by `;` and terminated with `.`
- **Pattern matching** - in function heads, case expressions, and assignments
- **Records** - compile-time data structures with named fields
- **Binary syntax** - bit-level data manipulation with `<<>>`
- **Preprocessor directives** - macros, includes, and conditionals

To get a sense of what the AST looks like, have a look at the tests in `test/corpus/`.

## Getting started with Tree-sitter

For detailed introduction see the official guide on [Creating parsers](https://tree-sitter.github.io/tree-sitter/creating-parsers).

Essentially, we define relevant language rules in `grammar.js`, based on which Tree-sitter generates parser code (under `src/`). In some cases, we want to write custom C code for tokenizing specific character sequences (in `src/scanner.c`).

The grammar rules may often conflict with each other, meaning that the given sequence of tokens has multiple valid interpretations given one _token_ of lookahead. In many conflicts we always want to pick one interpretation over the other and we can do this by assigning different precedence and associativity to relevant rules, which tells the parser which way to go.

For example given `expression1 * expression2 * expression3`, the parser needs to decide whether to group as `(expression1 * expression2) * expression3` or `expression1 * (expression2 * expression3)`. Since the `*` operator is left-associative we can use `prec.left` on the corresponding grammar rule, to inform the parser how to resolve this conflict.

However, in some cases looking at one token ahead isn't enough, in which case we can add the conflicting rules to the `conflicts` list in the grammar. Whenever the parser stumbles upon this conflict it uses its GLR algorithm, basically considering both interpretations until one leads to parsing error. If both paths parse correctly (there's a genuine ambiguity) we can use dynamic precedence (`prec.dynamic`) to decide on the preferred path.

## Using the CLI

### tree-sitter

```sh
# See CLI usage
npx tree-sitter -h

# Generate the parser code based on grammar.js
npx tree-sitter generate

# Run tests
npx tree-sitter test
npx tree-sitter test --filter "function"

# Parse a specific file
npx tree-sitter parse tmp/test.erl
npx tree-sitter parse -x tmp/test.erl

# Parse codebase to verify syntax coverage
npx tree-sitter parse --quiet --stat 'tmp/otp/lib/**/*.erl'
```

Whenever you make a change to `grammar.js` remember to run `generate`, before verifying the result. To test custom code, create an Erlang file like `tmp/test.erl` and use `parse` on it. The `-x` flag prints out the source grouped into AST nodes as XML.

## Implementation notes

This section covers some of the implementation decisions that have a more elaborated rationale.

### Operator precedence

Erlang has a well-defined operator precedence table. The grammar aligns with what the Erlang compiler does, as documented in the [Erlang Reference Manual - Operator Precedence](https://www.erlang.org/doc/reference_manual/expressions.html#operator-precedence).

### String and atom handling

Erlang strings are lists of integers, and atoms can be quoted with single quotes. The scanner handles escape sequences within strings and quoted atoms, including:

- Standard escapes: `\n`, `\t`, `\r`, etc.
- Octal escapes: `\NNN`
- Hex escapes: `\xHH`
- Unicode escapes: `\x{H...}`

### Binary syntax

Erlang's binary syntax (`<<>>`) is particularly expressive, allowing bit-level specifications with type, size, unit, and endianness modifiers. The grammar captures the full range of binary comprehensions and bit string expressions.

### Preprocessor directives

The parser handles Erlang's preprocessor directives including:

- `-define(Name, Replacement).` - macro definitions
- `-include("file.hrl").` / `-include_lib("app/include/file.hrl").`
- `-ifdef(Name).` / `-ifndef(Name).` / `-else.` / `-endif.`
- `-undef(Name).`

Macro invocations (`?MACRO` and `?MACRO(Args)`) are parsed as expressions.

### OTP version support

The grammar supports syntax from recent OTP versions including:

- OTP 26: `maybe` expressions, map comprehensions
- OTP 27: doc attributes (`-doc`, `-moduledoc`)
- OTP 28: based floating point literals, nominal types, zip generators
