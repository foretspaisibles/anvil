### anvil_filterbranch.sh -- Library for the git toolkit

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

# : ${datadir:?}
# . "${datadir}/anvil_filterbranch.sh"

# We implement symbolic directory names following the GNU coding
# standards.  Most of the comments are citations from the GNU coding
# standards:
#
#   The GNU coding standards, last updated September 13, 2013.
#   http://www.gnu.org/prep/standards/html_node/index.html


### IMPLEMENTATION

ANVILPROGNAME="$0"

# filterbranch_query [DIR…]
#  Query files for operation
#
# This produces a listing of all files in the mentioned directories or
# in the current directory.  The listing has the format
#
#     FILENAME|MIME-TYPE|MIME-ENCODING
#
# as reported with the `file(1)` commmand.  It adequately avoids to
# descend in subdirectiories called git, svn or CVS.
#
# It also corrects some results, on the basis of the filename,
# according on the following matches:
#
#     "\\.c?sh$"            text/x-shellscript
#     "dot.cshrc"           text/x-shellscript
#     "dot.bashrc"          text/x-shellscript
#     "^Makefile"           text/x-makefile
#     "\\.mk$"              text/x-makefile
#     "COPYING"             text/plain
#     "README"              text/plain
#     "INSTALL"             text/plain
#     "INDEX"               text/plain
#     "TODO"                text/plain
#     "ChangeLog"           text/plain
#     "\\.ml\([ily]\)?$"    text/x-ocaml

filterbranch_query()
{
    find "$@" \
        -name '.svn' -prune -o\
        -name '.git' -prune -o\
        -name 'CVS' -prune -o\
        -name 'autom4te.cache' -prune -o\
        -type f -print \
        | xargs file -i \
        | sed -e 's/:[[:space:]]*/|/' -e 's/; charset=/|/' \
        | awk -F'|' -v OFS='|' '
				{ key = $1; sub("\\.in$", "", key) }
key ~ "\\.c?sh$"		{ $2 = "text/x-shellscript" }
key ~ "dot.cshrc"		{ $2 = "text/x-shellscript" }
key ~ "dot.bashrc"		{ $2 = "text/x-shellscript" }
key ~ "\(^\|/\)Makefile"	{ $2 = "text/x-makefile" }
key ~ "\\.mk$"			{ $2 = "text/x-makefile" }
key ~ "COPYING"			{ $2 = "text/plain" }
key ~ "README"			{ $2 = "text/plain" }
key ~ "INSTALL"			{ $2 = "text/plain" }
key ~ "INDEX"			{ $2 = "text/plain" }
key ~ "TODO"			{ $2 = "text/plain" }
key ~ "ChangeLog"		{ $2 = "text/plain" }
key ~ "\\.ml\([ily]\)?$"	{ $2 = "text/x-ocaml" }
				{ print }
'
}


# filterbranch_main SUBFUNCTION
#  Main function delegating work to SUBFUNCTION

filterbranch_main()
{
    local self
    case "$ANVILPROGNAME" in
        *.sh)	self="sh $ANVILPROGNAME";;
        *)	self="$ANVILPROGNAME";;
    esac

    if [ "${ANVILMODE:-master}" = "slave" ]; then
        "$1"
    else
        env ANVILMODE='slave' \
            git filter-branch \
            --tree-filter "$self" \
            --tag-name-filter cat \
            -- --all
    fi
}

### End of file `anvil_filterbranch.sh'
