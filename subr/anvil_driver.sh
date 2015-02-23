### anvil_driver.sh -- Anvil driver

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

: ${anvildir:?}
: ${subrdir:=${anvildir}/subr}
: ${builddir:=${anvildir}/build}
: ${licensedir:=${anvildir}/license}
: ${templatedir:=${anvildir}/template}

. "${subrdir}/anvil_autoconf.sh"
. "${subrdir}/anvil_configuration.sh"
. "${subrdir}/anvil_filter.sh"
. "${subrdir}/anvil_build.sh"
. "${subrdir}/anvil_license.sh"
. "${subrdir}/anvil_template.sh"

### End of file `anvil_driver.sh'
