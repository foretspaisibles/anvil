dnl autoconf.ac.m4 -- Template for autoconf scripts
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
ANVIL_SETUP(`shell')dnl
### configure.ac -- Autoconf

ANVIL_RCS_KEYWORDS()dnl
ANVIL_LICENSE_BLOB()dnl

AC_INIT([ANVIL_AUTOCONF_INIT])
AC_CONFIG_FILES([Makefile.config])
AC_OUTPUT

### End of file ``configure.ac''
