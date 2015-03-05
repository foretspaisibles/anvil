# Anvil Package Tools

The package tools implemented in **Anvil** assist the package manager
in the creation of new new files.

After reading this page you will know:

- How to start a new software package supporting **Anvil** features.
- How to add a new file to this software package, using a template.


## Start a new software package supporting Anvil features

We initialise a new repository using the following command:

```console
% anvil_init newprojectdir
```

This creates a new directory, initialises it as a git repository and
populates it with a few infrastructure related files, like a minimal
configure script.

This command is interactive and asks a few questions.  The answers to
these questions are saved in the section `anvil` of the git
configuration of the repository.  It is possible to convert a pre-existing
repository just by completing the `anvil` section of the configuration file.


## Create a new file following a template

The template is mistly useful to put a consistent license header, with
project name, URL and everything.  This only works on the repository
of a package supporting **Anvil** features.


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
