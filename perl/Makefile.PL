use strict;
use warnings;
use inc::Module::Install;
use English qw(-no_match_vars);

name 'Armadito-Prelude';
include 'Module::AutoInstall';
abstract 'Armadito Prelude for Linux and Windows';
license 'gpl';
repository 'https://github.com/armadito/armadito-prelude';
version_from 'lib/Armadito/Prelude.pm';
perl_version '5.008';
authors 'Teclib';

requires 'UNIVERSAL::require' => '0';
requires 'Getopt::Long'       => '0';
requires 'Pod::Usage'         => '0';

test_requires 'XML::TreePP'         => '0';
test_requires 'Test::Compile'       => '0';
test_requires 'Test::More'          => '0';
test_requires 'Test::Perl::Critic'  => '0';
test_requires 'Test::Code::TidyAll' => '0';

install_script 'bin/armadito-prelude'       if ( $OSNAME ne "MSWin32" );
install_script 'bin/armadito-prelude-agent' if ( $OSNAME ne "MSWin32" );

resources
	homepage   => "http://www.teclib-edition.com/en/teclib-products/armadito-antivirus/",
	bugtracker => "https://github.com/armadito/armadito-prelude/issues",
	repository => "https://github.com/armadito/armadito-prelude",
	IRC        => "http://webchat.freenode.net/#armadito";

makemaker_args(
	test => {
		TESTS => join ' ',
		map {glob}
			qw(
			t/*.t
			t/*/*.t
			t/*/*/*.t
			t/*/*/*/*.t
			t/*/*/*/*/*.t
			)
	},
	INSTALLMAN3DIR => 'none'
);

WriteAll;

# substitute prefix everywhere
$MY::variables{SYSCONFDIR} =~ s/\$\(PREFIX\)/$MY::variables{PREFIX}/;
$MY::variables{DATADIR} =~ s/\$\(PREFIX\)/$MY::variables{PREFIX}/;
$MY::variables{LOCALSTATEDIR} =~ s/\$\(PREFIX\)/$MY::variables{PREFIX}/;

# look for already existing configuration file
my $config_file_message
	= -f "$MY::variables{SYSCONFDIR}/prelude.cfg"
	? "previous configuration file found, new one will be installed as prelude.cfg.new"
	: "no previous configuration file found, new one will be installed as prelude.cfg";

print <<EOF;

Installation summary
--------------------
prefix: $MY::variables{PREFIX}
configuration installation directory: $MY::variables{SYSCONFDIR}
constant data installation directory: $MY::variables{DATADIR}
variable data installation directory: $MY::variables{LOCALSTATEDIR}

$config_file_message
EOF

package MY;

use English qw(-no_match_vars);

our %variables;

# force a perl-independant prefix for everything
sub constants {
	my ($self) = @_;

	if ( $OSNAME eq "MSWin32" ) {
		%variables = (
			PREFIX               => 'C:\\Program Files\\Armadito-Prelude',
			INSTALLSCRIPT        => '$(PREFIX)\\bin',
			INSTALLSITESCRIPT    => '$(PREFIX)\\bin',
			INSTALLVENDORSCRIPT  => '$(PREFIX)\\bin',
			INSTALLLIB           => '$(DATADIR)\\lib',
			INSTALLSITELIB       => '$(DATADIR)\\lib',
			INSTALLVENDORLIB     => '$(DATADIR)\\lib',
			INSTALLMAN1DIR       => '$(PREFIX)\\share\\man\\man1',
			INSTALLSITEMAN1DIR   => '$(PREFIX)\\share\\man\\man1',
			INSTALLVENDORMAN1DIR => '$(PREFIX)\\share\\man\\man1',
			INSTALLMAN3DIR       => '$(PREFIX)\\share\\man\\man3',
			INSTALLSITEMAN3DIR   => '$(PREFIX)\\share\\man\\man3',
			INSTALLVENDORMAN3DIR => '$(PREFIX)\\share\\man\\man3',
			SYSCONFDIR           => '$(PREFIX)\\etc\\armadito-prelude',
			DATADIR              => '$(PREFIX)\\share\\armadito-prelude',
			LOCALSTATEDIR        => '$(PREFIX)\\var\\armadito-prelude',
		);
	}
	else {
		# for some reason, initialising variables from the global scope doesn't work
		%variables = (
			PREFIX               => '/usr/local',
			INSTALLSCRIPT        => '$(PREFIX)/bin',
			INSTALLSITESCRIPT    => '$(PREFIX)/bin',
			INSTALLVENDORSCRIPT  => '$(PREFIX)/bin',
			INSTALLLIB           => '$(DATADIR)/lib',
			INSTALLSITELIB       => '$(DATADIR)/lib',
			INSTALLVENDORLIB     => '$(DATADIR)/lib',
			INSTALLMAN1DIR       => '$(PREFIX)/share/man/man1',
			INSTALLSITEMAN1DIR   => '$(PREFIX)/share/man/man1',
			INSTALLVENDORMAN1DIR => '$(PREFIX)/share/man/man1',
			INSTALLMAN3DIR       => '$(PREFIX)/share/man/man3',
			INSTALLSITEMAN3DIR   => '$(PREFIX)/share/man/man3',
			INSTALLVENDORMAN3DIR => '$(PREFIX)/share/man/man3',
			SYSCONFDIR           => '$(PREFIX)/etc/armadito-prelude',
			DATADIR              => '$(PREFIX)/share/armadito-prelude',
			LOCALSTATEDIR        => '$(PREFIX)/var/armadito-prelude',
		);
	}

	# allow variables defined on command line to override defaults
	foreach my $name ( keys %variables ) {
		$variables{$name} = $self->{ARGS}->{$name} if $self->{ARGS}->{$name};
	}

	# get all standard MM variables definitions, and override them if needed
	my @code = split( /\n/, $self->SUPER::constants(@_) );
	foreach my $line (@code) {

		# Skip comments
		next if $line =~ /^\s*#/;

		# Skip everything which isn't a var assignment.
		next unless $line =~ /^([A-Z0-9_]+) =/;
		my $name = $1;

		# skip variables we're not interested
		next unless $variables{$name};

		$line = "$name = $variables{$name}";
	}

	# add out own variables
	foreach my $name (qw/SYSCONFDIR DATADIR LOCALSTATEDIR/) {
		push @code, "$name = $variables{$name}";
	}

	return join( "\n", @code );
}

sub install {
	my ($self) = @_;
	my $install = $self->SUPER::install(@_);

	# add dependency on data and configuration installation targets, and remove
	# dependency on perlocal installation target
	# depending on MakeMaker version, the line to match changes
	$install =~ s/install :: pure_install doc_install/install :: pure_install config_install data_install/;
	$install =~ s/install :: all pure_install doc_install/install :: all pure_install config_install data_install/;

	# suppress all lines related to packlist file installation
	$install =~ s/.*\.packlist \\\n//g;

	# add data and configuration installation targets

	if ( $OSNAME ne "MSWin32" ) {
		$install .= <<'EOF';

config_install :
	install -d -m 755 $(DESTDIR)$(SYSCONFDIR)
	if [ -f $(DESTDIR)/$(SYSCONFDIR)/prelude.cfg ]; then \
	    install -m 644 etc/prelude.cfg $(DESTDIR)$(SYSCONFDIR)/prelude.cfg.new; \
	else \
	    install -m 644 etc/prelude.cfg $(DESTDIR)$(SYSCONFDIR)/prelude.cfg; \
	fi

data_install :
	install -d -m 755 $(DESTDIR)$(DATADIR)
EOF
	}
	else {
		$install .= <<'EOF';

config_install :
	if not exist "$(DESTDIR)$(SYSCONFDIR)" mkdir "$(DESTDIR)$(SYSCONFDIR)"
	if exist "$(DESTDIR)/$(SYSCONFDIR)\\prelude.cfg" ( \
	    copy "etc\\prelude.cfg" "$(DESTDIR)$(SYSCONFDIR)\\prelude.cfg.new"; \
	) else ( \
	    copy "etc\\prelude.cfg" "$(DESTDIR)$(SYSCONFDIR)\\prelude.cfg"; \
	)

data_install :
	if not exist "$(DESTDIR)$(DATADIR)" mkdir "$(DESTDIR)$(DATADIR)"
	if not exist "$(DESTDIR)$(INSTALLSCRIPT)" mkdir "$(DESTDIR)$(INSTALLSCRIPT)"
	if exist "$(DESTDIR)$(INSTALLSCRIPT)\\armadito-prelude" @erase "$(DESTDIR)$(INSTALLSCRIPT)\\armadito-prelude"
	if exist "$(DESTDIR)$(INSTALLSCRIPT)\\armadito-prelude.bat" @erase "$(DESTDIR)$(INSTALLSCRIPT)\\armadito-prelude.bat"
	copy "bin\\armadito-prelude" "$(DESTDIR)$(INSTALLSCRIPT)\\armadito-prelude"
EOF
	}

	return $install;
}

# ensure binaries get modified to use configured directories (on Unix only)
sub installbin {
	my ($self) = @_;
	my $installbin = $self->SUPER::installbin(@_);

	return $installbin if $OSNAME eq 'MSWin32';

	$installbin =~ s|\t\$\(FIXIN\) (.*)\n|\t\$(FIXIN) $1\n\t\$(FINALIZE) $1\n|g;

	$installbin .= <<'EOF';
FINALIZE = $(ABSPERLRUN) -pi \
    -e 's|use lib .*|use lib "$(DATADIR)/lib";|;' \
    -e 's|confdir => .*|confdir => "$(SYSCONFDIR)",|;' \
    -e 's|datadir => .*|datadir => "$(DATADIR)",|;' \
    -e 's|libdir  => .*|libdir  => "$(DATADIR)/lib",|;' \
    -e 's|vardir  => .*|vardir  => "$(LOCALSTATEDIR)",|' \
    --
EOF
	return $installbin;
}
