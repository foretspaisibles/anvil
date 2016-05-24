### Makefile -- Project ${ANVIL_VENDORNAME}

# ${ANVIL_LICENSE_BLOB}

PACKAGE=	${ANVIL_PACKAGE}
VERSION=	0.1.0-current
OFFICER=	${ANVIL_OFFICER}

.sinclude "Makefile.config"

MODULE=			ocaml.lib:lib
MODULE+=		ocaml.prog:src
MODULE+=		ocaml.meta:meta
MODULE+=		ocaml.manual:manual

SUBDIR=			testsuite

EXTERNAL=		ocaml.findlib:broken
EXTERNAL+=		ocaml.findlib:lemonade

.include "generic.project.mk"

### End of file ``Makefile''
