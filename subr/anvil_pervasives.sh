### anvil_pervasives.sh -- Pervasives routines for Anvil

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

### SYNOPSIS

# : ${subrdir:?}
# . "${subrdir}/anvil_pervasives.sh"


# format
#  Format incoming UTF-8 on stdout

format()
{
    iconv -c -f utf-8
}


# eprintf PREFIX MESSAGE
#  Print on stderr with the given prefix and the program name

eprintf()
{
    local _prefix _format

    _prefix="$1"
    _format="$2"
    shift 2

    1>&2 printf "${_prefix}: ${PROGNAME}${PROGNAME:+: }${_format}\\n" "$@"
}


# failwith MESSAGE
#  Fail with the given message

failwith()
{
    eprintf 'Failure' "$@"
    exit 1
}

### End of file `anvil_pervasives.sh'
