#!/bin/sh

### anvil_maintainer.sh -- Docker image tool for maintainers

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

: ${packagedir:=/@PACKAGE@}
: ${localstatedir:=@localstatedir@}
: ${sysconfdir:=@sysconfdir@}
: ${anvildir:=@datarootdir@/@PACKAGE@}
: ${maintainerdir:=${anvildir}/maintainer}

. "${anvildir}/subr/anvil_pervasives.sh"
. "${anvildir}/subr/anvil_context.sh"

maintainer_maketag()
{
    awk -F ' *= *' '
{ a[$1] = $2 }
END {
  printf("%s/%s", a["repository"], a["image"])
}' < "$1"/maintainer.conf
}



### ANCILLARY FUNCTIONS


maintainer_action_usage()
{
    maintainer__print_help
    exit 64
}


maintainer_action_help()
{
    maintainer__print_help
    exit 0
}


maintainer__print_help()
{
    iconv -c -f utf-8 <<EOF
Usage: ${PROGNAME} [-bls] [-C CONFIGFILE] [-I IMGDIR] [-p PKGDIR][-c CONFDIR] [-i IMAGE] [SRCDIR]
  Environment for package maintainers
Options:
 -b Build the docker IMAGE
 -c CONFDIR
 -l List available IMAGES
 -p PKGDIR
 -s Drop to a shell in the given IMAGE
 -C CONFFILE
 -I IMGDIR
Copyright:
 ${COPYRIGHT} ${AUTHOR}
EOF
}


maintainer_action_shell()
{
    docker run\
        --interactive=true\
        --tty=true\
        --rm=true\
        --volume "${maintainer_pkgdir}:${maintainer_docker_pkgdir}"\
        --volume "${maintainer_srcdir}:${maintainer_docker_srcdir}"\
        --volume "${maintainer_confdir}:${maintainer_docker_confdir}"\
        "${maintainer_repository}/${maintainer_image}"
}


maintainer_action_list()
{
    find "${maintainerdir}"\
      -name 'Library' -prune -o\
      -maxdepth 1\
      -mindepth 1\
      -type d\
      -exec basename '{}' ';'
}

maintainer_action_build()
{
    local tag tarball

    tag=$(maintainer_maketag "${maintainer_imagedir}")
    tmpdir_initializer
    find "${maintainerdir}/Library" "${maintainer_imagedir}"\
         \( -name '*.conf' -o -name '*.asc' -o -name '*.subr' -o -name '*.sh' \)\
         -exec cp -a '{}' "${tmpdir}" ';'
    context_populate -o "${tmpdir}"
    tarball=$(\
        context_tarball -o "${tmpdir}"\
            "${maintainerdir}/library"\
            "${maintainer_imagedir}"\
            "${tmpdir}"\
           )
    context_pp\
        -o "${tmpdir}"\
        -t "${tarball}"\
        "${maintainer_imagedir}/Dockerfile.m4"
    docker build -t "${tag}" "${tmpdir}"
}


### PROCESSING OF COMMAND LINE ARGUMENTS

: ${maintainer_repository:=@PACKAGE@}
maintainer_action='shell'
maintainer_config="${HOME}/.config/anvil/maintainer.conf"
maintainer_image='ubuntu-precise'
maintainer_imagedir=''

maintainer_docker_pkgdir="/opt/local/var${packagedir}/pkg"
maintainer_docker_confdir="/opt/local/var${packagedir}/conf"
maintainer_docker_srcdir="/opt/local/var${packagedir}/src"

while getopts "bc:hi:lsp:C:I:" OPTION; do
    case ${OPTION} in
        b)	maintainer_action='build';;
        c)	maintainer_confdir="${OPTARG}";;
        h)	maintainer_action='help';;
        i)	maintainer_image="${OPTARG}";;
        l)	maintainer_action='list';;
        p)	maintainer_pkgdir="${OPTARG}";;
        s)	maintainer_action='shell';;
        C)	maintainer_config="${OPTARG}";;
        I)	maintainer_imagedir="${OPTARG}";;
        *)	maintainer_action='usage';;
    esac
done
shift $(expr $OPTIND - 1)

if [ -r "${maintainer_config}" ]; then
    . "${maintainer_config}"
fi
: ${maintainer_confdir=${localstatedir}${packagedir}/conf}
: ${maintainer_pkgdir=${localstatedir}${packagedir}/pkg}
: ${maintainer_srcdir=${localstatedir}${packagedir}/src}
: ${maintainer_imagedir:=${maintainerdir}/${maintainer_image}}

maintainer_action_${maintainer_action} "$@"

### End of file `anvil_maintainer.sh'
