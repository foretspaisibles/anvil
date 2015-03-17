#!/bin/sh

### anvil_sed.sh -- Filter all git branches with a sed script

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


# sed_select MIME
#  Select files to process
#
# It is a filter woring on the type of data streams produced by
# `anvil_query`.  The filter matches files of type 'text/MIME' where
#  MIME is a regular expression.
#
# The paths of the matched files is printed on the command line,
# instead of a full record.

sed_select()
{
    awk -F'|' -v pattern="^text/$1" '
$2 ~ pattern		{ print($1) }
'
}

# sed_rename SEDSCRIPT
#  Rename files according to the plan issued by the SEDCRIPT
#
# The SEDSCRIPT reads actual file names, one on each line, and writes
# the rename plan as
#
#   ACTUALNAME|NEWNAME
#
# on standard input.
#
# A typical sed script for this is:
#
#   sed -e '
#     h
#     s@/www\..*\.com - *@/@
#     s@/\[^]]* - *@/@
#     H
#     x
#     s/\n/|/
#   '

sed_rename()
{
    local oldname newname
    if [ -z "$1" ]; then return 0; fi
    sed -f "$1" | while IFS='|' read oldname newname; do
        mv -n "$oldname" "$newname"
    done
}

# sed_convert SEDSCRIPT
#  Process files
#
# It processes the job specification produced by `sed_select`.

sed_convert()
{
    xargs sed -i '' -f "$1"
}


# sed_main
#  Processing of files found in the given directories

sed_main()
{
    filterbranch_query "." \
        | sed_select "$ANVILSEDPATTERN" \
        | sed_rename "$ANVILRENAME"
    filterbranch_query "." \
        | sed_select "$ANVILSEDPATTERN" \
        | sed_convert "$ANVILSEDSCRIPT"
}


### ANCILLARY FUNCTIONS

sed_usage()
{
    iconv -c -f utf-8 <<EOF
Usage: ${PROGNAME} [-m mime-pattern] script
  Filter all git branches with a sed script
Description:
 Use the given sed script to tree-filter branches.  The path to the
 sed script must be an aboslute path.
Options:
 -h Help
 -m mime-pattern
    Restrict the set of files processed to those matching the
    given 'text/mime-pattern'.
 -r rename
    Use the sed script rename to rename files before editing them.
Copyright:
 ${COPYRIGHT} ${AUTHOR}
EOF
}


### PROCESSING OF COMMAND LINE ARGUMENTS

if [ "${ANVILMODE:-master}" = "master" ]; then

    ANVILSEDPATTERN=""
    ANVILRENAME=""

    while getopts "hm:r:" OPTION; do
        case $OPTION in
            m)	ANVILSEDPATTERN="$OPTARG";;
            r)	ANVILRENAME="$OPTARG";;
            h)	sed_usage; exit 0;;
            ?)	sed_usage; exit 64;;
        esac
    done

    shift $(expr $OPTIND - 1)

    if [ $# -lt 1 ]; then
        sed_usage; exit 64
    else
        ANVILSEDSCRIPT="$1"
        export ANVILSEDSCRIPT
        export ANVILSEDPATTERN
    fi
fi

filterbranch_main sed_main

### End of file `anvil_sed.sh'
