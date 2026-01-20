# tree-sitter-erl

Erlang grammar for [tree-sitter](https://github.com/tree-sitter/tree-sitter).


This is a fork of [whatsapp/tree-sitter-erlang](https://github.com/WhatsApp/tree-sitter-erlang/commit/f21023bbd6cd30cadbc793d80ae4d990d9be86fc), which is in turn a fork of [AbstractMachinesLab/tree-sitter-erlang](https://github.com/AbstractMachinesLab/tree-sitter-erlang/commit/7b436e1ca50f0002f6765a9a2a00f6156b2cc881).

The main focus of this version is expanded [queries](./queries), broader test coverage and usable Go, Python & Node language bindings.

## Usage

Install the required toolchain with

```
make deps
```

Edit the `grammar.js` file and re-generate the code with:

```
make gen
```

## Tests & Validation

There is expanded test coverage, inspired by the [Elixir grammar](https://github.com/elixir-lang/tree-sitter-elixir/).
```
make test
```

## License

**tree-sitter-erl** is [Apache licensed](./LICENSE).
