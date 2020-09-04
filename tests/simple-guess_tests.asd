(asdf:defsystem #:simple-guess_tests

  :author "Jean-Philippe Paradis <hexstream@hexstreamsoft.com>"

  :license "Unlicense"

  :description "simple-guess unit tests."

  :depends-on ("simple-guess"
               "parachute"
               "fakenil")

  :serial cl:t
  :components ((:file "tests"))

  :perform (asdf:test-op (op c) (uiop:symbol-call '#:parachute '#:test '#:simple-guess_tests)))
