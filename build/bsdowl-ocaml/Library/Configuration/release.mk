### release.mk -- Release configuration

# ${ANVIL_LICENSE_BLOB}

.if !empty(THISMODULE:Mocaml.lib)
COMPILE=		byte_code
COMPILE+=		native_code
.endif

.if !empty(THISMODULE:Mocaml.prog)
COMPILE+=		native_code
.endif

### End of file `release.mk'
