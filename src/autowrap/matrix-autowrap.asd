(asdf:defsystem "matrix-autowrap"
    :version "0.0"
    :author "Gnuxie <Gnuxie@protonmail.com>"
    :license "AGPL v3+"
    :depends-on ("drakma")
    :components ((:file "authentication")
                 (:file "api-schema")
                 (:file "produce-spec")
                 (:file "core")
                 (:file "reading"))

    :description
    "A WIP REST api autowrapper. Can build a wrapper based on simple a schema")
