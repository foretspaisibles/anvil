#!/bin/sh

### pre-commit.sh -- Verify what is about to be commited

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


### DESCRIPTION

# This pre-commit hook implements several policies, which may be
# controlled by some git config variables as described in the
# sequel.


# policy_nonascii
#
#   hooks.allownonascii (false)
#
#   Cross platform projects tend to avoid non-ascii filenames; we
#   prevent them from being added to the repository unless the
#   variable hooks.allownonascii is set to true.


# policy_mandatory_file_format
#
#   hooks.allowsloppyformat (false)
#
#   The mandatory file format policy verifies the adhesion of
#   committed files to some file format specifications:
#
#    - No trailing white space
#    - End of line is NL
#    - File is UTF-8 encoded
#
#  The mandatory file format policy is a security net that will catch
#  faulty commits, containing poorly formatted information or noise.


# policy_scm_keywords
#
#   hooks.allowscmkeywords (false)
#
#   The SCM keywords policy verifies that checked-in files do not
#   contain any of the following SCM keywords:
#
#    - Id
#    - CVS
#
#
#  The mandatory file format policy is a security net that will catch
#  faulty commits, containing poorly formatted information or noise.


### IMPLEMENTATION

if git rev-parse --verify HEAD >/dev/null 2>&1
then
    against=HEAD
else
    # Initial commit: diff against an empty tree object
    against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

# Redirect output to stderr.
exec 1>&2


## policy_nonascii

# Cross platform projects tend to avoid non-ascii filenames; prevent
# them from being added to the repository.  We exploit the fact that
# the printable range starts at the space character and ends with
# tilde.

allownonascii=$(git config hooks.allownonascii)

if [ "$allownonascii" != "true" ] &&
    test $(git diff --cached --name-only --diff-filter=A -z $against |
        LC_ALL=C tr -d '[ -~]\0' | wc -c) != 0
then
    iconv -f utf-8 <<EOF
Error: Attempt to add a non-ascii file name.

This can cause problems if you want to work
with people on other platforms.

To be portable it is advisable to rename the file.

If you know what you are doing you can disable this
check using:

  git config hooks.allownonascii true
EOF
    exit 1
fi


## policy_mandatory_file_format

# The mandatory file format policy tries to prevent accidentally
# checking-in files with noise.

allowsloppyfileformat=$(git config hooks.allowsloppyfileformat)

if [ "$allowsloppyfileformat" != "true" ]; then
    # If there are text files not encoded in utf-8, print the
    # offending file names and fail.
    git diff-index --cached --name-only $against \
        | env LANG=C xargs file -i \
        | sed -n -e '/: text\//p' \
        | grep -v 'charset=\(utf-8\|us-ascii\)'
    if [ $? -eq 0 ]; then
        iconv -f utf-8 <<EOF
Error: Attempt to commit a non utf-8 encoded text file.

The mandataory file format policy restricts the commit of non utf-8
encoded files.

If you know what you are doing you can disable this
check using:

  git config hooks.mandatoryfileformat false
EOF
        exit 1
    fi

    # If there are files ending with CRLF, print the offending file
    # names and fail.
    git diff-index --cached --name-only $against \
        | env LANG=C xargs file \
        | grep 'with CRLF.* line terminators'
    if [ $? -eq 0 ]; then
        iconv -f utf-8 <<EOF
Error: Attempt to commit a file with CRLF line terminators

The mandataory file format policy restricts the commit of files with
CRLF line terminators.

If you know what you are doing you can disable this
check using:

  git config hooks.allowsloppyfileformat false
EOF
        exit 1
    fi

    # If there are whitespace errors, print the offending file names
    # and fail.
    git diff-index --check --cached $against --

    if ! [ $? -eq 0 ]; then
        iconv -f utf-8 <<EOF
Error: Attempt to commit a file with spurious white space

The mandataory file format policy restricts the commit of files
containing trailing whitespace.

If you know what you are doing you can disable this
check using:

  git config hooks.mandatoryfileformat false
EOF
        exit 1
    fi
fi


# policy_scm_keywords

# Verifies checked-in files for SCM keywords.  We assume no trailing
# white space and handle expansion.

allowscmkeywords=$(git config hooks.allowscmkeywords)

if [ "$allowscmkeywords" != "true" ]; then
    git diff-index --cached --name-only $against \
        | xargs grep -H '\$\(CVS\|Id\)\(:.*\)*\$$'

    if [ $? -eq 0 ]; then
        iconv -f utf-8 <<EOF
Error: Attempt to add a file.with SCM keywords

The SCM keywords policy restricts the commit of files
containing SCM Keywords.

If you know what you are doing you can disable this
check using:

  git config hooks.allowscmkeywords false
EOF
        exit 1
    fi
fi
