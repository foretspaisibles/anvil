;;;; ${ANVIL_PACKAGE}-test.asd -- ${ANVIL_DESCRIPTION}

;;;; ${ANVIL_LICENSE_BLOB}

(asdf:defsystem #:${ANVIL_PACKAGE}-test
  :description "${ANVIL_DESCRIPTION}"
  :author "${ANVIL_AUTHOR}"
  :license "${ANVIL_LICENSE}"
  :components
  ((:module "testsuite"
    :components ((:file "${ANVIL_PACKAGE}-test"))))

  :perform (test-op (o c) (symbol-call :${ANVIL_PACKAGE}-test '#:run-all-tests)))

;;;; End of file `${ANVIL_PACKAGE}-test.asd'
