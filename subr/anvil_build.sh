### anvil_build.sh -- Anvil build system

# Author: Michael Grünewald
# Date: Mon Feb  9 18:19:01 CET 2015

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


# build_database
#  Print the build database on STDOUT
#
# It has the following columns:
#
#     NAME|PATH|DESCRIPTION

build_database()
{
    cat <<EOF
bsdowl-autoconf|${builddir}/bsdowl-autoconf|BSD Owl with GNU autoconf support
EOF
}


# build_path BUILD
#  Extract the path where the file for BUILD is stored

build_path()
{
    build_database | awk -F '|' -v build="$1" '
$1 == build {print($2)}
'
}


# build_job BUILD
#  Read the database entry for BUILD and print the corresponding joblist
#
# It has the following columns:
#
#  NAME|PATH|FILTERS

build_job()
{
    local build_repo

    build_repo=$(build_path "$1")
    find "${build_repo}" -type f | awk -v OFS='|' '
{
  filters = "";
  name=$1;
  gsub(".*/", "", name);
  if(gsub("\\.m4$", "", name)) {
    filters = filters " m4";
  }
  gsub("^dot.", ".", name);
  gsub("^ ", "", filters);
  print(name, $1, filters);
}
'
}


# build_process
#  Read a job on STDIN and process it

build_process()
{
    local name path filters
    local actual_filter

    while IFS='|' read name path filters; do
        case ${filters} in
            '')	actual_filter=cat;;
            m4)	actual_filter=$(printf 'filter_m4 "%s" ""' "${name}" '');;
        esac
        if [ -e "${name}" ]; then
            1>&2 echo "Info: Skipping ${name}"
        else
            ${actual_filter} < "${path}" > "${name}"
        fi
    done
}

### End of file `anvil_build.sh'
