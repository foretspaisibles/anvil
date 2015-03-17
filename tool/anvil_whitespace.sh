#!/bin/sh

### anvil_whitespace.sh -- Filter all git branches for trailing whitespace

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


### IMPLEMENTATION

: ${anvildir:=@datarootdir@/@PACKAGE@}
. "${anvildir}/subr/anvil_driver.sh"


# whitespace_select MIME
#  Select files to process
#
# It is a filter woring on the type of data streams produced by
# `filterbranch_query`.  The filter matches files of type 'text/MIME' where
#  MIME is a regular expression.
#
# The paths of the matched files is printed on the command line,
# instead of a full record.

whitespace_select()
{
    awk -F'|' -v pattern="^text/$1" '
$2 ~ pattern		{ print($1) }
'
}


# whitespace_convert
#  Process files
#
# It processes the job specification produced by `whitespace_select`.

whitespace_convert()
{
    xargs sed -i '' -e '
s/\\ $/:a083f6496b7831e217cb5e06949da2e10ff39a85/
s/[[:blank:]]*$//
s/:a083f6496b7831e217cb5e06949da2e10ff39a85$/\\ /
s/^//
s/$//
'
}


# whitespace_main
#  Processing of files found in the given directories

whitespace_main()
{
    filterbranch_query "." \
        | whitespace_select "$ANVILWSPATTERN" \
        | whitespace_convert
}


### ANCILLARY FUNCTIONS

whitespace_usage()
{
    iconv -c -f utf-8 <<EOF
Usage: ${PROGNAME} [-m mime-pattern] script
  Filter all git branches for trailing whitespace
Description:
 After filtering, lines do not have trailing whitespaces and lines end
 with NL. Backslash escaped whitespace is however preserved.
Options:
 -h Help
 -m mime-pattern
    Restrict the set of files processed to those matching the
    given 'text/mime-pattern'.
Copyright:
 ${COPYRIGHT} ${AUTHOR}
EOF
}


### PROCESSING OF COMMAND LINE ARGUMENTS

if [ "${ANVILMODE:-master}" = "master" ]; then

    ANVILWSPATTERN=""

    while getopts "hm:" OPTION; do
        case $OPTION in
            m)	ANVILWSPATTERN="$OPTARG";;
            h)	whitespace_usage; exit 0;;
            ?)	whitespace_usage; exit 64;;
        esac
    done

    shift $(expr $OPTIND - 1)

    if [ $# -gt 0 ]; then
        whitespace_usage; exit 64
    else
        export ANVILWSPATTERN
    fi
fi

filterbranch_main whitespace_main

### End of file `anvil_whitespace.sh'
