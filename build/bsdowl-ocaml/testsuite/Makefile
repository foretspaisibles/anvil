### Makefile -- Test suite for ${ANVIL_VENDORNAME}

# ${ANVIL_LICENSE_BLOB}

PROGRAM=		unit-testing

.sinclude "${SRCDIR}/Makefile.config"

SRCS+=			main.ml

OCAMLLFLAGS+=		-linkall

test: ${PROGRAM}
	${PROGRAM:tA}

install:
	${NOP}

.include "ocaml.prog.mk"

### End of file `Makefile'
