dnl Makefile.m4 -- Template for BSD Owl project Makefile
dnl
dnl Anvil (https://github.com/michipili/anvil)
dnl This file is part of Anvil
dnl
dnl Copyright © 2015 Michael Grünewald
dnl
dnl This file must be used under the terms of the CeCILL-B.
dnl This source file is licensed as described in the file COPYING, which
dnl you should have received as part of this distribution. The terms
dnl are also available at
dnl http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt
dnl
ANVIL_SETUP(`make')dnl
### Makefile -- Project ANVIL_PACKAGE

ANVIL_RCS_KEYWORDS()dnl
ANVIL_LICENSE_BLOB()dnl

PACKAGE=	ANVIL_PACKAGE
VERSION=	0.1.0-current
OFFICER=	ANVIL_OFFICER

.include "generic.project.mk"

### End of file ``Makefile''
