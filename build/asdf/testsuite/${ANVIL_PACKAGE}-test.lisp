;;;; ${ANVIL_PACKAGE}-test.lisp -- Run tests for ${ANVIL_VENDORNAME}

;;;; ${ANVIL_LICENSE_BLOB}

(defpackage #:${ANVIL_PACKAGE}-test
  (:use #:cl #:stefil #:${ANVIL_PACKAGE})
  (:export #:run-all-tests))

(in-package #:${ANVIL_PACKAGE}-test)



;;;
;;; Run all tests
;;;

(defsuite suite-${ANVIL_PACKAGE} ())

(defun run-all-tests ()
  (let ((test-run (suite-${ANVIL_PACKAGE})))
    (values (zerop (length (stefil::failure-descriptions-of test-run)))
            test-run)))

;;;; End of file `${ANVIL_PACKAGE}-test.lisp'
