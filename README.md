# Anvil, a software package assistant

Anvil is a software package assistant, which can be used to
initialise package repositories and add files to them based on
templates.  It also defines new git commands and git hooks.

It is written using the Bourne Shell and M4, and requires GNU
Autoconf, BSD Make and [BSD Owl](https://github.com/michipili/bsdowl)
to build and install.


## Guide to documentation

The documentation is held in the [doc](./doc) directory of this
repository.  Here are a few suggested starting points:

 - [Anvil template](./doc/AnvilTemplate.md) — Create new files based on a template
 - [Anvil revision history](./doc/AnvilRevisionHistory.md) – Rewrite Git revision history with specialised filters
 - [Anvil hooks](./doc/AnvilHooks.md) — Attach hooks to your git repository
 - [Anvil extra](./doc/AnvilExtra.md) — New git commands
 - [Anvil Travis CI](./doc/AnvilTravis.md) — Autoinstall script for
   ocamllers using Travis CI.

## Example of file creation

We produce a new `shell` file using the following command:

```console
% anvil_template -p shell anvil_tool.sh 'Another tool in the Anvil suite'
### anvil_tool.sh -- Another tool in the Anvil suite

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

### End of file `anvil_tool.sh'
```

## Example of hooks

The [pre-commit](./git-hooks/pre-commit.sh) can be used to enforce
several policies, related to whitespace or SCM words.
