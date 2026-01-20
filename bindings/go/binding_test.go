// @generated
package tree_sitter_erlang_test

import (
	"testing"

	tree_sitter_erlang "github.com/samgaw/tree-sitter-erl/bindings/go"
	tree_sitter "github.com/tree-sitter/go-tree-sitter"
)

func TestCanLoadGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_erlang.Language())
	if language == nil {
		t.Errorf("Error loading Erlang grammar")
	}
}
