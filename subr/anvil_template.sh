### anvil_template.sh -- Template database

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

# template_database
#  Print the template database on STDOUT
#
# It has the following columns:
#
#     NAME|FILENAME|DESCRIPTION

template_database()
{
    cat <<EOF
Makefile|${templatedir}/Makefile.m4|Makefile
shell|${templatedir}/shell.m4|Shell script or library
shell_autoconf|${templatedir}/shell_autoconf.m4|Autoconf shell configuration
EOF
}


# template_path TEMPLATE
#  Extract the path where the file for TEMPLATE is stored

template_path()
{
    template_database | awk -F '|' -v template="$1" '
$1 == template {print($2)}
'
}


# template_print TEMPLATE FILENAME DESCRIPTION
#  Print TEMPLATE on stdout

template_print()
{
    local template_file
    template_file="$(template_path "$1")"

    filter_m4 "$2" "$3" < "${template_file}"
}


# template_year
#  Print the current year on stdout

template_year()
{
    date +%Y
}


# template_timestamp
#  Print the current timestamp on stdout

template_timestamp()
{
    env LANG=C date
}


# template_create TEMPLATE FILENAME DESCRIPTION DEST
#  Create DEST according to other parameters
#
# If the file already exists, it is not created.

template_create()
{
    if [ -e "$4" ]; then
        wlog "template: create: $4: File already exists."
    else
        template_print "$1" "$2" "$3" > "$4"
    fi
}

# template_describe
#  Print the template names with their descriptions on stdout

template_describe()
{
    local name desc

    template_database | while IFS='|' read name _ desc; do
      printf '%16s -- %s\n' "${name}" "${desc}"
    done
}

### End of file `anvil_template.sh'
