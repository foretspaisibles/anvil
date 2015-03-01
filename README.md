# Anvil, a software package assistant

Anvil is a small software package assistant, which can be used to
initialise package repositories and add files to them using some
templates.

It is written using the Bourne Shell and M4, and requires GNU
Autoconf, BSD Make and [BSD Owl](https://github.com/michipili/bsdowl)
to build and install.


## Initialise a new repository

We initialise a new repository using the following command:

```console
% anvil_init newprojectdir
```

This creates a new directory, initialises it as a git repository and
populates it with a few infrastructure related files, like a minimal
configure script.

This command is interactive and asks a few questions.  The answers to
these questions are saved in the section `anvil` of the git
configuration of the repository.


## Create a new file following a template

We print a new `shell` file using the following command:

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

We can create the file with the following command:

```console
% anvil_template -p shell anvil_tool.sh 'Another tool in the Anvil suite'\
    anvil_tool.sh
```

Note that the name of the file appears two times, which is redundant
and should be changed in a future release.


We can list available templates:

```console
% anvil_template -l
        Makefile -- Makefile
           shell -- Shell script or library
  shell_autoconf -- Autoconf shell configuration
```
