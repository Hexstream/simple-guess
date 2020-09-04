(asdf:defsystem #:simple-guess

  :author "Jean-Philippe Paradis <hexstream@hexstreamsoft.com>"

  :license "Unlicense"

  :description "Defines a simple extensible protocol for computing a guess using advisors."

  :version "1.0"
  :serial cl:t
  :components ((:file "package")
               (:file "core")
               (:file "mixins")
               (:file "advisors")
               (:file "macros"))

  :in-order-to ((asdf:test-op (asdf:test-op #:simple-guess_tests))))
