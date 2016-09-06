AC_INIT(armadito-prelude,0.0.1,fdechelle@teclib.com)

AM_INIT_AUTOMAKE([foreign])

AC_ARG_WITH([libprelude-pythondir],
	AS_HELP_STRING([--with-libprelude-pythondir=PATH],[gives path to libprelude python binding]),
	libprelude_pythondir="$withval",
	libprelude_pythondir="none")
AC_SUBST(libprelude_pythondir)
AC_ARG_WITH([libprelude-libdir],
	AS_HELP_STRING([--with-libprelude-libdir=PATH],[gives path to libpreludecpp.so]),
	libprelude_libdir="$withval",
	libprelude_libdir="none")
AC_SUBST(libprelude_libdir)

AM_PATH_PYTHON([2.7])

AC_CONFIG_FILES([
Makefile
src/Makefile
src/armadito/Makefile
])
AC_OUTPUT
