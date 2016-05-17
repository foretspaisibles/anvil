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
populates it with files associated with the selected build-system.

This command is interactive and asks a few questions.  The answers to
these questions are saved in the section `anvil` of the git
configuration of the repository.  It is possible to convert a pre-existing
repository just by running `anvil_init -c` at the toplevel directory
of this repository.

The following fields must be supplied:

1. Package name (*package*) - The name of the software package, it
   should be a valid UNIX file name.

2. Vendor name (*vendorname*) - The name used to refer to the package,
   for instance in the documentation.

3. Author name (*author*) - The name of the author of the software
   package, as used in copyright notices.

4. Release officer (*officer*) - The release officer signing the
   release artefacts, it must be a valid GPG-key handle.

5. Package URL (*url*) - The URL of the software package website.

6. License (*license*) - The license under which the software package
   is distributed. The valid choices are `MIT` and `CeCILL-B`.

7. Build System (*build*) - The build system used to generate
   artefacts for the software package. The only valid choice is
   `bsdowl-autoconf`.


## Create a new file following a template

The template is mostly useful to put a consistent license header, with
project name, URL and everything.  This only works on the repository
of a package supporting **Anvil** features.


We instantiate a new `shell` file using the following command:

```console
% anvil_template -t shell -D 'Another tool in the Anvil suite' anvil_tool.sh
% cat anvil_tool.sh
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

We can list available templates:

```console
% anvil_template -l
        Makefile  A minimal Makefile
           ocaml  A simple OCaml file
           shell  A minimal shell script
  shell_autoconf  A shell script with autoconf directory names
```
