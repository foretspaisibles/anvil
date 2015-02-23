### @autoconf_input@

ANVIL_RCS_KEYWORDS()dnl
ANVIL_LICENSE_BLOB()dnl

prefix?=		@prefix@
exec_prefix?=		@exec_prefix@
bindir?=		@bindir@
sbindir?=		@sbindir@
libexecdir?=		@libexecdir@
datarootdir?=		@datarootdir@
datadir?=		@datadir@
sysconfdir?=		@sysconfdir@
sharedstatedir?=	@sharedstatedir@
localstatedir?=		@localstatedir@
runstatedir?=		@runstatedir@
includedir?=		@includedir@
docdir?=		@docdir@
infodir?=		@infodir@
libdir?=		@libdir@
localedir?=		@localedir@
mandir?=		@mandir@

PREFIX?=		${prefix}
EXEC_PREFIX?=		${exec_prefix}
DATAROOTDIR?=		${datarootdir}

# Local Variables:
# mode: makefile
# End:

### End of file ``Makefile.config.in''
