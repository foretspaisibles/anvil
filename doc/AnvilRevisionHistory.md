# Rewrite Git revision history with specialised filters

The `git filter-branch` command allows to rewrite **Git** revision
history. This powerful feature is usually a bit difficult to use
because it requires a lot of preparation and pipe-fitting.q

This is why the **Anvil** project implements a few stock filters,
which can be readily used to rewrite a **Git** revision history.

After reading this page you will know how to rewrite a **Git**
revision history to:

 - convert text files from a legacy encoding to UTF-8.
 - remove spurious whitespaces.
 - rewrite and rename files using **sed** scripts.

**Attention** Do you have *fresh* and *verified* backups?  The
suggested workflow to use commands which rewrite **Git** history is to
test them on a *cloned* repository not on the actual repository.  Once
you have succesfully rewritten history and reviewed the rewritten
history, you can choose to discard the old repository and replace it
with the new one. This is a risky operation.


## Convert legacy encodings to UTF-8

The filter `anvil_encoding` rewrites **Git** revision history, looking
for text files and source code files written in a legacy encoding and
convert them to UTF-8.

    % anvil_encoding

Encoding detection is performed by the `file --mime` command. Only
files recognised as `text/*` by the `file --mime` command are
processed, with a few exceptions, correcting misdetections of
`file --mime`.


## Remove spurious whitespace

The filter `anvil_whitespace` rewrites **Git** revision history,
fixing whitespace related problems in th text files it finds. The
problems it handles are:

 - trailing whitespace, with proper handling of escaped final space `\ `;
 - MS-DOS and Max line terminators are converted to Unix.

    % anvil_whitespace


## Rewrite and rename files using sed scripts

The filter `anvil_sed` rewrites **Git** revision history, using a
**sed** filter to edit the text files it finds.  This can be used to
edit file headers in a batch or to remove SCM keywords when importing
history of another project, for instance.

    % anvil_sed edit.sed

A second **sed** script can be specified to rename files in the
repository.  This **sed** script reads filenames, relative to the root
of the repository and is expected to print a rename plan, looking like:

    actualname|newname

If your filenames contain a `|` character, you should not use
`anvil_sed`.  An example use of this additional feature would be:

    % anvil-sed -r rename.sed edit.sed

Note that there is no provision made to create missing directories
occuring in the rename plan, this is something you have to handle
seprately.
