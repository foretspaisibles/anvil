### debug.mk -- Debug configuration

# ${ANVIL_LICENSE_BLOB}

.if !empty(THISMODULE:Mocaml.*)
COMPILE=		byte_code
USES+=			debug
.endif

### End of file `debug.mk'
