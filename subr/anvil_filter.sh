### anvil_filter.sh -- Anvil filters

# Author: Michael Grünewald
# Date: Mon Feb  9 21:46:39 CET 2015

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


# filter_m4 FILENAME DESCRIPTION
#  Filter stdin through M4

filter_m4()
{
    m4 -I "${subrdir}"\
       -D ANVIL_FILENAME="$1"\
       -D ANVIL_DESCRIPTION="$2"\
       -D ANVIL_TIMESTAMP="$(template_timestamp)"\
       -D ANVIL_YEAR="$(template_year)"\
       -D ANVIL_RAW_LICENSE_BLOB="$(configuration_license_blob)"\
       -D ANVIL_AUTHOR="$(configuration_author)"\
       -D ANVIL_PACKAGE="$(configuration_package)"\
       -D ANVIL_URL="$(configuration_url)"\
       -D ANVIL_OFFICER="$(configuration_officer)"\
       anvil.m4 - \
        | sed -e 's/ *$//'
}

### End of file `anvil_filter.sh'
