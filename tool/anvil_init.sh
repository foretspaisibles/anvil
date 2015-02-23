### anvil_init.sh -- Init package

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

: ${anvildir:=@datarootdir@/@PACKAGE@}
. "${anvildir}/subr/anvil_driver.sh"


PROGNAME=$(basename "$0")

# failwith MESSAGE
#  Terminates the process with the given message
failwith()
{
    1>&2 echo "Failure: ${PROGNAME}:" "$@"
    exit 1
}


# anvil_init_help
#  Print the help screen

anvil_init_help()
{
    iconv -f utf8 <<EOF
Usage: ${PROGNAME} [options] directory
 Create new project
Options:
 -h Print this help screen
EOF
}


anvil_init_main()
{
    mkdir -p "$1"\
        && cd "$1"\
        && git init\
        && configuration_wizard\
        && (build_job "bsdowl-autoconf" | build_process)
}

anvil_init_main "$@"

### End of file `anvil_init.sh'
