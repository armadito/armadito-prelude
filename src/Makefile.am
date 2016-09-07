SUBDIRS = armadito

libexec_SCRIPTS=armadito-prelude-agent.py

bin_SCRIPTS = armadito-prelude-agent

EDIT = sed -e 's,[@]pythondir[@],$(pythondir),g' \
	-e 's,[@]pkgpythondir[@],$(pkgpythondir),g' \
	-e 's,[@]libprelude_pythondir[@],$(libprelude_pythondir),g' \
	-e 's,[@]libprelude_libdir[@],$(libprelude_libdir),g' \
	-e 's,[@]libexecdir[@],$(libexecdir),g' \
	-e 's,[@]PACKAGE[@],$(PACKAGE),g' \
	-e 's,[@]VERSION[@],$(VERSION),g'

%: $(srcdir)/%.in Makefile
	$(EDIT) < $(srcdir)/$*.in > $*
	chmod +x $*

CLEANFILES = $(bin_SCRIPTS)
EXTRA_DIST = armadito-prelude-agent.in
