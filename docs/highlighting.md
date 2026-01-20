# Syntax highlighting

For detailed introduction see the official guide on [Syntax highlighting](https://tree-sitter.github.io/tree-sitter/syntax-highlighting).

Briefly speaking, Tree-sitter uses the rules in `queries/highlights.scm` to annotate nodes with specific tokens, then it maps those tokens to formatting style according to user-defined theme.

## Query files

This grammar provides several query files:

- `queries/highlights.scm` - syntax highlighting rules
- `queries/locals.scm` - scope and variable definition tracking
- `queries/indents.scm` - automatic indentation rules
- `queries/folds.scm` - code folding regions
- `queries/tags.scm` - symbol extraction for navigation
- `queries/injections.scm` - language injection (e.g., Markdown in doc strings)

## Testing highlighting

To test highlighting using the CLI, you need to create local configuration.

```shell
# Create the config file
npx tree-sitter init-config
```

The above command should print out the config location, so that you can further configure it.
Open the file and modify `"parser-directories"` to include the parent directory of `tree-sitter-erl`.

You can optionally customise the theme. Here's a subset of the One Dark theme suitable for Erlang:

```json
{
  "number": {
    "color": "#61afef",
    "bold": true
  },
  "string": "#98c379",
  "string.special.symbol": "#d19a66",
  "type": "#e06c75",
  "comment": {
    "color": "#5c6370",
    "italic": true
  },
  "comment.documentation": {
    "color": "#7c8390",
    "italic": true
  },
  "punctuation": "#abb2bf",
  "punctuation.bracket": "#abb2bf",
  "operator": {
    "color": "#d19a66",
    "bold": true
  },
  "variable": "#e06c75",
  "function": "#61afef",
  "function.builtin": {
    "color": "#c678dd",
    "bold": true
  },
  "constant": "#61afef",
  "constant.builtin": {
    "color": "#d19a66",
    "bold": true
  },
  "keyword": "#c678dd",
  "keyword.directive": "#e06c75",
  "module": "#e5c07b",
  "property": "#e06c75"
}
```

With this setup you can test highlighting on files using the Tree-sitter CLI.

```sh
# Highlight a single file
npx tree-sitter highlight tmp/test.erl

# Highlight test files
npx tree-sitter highlight test/highlight/**/*.erl
```

## Erlang-specific highlighting

The highlights query provides semantic highlighting for Erlang constructs:

- **Atoms** - highlighted as `string.special.symbol`
- **Variables** - highlighted as `variable`, with `_` prefixed vars as `comment.discard`
- **Functions** - local calls as `function`, remote calls show `module` and `function`
- **Built-in functions** - guard-safe BIFs highlighted as `function.builtin`
- **Records** - record names as `type`, field names as `property`
- **Macros** - macro names highlighted as `constant` or `keyword.directive`
- **Type specs** - type names highlighted as `function` in spec context
- **Doc strings** - OTP 27+ doc attributes highlighted as `comment.documentation`
