dnl Process this file with autoconf to produce a configure script.
AC_INIT(srm, 1.2.15)
AC_CONFIG_SRCDIR([extract-debug-infos.sh.in])
AM_INIT_AUTOMAKE

AC_PROG_INSTALL
AC_CHECK_PROG([OBJCOPY_CMD], [objcopy], [/usr/bin/objcopy], [$PATH$PATH_SEPARATOR/usr/sbin])
AC_CHECK_PROG([CHMOD_CMD], [chmod], [/usr/bin/chmod], [$PATH$PATH_SEPARATOR/usr/sbin])
AC_CHECK_PROG([STRIP_CMD], [strip], [/usr/bin/strip], [$PATH$PATH_SEPARATOR/usr/sbin])

AC_SUBST(OBJCOPY_CMD, [$OBJCOPY_CMD])
AC_SUBST([CHMOD_CMD], [$CHMOD_CMD])
AC_SUBST([STRIP_CMD], [$STRIP_CMD])

AC_CONFIG_MACRO_DIR
AC_CONFIG_FILES([Makefile extract-debug-infos.sh extract-debug-infos-from-dir.sh extract-debug-infos-from-tree.sh], [$CHMOD_CMD +x extract_debug_infos*.sh])
AC_OUTPUT
