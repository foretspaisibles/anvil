### anvil_license.sh -- License database

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


# license_database
#  Print the license database on STDOUT
#
# It has the following columns:
#
#     NAME|FILENAME|DESCRIPTION

license_database()
{
    cat <<EOF
CeCILL-B|${licensedir}/CeCILL-B|CeCILL-B free software license agreement
proprietary|${licensedir}/proprietary|Proprietart software
EOF
}


# license_path LICENSE
#  Extract the path where assets for LICENSE are stored

license_path()
{
    license_database | awk -F '|' -v license="$1" '
$1 == license {print($2)}
'
}

# license_blob NAME
#  Extract the license blob for the license of the given name

license_blob()
{
    local blob_path

    blob_path=$(license_path "$1")

    if [ -e "${blob_path}/blob.m4" ]; then
        cat "${blob_path}/blob.m4"
    else
        failwith "license: $1: License not found"
    fi
}


# license_package_init
#  Handle package initialisation

license_package_init()
{
    local license_name license_path

    license_name=$(package_license)
    license_path=$(license_path "${license_name}")

    cp "${license_path}/COPYING" "${packagedir:?}"
}

### End of file `anvil_license.sh'
