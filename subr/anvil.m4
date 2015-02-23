dnl anvil.m4 -- M4 macros for Anvil
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
define(`ANVIL_QUOTE', ```$1''')dnl
define(`ANVIL_QUOTE_FILENAME', `ANVIL_QUOTE(defn(`ANVIL_FILENAME'))')dnl
define(`ANVIL_RCS_KEYWORDS', `')dnl
define(`ANVIL_LICENSE_BLOB', `')dnl
define(`ANVIL_SETUP', `dnl
ANVIL_SETUP__$1()dnl
ANVIL_HANDLER_CONNECT(`$1')dnl
')dnl
define(`ANVIL_HANDLER_CONNECT', `dnl
define(`ANVIL_RCS_KEYWORDS', defn(`ANVIL_RCS_KEYWORDS__$1')``'')dnl
define(`ANVIL_LICENSE_BLOB', defn(`ANVIL_LICENSE_BLOB__$1')``'')dnl
')dnl
define(`ANVIL_SHELL_STYLE_QUOTE', `dnl
ifelse(`$2', `', `', `
patsubst(`$2', `^', `$1 ')
')dnl
')dnl
dnl
dnl Make support
dnl
define(`ANVIL_SETUP__make', `dnl
changecom(`%')dnl
')dnl
define(`ANVIL_LICENSE_BLOB__make',
 `ANVIL_SHELL_STYLE_QUOTE(`#', defn(`ANVIL_RAW_LICENSE_BLOB'))')dnl
dnl
dnl Shell support
dnl
define(`ANVIL_SETUP__shell', `dnl
changecom(`%')dnl
')dnl
define(`ANVIL_LICENSE_BLOB__shell',
 `ANVIL_SHELL_STYLE_QUOTE(`#', defn(`ANVIL_RAW_LICENSE_BLOB'))')dnl
dnl
dnl End of file `anvil.m4'
