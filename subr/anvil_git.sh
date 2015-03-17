### anvil_git.sh -- Anvil git-related subroutines system

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


# git_current_branch
#  Determine the current git branch

git_current_branch()
{
    git rev-parse --abbrev-ref HEAD
}


# git_topleveldir
#  Path to the toplevel of our repository

git_topleveldir()
{
    git rev-parse --show-toplevel
}


# git_anvildir
#  Path to our private repository

git_anvildir()
{
    local topleveldir anvildir

    topleveldir=$(git_topleveldir)
    anvildir="${topleveldir}/.git/anvil"
    if ! [ -d "${anvildir}" ]; then
        mkdir "${anvildir}"
    fi
    echo "${anvildir}"
}


# git_maybe_runhook HOOK ARGS
#  Maybe run the given hook

git_maybe_runhook()
{
    local topleveldir hook

    topleveldir=$(git_topleveldir)
    hook="${topleveldir}/.git/hooks/$1"
    shift

    if [ -x "${hook}" ]; then
        "${hook}" "$@"
    fi
}

### End of file `anvil_git.sh'
