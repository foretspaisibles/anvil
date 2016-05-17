# AC_PATH_PROG_REQUIRE
# --------------------
# A variant of AC_PATCH_PROG which fails if it cannot find its
# program.

AC_DEFUN([AC_PATH_PROG_REQUIRE],
[AC_PATH_PROG([$1], [$2], [no])dnl
 AS_IF([test "${$1}" = 'no'], [AC_MSG_ERROR([Program $2 not found.])], [])])
