; Doc attribute strings as markdown
(doc_attribute
  content: (string) @injection.content
  (#set! injection.language "markdown"))

(moduledoc_attribute
  content: (string) @injection.content
  (#set! injection.language "markdown"))

; Concatenated doc strings
(doc_attribute
  content: (concatables
    (string) @injection.content)
  (#set! injection.language "markdown"))

(moduledoc_attribute
  content: (concatables
    (string) @injection.content)
  (#set! injection.language "markdown"))
