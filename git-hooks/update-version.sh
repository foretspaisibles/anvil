#!/bin/sh

### update-version.sh -- Update the version number in a repository

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

AUTHOR="Michael Grünewald"
COPYRIGHT="Copyright © 2015"
PROGNAME="$0"

: ${anvildir:=@datarootdir@/@PACKAGE@}
. "${anvildir}/subr/anvil_pervasives.sh"

### DESCRIPTION

# This update-version hook change the version number in a repository
# and commit the change.

action_usage()
{
    format <<EOF
Usage: update-version VERSION COMMITMESG
 Update the version number in a repository
EOF
}

action_update()
{
    local version commitmesg program opamfile

    version="$1"
    commitmesg="$2"
    program=$(printf '/^VERSION/s/\\(VERSION=[[:space:]]*\\).*/\\1%s/' "${version}")

    if [ -w 'Makefile' ]; then
        sed -i '' -e "${program}" 'Makefile'
        git add 'Makefile'
    else
        return 1
    fi

    program=$(printf '/^version/s/:.*/: "%s"/' "${version}")
    for opamfile in 'opam/opam' 'opam'; do
        if [ -f "${opamfile}" ] && [ -w "${opamfile}" ]; then
            sed -i '' -e "${program}" "${opamfile}";
            git add "${opamfile}"
        fi
    done

    git commit -m "${commitmesg}"
}

if ! [ $# -eq 2 ]; then
    action_usage
else
    action_update "$@"
fi

### End of file `update-version.sh'
