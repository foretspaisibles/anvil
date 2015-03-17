#!/bin/sh

### anvil_encoding.sh -- Filter all git branches to convert text to utf-8

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


# encoding_select
#  Select files to process
#
# It is a filter woring on the type of data streams produced by
# `filterbranch_query`.

encoding_select()
{
    awk -F'|' '
$3 ~ "utf-8"		{ next }
$3 ~ "binary"		{ next }
$3 ~ "unknown-8bit"	{ next }
$3 ~ "us-ascii"		{ next }
$2 ~ "^text/"		{ print }
'
}


# encoding_convert
#  Convert files
#
# It processes the job specification produced by `encoding_select`.

encoding_convert()
{
    local file
    local mime
    local encoding
    local saved_ifs
    saved_ifs="$IFS"

    IFS='|'
    while read file mime encoding; do
        mv "$file" "$file.iconv.$$" \
            && iconv -f "$encoding" -t "utf-8" < "$file.iconv.$$" > "$file" \
            && rm "$file.iconv.$$"
    done
    IFS="$saved_ifs"
}


# encoding_main
#  Converting encoding of files found in the given directories

encoding_main()
{
    filterbranch_query "." | encoding_select | encoding_convert
}

### ANCILLARY FUNCTIONS

encoding_usage()
{
    iconv -c -f utf-8 <<EOF
Usage: ${PROGNAME}
  Filter all git branches with iconv and convert text to utf-8
Options:
 -h Help
Copyright:
 ${COPYRIGHT} ${AUTHOR}
EOF
}


### PROCESSING OF COMMAND LINE ARGUMENTS

while getopts "h" OPTION; do
    case $OPTION in
        h)	encoding_usage; exit 0;;
        ?)	encoding_usage; exit 64;;
    esac
done

shift $(expr $OPTIND - 1)

filterbranch_main encoding_main

### End of file `anvil_encoding.sh'
