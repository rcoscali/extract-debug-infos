dnl Process this file with autoconf to produce a configure script.
AC_INIT(srm, 1.2.15)
AC_CONFIG_SRCDIR([extract-debug-infos.sh.in])
AM_INIT_AUTOMAKE

dnl Explore for resources (programs)
AC_PROG_MAKE_SET
AC_PROG_INSTALL
AC_CHECK_PROG([OBJCOPY_CMD], [objcopy], [objcopy], [], [$PATH$PATH_SEPARATOR/usr/sbin])
if test "x$OBJCOPY_CMD" = "x"; then
   AC_MSG_ERROR(["Didn't found objcopy command! Install binutils package."])
   
fi
AC_CHECK_PROG([CHMOD_CMD], [chmod], [chmod], [], [$PATH_SEPARATOR/bin$PATH$PATH_SEPARATOR/usr/sbin], [])
if test "x$CHMOD_CMD" = "x"; then
   AC_MSG_ERROR(["Didn't found chmod command! This is really weird, install coreutils !!."])
   
fi
AC_CHECK_PROG([STRIP_CMD], [strip], [strip], [], [$PATH$PATH_SEPARATOR/usr/sbin], [])
if test "x$STRIP_CMD" = "x"; then
   AC_MSG_ERROR(["Didn't found strip command! Install binutils package."])
   
fi

AC_SUBST(PREFIX, [${prefix}])
AC_SUBST(BINDIR, [${prefix}/bin])
AC_SUBST(OBJCOPY_CMD, [$OBJCOPY_CMD])
AC_SUBST([CHMOD_CMD], [$CHMOD_CMD])
AC_SUBST([STRIP_CMD], [$STRIP_CMD])

AC_CONFIG_MACRO_DIR(m4)
AC_CONFIG_FILES([Makefile extract-debug-infos.sh:extract-debug-infos.sh.in extract-debug-infos-from-dir.sh:extract-debug-infos-from-dir.sh.in extract-debug-infos-from-tree.sh:extract-debug-infos-from-tree.sh.in])
AC_OUTPUT
