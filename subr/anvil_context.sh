### anvil_context.sh -- Utilitites for working with Docker contexts

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


# context_pp [-o DST][-t TARBALL] INPUT
#  Preprocessor for dockerfiles
#
# It defines two macros DOCKER_TIMESTAMP and DOCKER_TARBALL which
# can be used in the m4 source.

context_pp()
{
    local OPTIND OPTION OPTARG
    local output tarball

    output='/dev/stdout'
    tarball='/dev/null'
    OPTIND=1

    while getopts "o:t:" OPTION; do
        case ${OPTION} in
            o)	output="${OPTARG}/Dockerfile";;
            t)	tarball="${OPTARG}";;
            *)	failwith "context_pp: ${OPTION}: Unsupported option.";;
        esac
    done
    shift $(expr ${OPTIND} - 1)

    m4\
        -D DOCKER_TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%SZ')\
        -D DOCKER_TARBALL="${tarball}"\
        "$1" >"${output}"
}


# context_tarball -o DST SRC1 SRC2 …
#  Prepare a context tarball containing SRC1, SRC2, etc.
#
# It writes the name of the generated file on stdout.  The file is
# created with all its timestamps set to the EPOCH, to live in harmony
# with the docker cache.

context_tarball()
{
    local tmpfile output tree
    local sha name
    local OPTIND OPTION OPTARG

    output="${tmpdir:-/tmp}"
    tmpfile=$(mktemp -t "${PACKAGE}-XXXXXX")
    OPTIND=1

    while getopts "o:" OPTION; do
        case ${OPTION} in
            o)	output="${OPTARG}";;
            *)	failwith "copytree: ${OPTION}: Unsupported option.";;
        esac
    done
    shift $(expr ${OPTIND} - 1)

    for tree in "$@"; do
        tar rfC "${tmpfile}" "${tree}" .
    done

    tar cJf "${output}/docker-context.txz" "@${tmpfile}"
    rm -f "${tmpfile}"
    sha=$(openssl sha1 "${output}/docker-context.txz" | cut -d ' ' -f 2)
    name=$(printf 'docker-context-%s.txz' "${sha}")
    mv "${output}/docker-context.txz" "${output}/${name}"
    printf '%s' "${name}"
}


# context_populate [–o DST] DIR1 DIR2 …
#  Populate the docker context with scripts found in DIR1 DIR2 …

context_populate()
{
    local OPTIND OPTION OPTARG
    local output dir

    output='/tmp'
    OPTIND=1

    while getopts "o:t:" OPTION; do
        case ${OPTION} in
            o)	output="${OPTARG}";;
            *)	failwith "context_populate: ${OPTION}: Unsupported option.";;
        esac
    done
    shift $(expr ${OPTIND} - 1)

    for dir in "$@"; do
        if [ -x "${dir}/populate" ]; then
            "${dir}/populate" "${output}"
        fi
    done
}
