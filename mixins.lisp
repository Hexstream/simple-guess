(in-package #:simple-guess)

(defclass simple-guess:advisor-mixin ()
  ((%advisors :initarg :advisor
              :reader simple-guess:advisor
              :type simple-guess:advisor
              :initform (error "~S is required." :advisor))))

(defclass simple-guess:advisors-mixin ()
  ((%advisors :initarg :advisors
              :reader simple-guess:advisors
              :type list
              :initform (error "~S is required." :advisors))))
