### anvil_template.sh -- Anvil template insantiation

# Author: Michael Grünewald
# Date: Mon Feb  9 09:22:20 CET 2015

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


# anvil_template_create TEMPLATE FILENAME DESCRIPTION FILEPATH
#  Create the instantiation of the given template in FILEPATH

anvil_template_create()
{
    if [ $# != 4 ]; then
        failwith "create: Wrong number of arguments"
    else
        template_create "$@"
    fi
}


# anvil_template_help
#  Print the help screen

anvil_template_help()
{
    iconv -f utf8 <<EOF
Usage: ${PROGNAME} [options] arguments
 Instantiate file templates
Options:
 -c Set the action to create (default)
 -h Print this help screen
 -l Set the action to list
 -p Set the action to print
EOF
}



# anvil_template_describe
#  Print the template database

anvil_template_describe()
{
    template_describe
}


# anvil_template_print TEMPLATE FILENAME DESCRIPTION
#  Print the instantiation of the given template on stdout

anvil_template_print()
{
    if [ $# != 3 ]; then
        failwith "print: Wrong number of arguments"
    else
        template_print "$@"
    fi
}


#
# Processing command line arguments
#

anvil_template_action='help'

while getopts "chlp" OPTION; do
    case $OPTION in
        c)	anvil_template_action='create';;
        h)	anvil_template_help; exit 0;;
        l)	anvil_template_action='describe';;
        p)	anvil_template_action='print';;
        ?)	anvil_template_help; exit 64;;
    esac
done

shift $(expr ${OPTIND} - 1)

anvil_template_${anvil_template_action} "$@"

### End of file `anvil_template.sh'
