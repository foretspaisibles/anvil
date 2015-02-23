### anvil_configuration.sh -- Configuration database

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


#
# Configuration wizard
#


# configuration_wizard
#  Interactively setup configuration of a project

configuration_wizard()
{
    local var gitkey description

    exec 3<&0
    configuration_wizard__database | while IFS='|' read gitkey description; do
      printf '%s: ' "${description}"
      0<&3 read var
      git config "${gitkey}" "${var}"
    done
    exec 3<&-
}


configuration_wizard__database()
{
    cat <<'EOF'
anvil.package|Package name
anvil.author|Author
anvil.officer|Release officer
anvil.url|Package URL
anvil.license|License
EOF
}


# configuration_license_blob
#  Print the raw license blob for our license on stdout

configuration_license_blob()
{
    license_blob "$(configuration_license)"
}


# configuration_license
#  Print the license name on stdout

configuration_license()
{
    git config anvil.license
}


# configuration_url
#  Print the project URL on stdout

configuration_url()
{
    git config anvil.url
}


# configuration_package
#  Print the project NAME on stdout

configuration_package()
{
    git config anvil.package
}


# configuration_author
#  Print the project author on stdout

configuration_author()
{
    git config anvil.author
}


# configuration_officer
#  Print the project officer on stdout

configuration_officer()
{
    git config anvil.officer
}


# configuration_build_system
#  Print the build system on stdout

configuration_build_system()
{
    echo 'bsdowl-autoconf'
}

### End of file `anvil_configuration.sh'
