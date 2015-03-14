### git-releng.sh -- Release engineering

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
. "${anvildir}/subr/anvil_pervasives.sh"
. "${anvildir}/subr/anvil_configuration.sh"
. "${anvildir}/subr/anvil_git.sh"

git_update_version='.git/hooks/update-version'

if [ ! -x "${git_update_version}" ]; then
    failwith '%s: Cannot execute hook.' "${git_update_version}"
fi

# releng_db
#  Path to our releng database

releng_db()
{
    local anvildir

    anvildir="$(git_anvildir)"
    echo "${anvildir}/releng"
}


# releng_assert_releng_branch HINT
#  Die with HINT if we are not a releng branch

releng_assert_releng_branch()
{
    case "$(git_current_branch)" in
        releng/*);;
        *)	failwith "%s: %s: Not a release-cycle branch."\
                         "$1" "${current_branch}";;
    esac
}

# releng_start NEXT
#  Start release engineering for NEXT

releng_start()
{
    local next
    local version
    local commitmesg

    next="$1"
    version="${next}-releng"
    commitmesg="Start the ${next} release cycle"

    git checkout master\
        || failwith "master: Cannot checkout branch."

    git checkout -b "releng/${next}"\
        || failwith "%s: Cannot create branch." "releng/${next}"

    "${git_update_version}" "${version}" "${commitmesg}"\
        || failwith "Cannot update version."
}


# releng_release_candidate
#  Rollout release candidate
#
# It must be issued on a releng branch.

releng_release_candidate__rc()
{
    git tag | awk -v nextversion="$1" '
$0 ~ nextversion {rc+=1}
END {print(rc+1)}
'
}

releng_release_candidate()
{
    local rc current_branch next commitmesg

    current_branch="$(git_current_branch)"
    next="${current_branch#releng/}"

    releng_assert_releng_branch 'release candidate'

    rc=$(releng_release_candidate__rc "${next}")
    commitmesg="$(configuration_vendorname) ${next}-rc${rc}"

    "${git_update_version}" "${next}-rc${rc}" "${commitmesg}"\
        || failwith "Cannot update version."

    git tag -s -m "v${next}-rc${rc}" "v${next}-rc${rc}"
}


# releng_final
#  Produce the final release
#
# It must be issued on a releng branch.

releng_final()
{
    local releng_branch next commitmesg

    releng_branch="$(git_current_branch)"
    next="${releng_branch#releng/}"
    commitmesg="$(configuration_vendorname) ${next}"

    releng_assert_releng_branch 'final'

    git_maybe_runhook pre-release\
        || "pre-release"

    git checkout 'release'\
        || failwith "release: Cannot checkout branch."

    git merge --no-commit -Xtheirs "${releng_branch}"\
        || failwith "merge: Cannot merge ${releng_branch} into release."

    "${git_update_version}" "${next}" "${commitmesg}"\
        || failwith "Cannot update version."

    git tag -s -m "v${next}" "v${next}"

    git_maybe_runhook post-release\
        || "post-release"
}


releng_usage()
{
    format <<EOF
Usage: git releng […]
 Release engineering
Options:
 -s NEXT
    Start release engineering for NEXT
 -r RC
    Rollout release candidate RC
 -f Rollout final release
EOF
}

releng_action='usage'

while getopts 'srf' OPTION; do
    case ${OPTION} in
        s)	releng_action='start';;
        r)	releng_action='release_candidate';;
        f)	releng_action='final';;
        ?)	releng_usage; exit 64;;
    esac
done

shift $(expr ${OPTIND} - 1)

releng_${releng_action} "$@"

### End of file `git-releng.sh'
