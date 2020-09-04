(in-package #:simple-guess)

(defclass simple-guess:manager () ())
(defclass simple-guess:advisor () ())

(defgeneric inquire (manager advisor &rest query &key &allow-other-keys))
