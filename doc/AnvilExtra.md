# Extra git commands

After reading this page you will know:

 - How to use the `git releng` command to step through the release cycle.
 - How to use the `git recent` command to list recent commits.


## git releng

The `git releng` command steps through the release cycle, it has three
subcommands:

```console
Usage: git releng […]
 Release engineering
Options:
 -s NEXT
    Start release engineering for NEXT
 -r Rollout release candidate RC
 -f Rollout final release FINAL
```

We enter the release cycle for version 1.1.0 by issuing a `git releng
-s 1.1.0`.  This will checkout `master` and cut a release engineering
branch from here.  It needs a hook `update-version` to update versions
and the program will abort early if this hook is not defined.



## git recent

The `git recent` command lists the recent commits on the current
branch, this is mostly useful in conjunction with
`git commit --fixup`.

```console
% git recent
8040dd3 Write a tool to filter a repository with a sed script
d53f758 Write a tool to fix encodings in a repository
ba2b22a Write a tool to filter whitespace on a git repository
b3226bb Update version number
d055c6b Release Anvil v0.2.0
a9fb223 Briefly document our tools
de3cd69 Remove noisy header with timestamp and author
ff395f3 Remove test logic
26cf54a Write a command showing short SHA for recent commits
d8b4ee2 Use a more canonical way to copy file trees
10d00f8 Prepare prototype
8aab096 Start the Anvil project
```

If the ouyput is piped through `less` and you want to avoid this, the
easiest way is to pipe the ouput of the command through `cat` or
`head`.
