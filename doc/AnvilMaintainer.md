# Environment for Maintainers

## NAME

**anvil_maintainer** — Toolkit for maintainer maintainers.


## SYNOPSIS

    anvil_maintainer [-bls] [-C CONFIGFILE] [-p PKGDIR][-c CONFDIR] [-i IMAGE] [SRCDIR]

Open a maintainer shell into the given *IMAGE*.  The *SRCDIR* is
mounted under `/var/anvil/src`, the *PKGDIR* under `/var/anvil/pkg`
and the *CONFDIR* under `/var/anvil/conf`.

The *CONFDIR* should contain a *gnupg* directory and a *ssh*
directory.


## OPTIONS

    -b Build the docker IMAGE
    -l List available IMAGES
    -s Drop to a shell in the given IMAGE
