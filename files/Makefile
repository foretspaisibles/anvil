### Makefile -- Anvil files database

# Anvil (https://github.com/michipili/anvil)
# This file is part of Anvil
#
# Copyright © 2015 Michael Grünewald
#
# This file must be used under the terms of the CeCILL-B.
# This source file is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at
# http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt

TREE=			build
TREE+=			template
TREE+=			license

.for tree in ${TREE}
install-${tree}:
	(cd ${SRCDIR}/${tree} && ${COPYTREE_SHARE} . ${DESTDIR}${SHAREDIR}/${tree})

install: install-${tree}
.endfor

.include "generic.files.mk"

### End of file `Makefile'
