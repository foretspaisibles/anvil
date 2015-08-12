#!/bin/sh

### autoinstall -- Autoinstall dependencies for Travis CI

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

: ${prefix:=${HOME}/.local}
: ${srcdir:=${HOME}/.local/sources}
: ${autoinstall_bsdowl_version:=master}


autoinstall_bmake()
{
    install -d "${srcdir}"
    cd "${srcdir}"

    curl -s http://michipili.github.io/bsdowl/src/bmake-20150606.tar.gz\
        | tar xzfC - "${srcdir}"

    ./bmake/boot-strap --prefix="${prefix}" --install
    ./bmake/boot-strap --prefix="${prefix}" op=install
}

autoinstall_bsdowl()
{
    install -d "${srcdir}"
    cd "${srcdir}"

    git clone https://github.com/michipili/bsdowl
    cd bsdowl
    git checkout "${autoinstall_bsdowl_version}"
    autoconf
    ./configure --prefix="${prefix}"
    bmake build
    bmake install
}

autoinstall_opam__db()
{
        sed -n -e '
1 {
  x
  s/^/default/
  x
}

/^#/n

/:$/ {
  s/:$//
  x
  b
}

/^[a-z]*:.*/{
  s/: */|/
  p
  s/|.*//
  x
  b
}

/^[[:space:]][[:space:]]-/ {
  s/^[[:space:]]*-[[:space:]]*//
  G
  s/\(.*\)\n\(.*\)/\2|\1/
  p
}' ./.travis.opam
}

autoinstall_opam__newest()
{
    opam switch list | awk '/^#/{next} $3 != "system" {a=$3} END{print a}'
}

autoinstall_opam__compiler()
{
    local newest

    newest=$(autoinstall_opam__newest)
    autoinstall_opam__db | awk -F '|' -v "newest=${newest}" '
$1 == "compiler" {
  v=1;
  print($2);
}

END{
  if(v==0){
    print newest;
  }
}'
}

autoinstall_opam__package()
{
    autoinstall_opam__db | awk -F '|' '$1 != "compiler" {print}'
}

autoinstall_opam()
{
    local compiler method package url

    set -a
    OPAMYES=1
    OPAMVERBOSE=1
    set +a

    opam init

    for compiler in $(autoinstall_opam__compiler); do
        opam switch ${compiler}
        eval $(opam config env)
        autoinstall_opam__package | (
            while IFS='|' read method package url; do
                autoinstall_opam__${method} "${package}"
            done
        )
    done
}

autoinstall_opam__repository()
{
    opam install "$1"
}

autoinstall_opam__git()
{
    local package url

    url="$1"
    package="${1##*/}"
    package="${package%.git}"

    set -a
    OPAMYES=1
    OPAMVERBOSE=1
    set +a

    (cd "${srcdir}" && git clone "${url}" "${package}")\
        && (cd "${srcdir}/${package}"\
                   && ( autoconf || true )\
                   && opam pin add "${package}" .)
}

autoinstall_usage()
{
    iconv -c -f utf-8 <<EOF
Usage: autoinstall [-h][-s SRCDIR] [-p PREFIX] bsdowl bmake
 Install dependencies
Options:
 -h Display this help message.
 -p PREFIX [${prefix}]
    Use PREFIX as installation prefix.
 -s SRCDIR [${srcdir}]
    Download sources to SRCDIR.
EOF
}

while getopts "hs:p:" OPTION; do
    case "${OPTION}" in
        h)	autoinstall_usage; exit 0;;
        s)	srcdir="${OPTARG}";;
        p)	prefix="${OPTARG}";;
        ?)	autoinstall_usage; exit 64;;
    esac
done
shift $(expr $OPTIND - 1)
for package in "$@"; do
    case "${package}" in
        bmake|bsdowl|opam);;
        *) autoinstall_usage; exit 64;;
    esac
done
for package in "$@"; do
    ( autoinstall_${package} )
done

### End of file `autoinstall'
