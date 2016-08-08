SUBDIRS = armadito

bin_SCRIPTS = armadito-prelude-agent

EDIT = sed -e 's,[@]pythondir[@],$(pythondir),g' \
	-e 's,[@]pkgpythondir[@],$(pkgpythondir),g' \
	-e 's,[@]PACKAGE[@],$(PACKAGE),g' \
	-e 's,[@]VERSION[@],$(VERSION),g'

%: $(srcdir)/%.in Makefile
	$(EDIT) < $(srcdir)/$*.in > $*
	chmod +x $*

CLEANFILES = $(bin_SCRIPTS)
EXTRA_DIST = armadito-prelude-agent.in
